# TableFlow — Документ для Backend

> **Версия:** MVP v1.0
> **Целевая аудитория:** Backend-разработчик
> **Оценочный срок:** 4 недели (1 разработчик)

---

## 1. Tech Stack

### Рекомендуемый стек

| Слой | Технология | Обоснование |
|------|------------|-------------|
| Язык | **Node.js 20 LTS + TypeScript** | Быстрая разработка, единый язык (можно делить типы с mobile) |
| Framework | **Fastify** | Быстрее Express, встроенная валидация схем |
| ORM | **Prisma** | Type-safe, простые миграции |
| БД | **PostgreSQL 16** | Нам нужны транзакции, надёжность |
| Cache / Queue | **Redis 7** | Session cache, rate limit, background jobs |
| Auth | **JWT (access + refresh)** | Stateless, mobile-friendly |
| Validation | **Zod** | Runtime + TS-типы |
| Test | **Vitest + Supertest** | Быстро, современно |
| Logging | **Pino** | Structured, fast |
| Deployment | **Docker + Railway/Fly.io/VPS** | Просто, недорого |

### Альтернативный стек (если команда предпочитает Python)
FastAPI + SQLAlchemy + Alembic + PostgreSQL + Redis. По производительности близко к Node.js, плюс в документации.

### ПОЧЕМУ именно так
- **Это не monorepo.** Backend-репо и mobile-репо отдельные. Проще.
- **Microservice — НЕТ.** MVP будет монолитом. Одно Fastify-приложение, одна БД, один deployment.
- **GraphQL — НЕТ.** REST достаточно.

## 2. Общий обзор архитектуры

```
┌─────────────────────────────────────────────┐
│              Mobile App (Flutter)            │
└──────────────────────┬──────────────────────┘
                       │ HTTPS + JWT
                       ▼
┌─────────────────────────────────────────────┐
│         Nginx / Caddy (TLS, rate limit)     │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────┐
│             Fastify API (Node.js)            │
│  ┌─────────────────────────────────────┐    │
│  │  Routes → Controllers → Services    │    │
│  │  Services → Repositories (Prisma)   │    │
│  │  Services → Redis (cache, lock)     │    │
│  └─────────────────────────────────────┘    │
└──────┬──────────────────────────┬───────────┘
       │                          │
       ▼                          ▼
┌──────────────┐         ┌──────────────┐
│  PostgreSQL  │         │    Redis     │
└──────────────┘         └──────────────┘
```

## 3. Структура папок

```
src/
├─ config/               # env, constants
├─ db/
│  ├─ schema.prisma     # prisma schema
│  └─ migrations/
├─ modules/
│  ├─ auth/             # login, register, refresh, invite code
│  ├─ users/            # user CRUD, role management
│  ├─ venues/           # venue CRUD
│  ├─ tables/           # table CRUD
│  ├─ sessions/         # session start/stop/cancel — сердце MVP
│  ├─ reports/          # reports aggregation
│  └─ subscriptions/    # subscription tracking
├─ common/
│  ├─ middleware/       # auth, role guard, error handler
│  ├─ errors/
│  └─ utils/
├─ tests/
│  └─ ...
├─ server.ts
└─ app.ts
```

Каждый модуль внутри содержит: `routes.ts`, `controller.ts`, `service.ts`, `repository.ts`, `schemas.ts`, `types.ts`, `*.test.ts`.

## 4. Модель данных (Prisma Schema)

```prisma
// schema.prisma

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// ========== USER ==========
enum UserRole {
  OWNER
  MANAGER
}

model User {
  id           String    @id @default(uuid())
  username     String    @unique               // для логина
  email        String?   @unique               // обязателен для владельца
  phone        String?
  name         String
  passwordHash String
  role         UserRole
  ownerId      String?                          // если manager — id владельца
  owner        User?     @relation("OwnerManagers", fields: [ownerId], references: [id])
  managers     User[]    @relation("OwnerManagers")

  venues       Venue[]   // если owner — его заведения
  sessions     Session[] // сессии, которые он открывал

  isActive     Boolean   @default(true)
  lastLoginAt  DateTime?
  createdAt    DateTime  @default(now())
  updatedAt    DateTime  @updatedAt
  deletedAt    DateTime?                         // soft delete

  @@index([ownerId])
  @@index([role])
}

// ========== INVITE CODE ==========
model InviteCode {
  id         String    @id @default(uuid())
  code       String    @unique                  // напр.: "TF-48X2KD"
  ownerId    String
  owner      User      @relation(fields: [ownerId], references: [id])
  isActive   Boolean   @default(true)
  expiresAt  DateTime?
  usedCount  Int       @default(0)
  createdAt  DateTime  @default(now())

  @@index([ownerId])
}

// ========== VENUE ==========
model Venue {
  id          String    @id @default(uuid())
  ownerId     String
  owner       User      @relation(fields: [ownerId], references: [id])
  name        String
  number      String                             // "Заведение #1"
  address     String?
  isActive    Boolean   @default(true)

  tables      Table[]
  sessions    Session[]
  subscriptions Subscription[]

  createdAt   DateTime  @default(now())
  updatedAt   DateTime  @updatedAt
  deletedAt   DateTime?

  @@index([ownerId])
}

// ========== TABLE ==========
enum TableStatus {
  AVAILABLE
  OCCUPIED
  // MAINTENANCE  -- для v2
}

model Table {
  id           String      @id @default(uuid())
  venueId      String
  venue        Venue       @relation(fields: [venueId], references: [id])
  number       String                             // "1", "2", "VIP-1"
  name         String?                            // опционально: "VIP Зал"
  hourlyRate   Int                                // сом, integer (без копеек)
  status       TableStatus @default(AVAILABLE)
  activeSessionId String?  @unique                // если есть активная сессия

  sessions     Session[]

  isActive     Boolean     @default(true)
  createdAt    DateTime    @default(now())
  updatedAt    DateTime    @updatedAt
  deletedAt    DateTime?

  @@index([venueId])
  @@index([status])
}

// ========== SESSION ==========
// Период, когда клиент сидит за столом
enum SessionStatus {
  ACTIVE
  COMPLETED
  CANCELLED        // запущено по ошибке, отменено в первые 60 сек
}

model Session {
  id              String        @id @default(uuid())
  tableId         String
  table           Table         @relation(fields: [tableId], references: [id])
  venueId         String                            // denormalized (быстрая отчётность)
  venue           Venue         @relation(fields: [venueId], references: [id])
  managerId       String
  manager         User          @relation(fields: [managerId], references: [id])

  startedAt       DateTime
  endedAt         DateTime?
  durationSeconds Int?                              // рассчитано, берётся из endedAt
  hourlyRateSnapshot Int                            // цена стола на момент старта (snapshot!)

  subtotal        Int?                              // сом, до скидки
  discountPercent Int           @default(0)         // 0-100
  totalAmount     Int?                              // сом, оплачено

  status          SessionStatus @default(ACTIVE)
  notes           String?                           // заметка менеджера, если надо

  createdAt       DateTime      @default(now())
  updatedAt       DateTime      @updatedAt

  @@index([tableId])
  @@index([venueId])
  @@index([managerId])
  @@index([startedAt])
  @@index([status])
}

// ========== SUBSCRIPTION ==========
enum SubscriptionStatus {
  TRIAL           // 14 дней пробный
  ACTIVE
  PAST_DUE        // оплата просрочена
  CANCELLED
}

model Subscription {
  id                String              @id @default(uuid())
  venueId           String
  venue             Venue               @relation(fields: [venueId], references: [id])
  status            SubscriptionStatus  @default(TRIAL)
  priceSom          Int                 @default(1000)
  trialEndsAt       DateTime?
  currentPeriodEnd  DateTime
  lastPaymentAt     DateTime?
  createdAt         DateTime            @default(now())
  updatedAt         DateTime            @updatedAt

  @@index([venueId])
  @@index([status])
}

// ========== AUDIT LOG (опционально, но рекомендуется) ==========
model AuditLog {
  id         String   @id @default(uuid())
  userId     String?
  action     String                          // "session.start", "session.end", "table.price_changed"
  entityType String
  entityId   String
  metadata   Json?
  ipAddress  String?
  createdAt  DateTime @default(now())

  @@index([userId])
  @@index([entityType, entityId])
  @@index([createdAt])
}
```

### Критичные решения по данным

- **`hourlyRateSnapshot`:** В момент старта сессии почасовая цена стола копируется. Если владелец меняет цену посреди сессии — текущая сессия не затрагивается. **Критично!**
- **Цены в `Int` (в сомах).** Не использовать float — ошибки floating point означают потерю дохода. Если нужны копейки — хранить `* 100`.
- **Soft delete:** Использовать `deletedAt`, hard delete нет. Нужно для исторических отчётов.
- **`activeSessionId` у Table:** Чтобы быстро находить активную сессию по столу. Осторожно с race condition (пункт 6).

## 5. API Endpoint'ы

Base URL: `https://api.tableflow.kg/v1`

Все запросы: `Content-Type: application/json`. Для endpoint'ов с авторизацией: `Authorization: Bearer <access_token>`.

### 5.1 Auth

```
POST   /auth/register/owner
  body: { name, email, phone, password, venueName, venueNumber }
  response: { user, accessToken, refreshToken, venue }

POST   /auth/register/manager
  body: { inviteCode, username, name, password }
  response: { user, accessToken, refreshToken }

POST   /auth/login
  body: { username, password }
  response: { user, accessToken, refreshToken }

POST   /auth/refresh
  body: { refreshToken }
  response: { accessToken, refreshToken }

POST   /auth/logout
  auth: required
  response: { success: true }

POST   /auth/forgot-password
  body: { email }
  response: { success: true }  // ссылка на email, в MVP только для владельца

POST   /auth/invite-code
  auth: owner
  response: { code, expiresAt }
```

### 5.2 Users (управление менеджерами — для владельца)

```
GET    /users/managers
  auth: owner
  response: [{ id, username, name, lastLoginAt, isActive, ...}]

PATCH  /users/managers/:id
  auth: owner
  body: { name?, isActive? }

DELETE /users/managers/:id       (soft delete)
  auth: owner

GET    /users/me
  auth: required
  response: { user, role, ... }
```

### 5.3 Venues

```
GET    /venues
  auth: required
  response: [{ id, name, number, tableCount, ... }]
  — Владелец: все его заведения
  — Менеджер: все заведения его владельца

POST   /venues
  auth: owner
  body: { name, number, address? }

GET    /venues/:id
  auth: required + access control

PATCH  /venues/:id
  auth: owner

DELETE /venues/:id        (soft, если есть активная сессия — отказ)
  auth: owner
```

### 5.4 Tables

```
GET    /venues/:venueId/tables
  auth: required
  response: [{ id, number, name, hourlyRate, status, activeSession?, ... }]

POST   /venues/:venueId/tables
  auth: owner
  body: { number, name?, hourlyRate }

GET    /tables/:id
  auth: required

PATCH  /tables/:id
  auth: owner
  body: { number?, name?, hourlyRate? }
  — Если hourlyRate меняется при активной сессии — текущая сессия не затрагивается (snapshot).

DELETE /tables/:id
  auth: owner
  — Если есть активная сессия — 409 Conflict.
```

### 5.5 Sessions (СЕРДЦЕ MVP)

```
POST   /tables/:tableId/sessions/start
  auth: required (владелец или менеджер)
  body: {}
  response: { session: { id, startedAt, table, hourlyRateSnapshot } }
  errors:
    - 409 TABLE_ALREADY_OCCUPIED
    - 404 TABLE_NOT_FOUND
    - 403 FORBIDDEN
  — Атомарная операция: проверка статуса стола + установка activeSessionId.
  — 'startedAt' пишет backend (не mobile). Защита от clock skew.

POST   /sessions/:id/cancel
  auth: required
  body: {}
  — Можно отменить только в первые 60 секунд.
  — Session.status = CANCELLED, стол снова AVAILABLE.
  errors:
    - 422 CANCEL_WINDOW_EXPIRED
    - 409 SESSION_NOT_ACTIVE

POST   /sessions/:id/end
  auth: required
  body: { discountPercent?: 0-100 }
  response: {
    session: {
      id, startedAt, endedAt, durationSeconds,
      subtotal, discountPercent, totalAmount
    }
  }
  — endedAt пишет backend (mobile предлагает, но решение за сервером).
  — Расчёт: subtotal = round(duration_in_hours * hourlyRateSnapshot)
            totalAmount = round(subtotal * (100 - discountPercent) / 100)

GET    /sessions/active
  auth: required
  response: [{ session }]
  — Все активные сессии. Для совместимости с главным экраном mobile.

GET    /sessions
  auth: required
  query: ?venueId=&tableId=&managerId=&from=&to=&status=&page=&limit=
  response: { items: [...], total, page, limit }
```

### 5.6 Reports

```
GET    /reports/summary
  auth: owner
  query: ?venueId=&from=&to=
  response: {
    totalRevenue, sessionCount,
    avgDurationSeconds, avgRevenuePerSession,
    byTable: [...],
    byManager: [...],
    byDayOfWeek: [...],
    byHourOfDay: [...]
  }

GET    /reports/timeseries
  auth: owner
  query: ?venueId=&from=&to=&granularity=day|week|month
  response: [{ bucket: "2026-04-01", revenue, sessionCount }]
```

### 5.7 Subscriptions

```
GET    /subscriptions
  auth: owner
  response: [{ venueId, status, currentPeriodEnd, ... }]

GET    /subscriptions/:venueId
  auth: owner

// Интеграция платежей — вне MVP.
// Админ вручную обновляет `lastPaymentAt` и `currentPeriodEnd`.
// В MVP это может быть CLI-инструментом для администратора.
```

## 6. Критичная бизнес-логика

### 6.1 Session Start — атомарность

Что будет, если два менеджера одновременно запустят один стол?

**Решение:** Всё внутри одной транзакции:

```typescript
await prisma.$transaction(async (tx) => {
  const table = await tx.table.findUnique({
    where: { id: tableId },
    select: { status: true, hourlyRate: true, venueId: true }
  });

  if (!table) throw new NotFoundError();
  if (table.status === 'OCCUPIED') throw new ConflictError('TABLE_ALREADY_OCCUPIED');

  // lock через SELECT ... FOR UPDATE
  await tx.$executeRaw`SELECT id FROM "Table" WHERE id = ${tableId} FOR UPDATE`;

  const session = await tx.session.create({
    data: {
      tableId,
      venueId: table.venueId,
      managerId,
      startedAt: new Date(),
      hourlyRateSnapshot: table.hourlyRate,
      status: 'ACTIVE'
    }
  });

  await tx.table.update({
    where: { id: tableId },
    data: { status: 'OCCUPIED', activeSessionId: session.id }
  });

  return session;
});
```

Альтернатива: Distributed lock в Redis через `SETNX table:{id}:lock`.

### 6.2 Расчёт времени и суммы

```typescript
function calculateSessionAmounts(session: Session, endedAt: Date) {
  const durationMs = endedAt.getTime() - session.startedAt.getTime();
  const durationSeconds = Math.floor(durationMs / 1000);
  const durationHours = durationSeconds / 3600;

  const rawSubtotal = durationHours * session.hourlyRateSnapshot;
  const subtotal = Math.round(rawSubtotal);  // в сомах

  const discountAmount = Math.round(subtotal * session.discountPercent / 100);
  const totalAmount = subtotal - discountAmount;

  return { durationSeconds, subtotal, totalAmount };
}
```

**На что обратить внимание:**
- Есть ли минимальная стоимость? (напр., за меньше 10 минут — плата за полные 10) — **В MVP нет**, не усложняем. На v2.
- Бесплатный пробный период? — **Нет**.
- Time zone: на сервере UTC. Бишкек — UTC+6. Клиенту возвращаем ISO 8601 + timezone.
- Считать в секундах или минутах? — **В секундах** (для точности), но отображать как `HH:MM`.

### 6.3 Cancel Window

```typescript
const CANCEL_WINDOW_SECONDS = 60;

function canCancelSession(session: Session): boolean {
  if (session.status !== 'ACTIVE') return false;
  const elapsedSeconds = (Date.now() - session.startedAt.getTime()) / 1000;
  return elapsedSeconds <= CANCEL_WINDOW_SECONDS;
}
```

### 6.4 Role-Based Access Control

Middleware:
```typescript
function requireRole(...roles: UserRole[]) {
  return async (req) => {
    if (!req.user || !roles.includes(req.user.role)) {
      throw new ForbiddenError();
    }
  };
}

// Владелец имеет доступ только к своим заведениям
// Менеджер — только к заведениям своего владельца
function requireVenueAccess(venueId: string, user: User) {
  if (user.role === 'OWNER') return venue.ownerId === user.id;
  if (user.role === 'MANAGER') return venue.ownerId === user.ownerId;
  return false;
}
```

На каждом endpoint'е venue/table/session должна быть проверка доступа.

### 6.5 Invite Code

```typescript
// Формат: TF-XXXXXX (6 буквенно-цифровых символов)
function generateInviteCode(): string {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // без O/0/I/1
  let code = 'TF-';
  for (let i = 0; i < 6; i++) {
    code += chars[Math.floor(Math.random() * chars.length)];
  }
  return code;
}
```

Срок действия кода: 7 дней. При регистрации по коду проверяется:
- Код активен
- Срок не истёк
- Владелец не удалён

## 7. Безопасность

- **Пароли:** Хешируются через Argon2id. Безопаснее, чем bcrypt.
- **JWT:** Access token — 15 минут, refresh token — 30 дней. Refresh хранится в БД (можно отозвать).
- **Rate limit:**
  - Login: 5/минуту/IP
  - Register: 3/час/IP
  - Остальные: 60/минуту/user
- **CORS:** Для mobile origin check не нужен, но для web admin — при необходимости включить.
- **HTTPS:** В production обязательно.
- **SQL injection:** Prisma параметризован, `$executeRaw` — использовать с осторожностью.
- **Audit log:** Критичные действия, за которыми владелец может следить (session start/end/cancel, изменение цены стола), логируются.
- **Soft delete:** Удаление обратимо. Важно для compliance.

## 8. Error Handling

Стандартный формат ошибки:
```json
{
  "error": {
    "code": "TABLE_ALREADY_OCCUPIED",
    "message": "У этого стола уже есть активная сессия.",
    "details": { "tableId": "..." }
  }
}
```

HTTP-коды:
- 200 / 201: Успех
- 400: Validation error
- 401: Нет авторизации / невалидный токен
- 403: Нет прав
- 404: Не найдено
- 409: Конфликт (напр., стол занят)
- 422: Не обрабатывается (нарушение business rule)
- 429: Rate limit
- 500: Серверная ошибка

## 9. Стратегия тестирования

- **Unit-тесты:** Уровень service, функции расчётов. Чистые функции вроде `calculateSessionAmounts`, `canCancelSession` — 100% coverage.
- **Integration-тесты:** По endpoint'ам, с реальной БД (Docker test container).
- **Критичные flow:**
  - Session start/end happy path
  - Session start race condition (два параллельных запроса)
  - Все сценарии access control
  - Границы cancel window
  - Расчёт времени — тестируем сессии 1 секунда, 1 час, 25 часов

Целевой coverage: 70%+. Критичные модули (sessions, auth): 90%+.

## 10. Deployment

### Dev-окружение
- Docker compose: app + postgres + redis
- `.env.example` в репозитории
- Seed-скрипт: создаёт тестовые данные

### Production
- **Вариант 1 (дёшево):** DigitalOcean Droplet (10$/мес) + managed PostgreSQL (15$/мес).
- **Вариант 2 (просто):** Railway (push проект — работает). ~20$/мес.
- **Вариант 3 (Европа):** Hetzner Cloud (4–8€/мес).

### CI/CD
- GitHub Actions
- В PR: тесты + lint
- Merge в main → deploy на staging
- Manual trigger → deploy на production

### Environment Variables

```
NODE_ENV=production
PORT=3000
DATABASE_URL=postgresql://...
REDIS_URL=redis://...
JWT_ACCESS_SECRET=...
JWT_REFRESH_SECRET=...
JWT_ACCESS_EXPIRY=15m
JWT_REFRESH_EXPIRY=30d
TRIAL_DAYS=14
SUBSCRIPTION_PRICE_SOM=1000
LOG_LEVEL=info
SENTRY_DSN=...
```

## 11. Monitoring & Logging

- **Sentry:** Exception tracking.
- **Pino + log aggregator:** Betterstack или Papertrail.
- **Uptime monitoring:** UptimeRobot (бесплатно).
- **Metrics:** Базово — endpoint `/health`, Prometheus-метрики через `prom-client` (для v2, в MVP не обязательно).

## 12. План разработки на 4 недели

**Неделя 1 — Foundation**
- Настройка проекта, Docker, CI
- Prisma schema + миграции
- Модуль Auth (register, login, refresh)
- Rate limit, middleware, error handler

**Неделя 2 — Core Entities**
- Venues CRUD
- Tables CRUD
- Users (управление менеджерами, invite code)
- Role-based access control
- Integration-тесты

**Неделя 3 — Sessions (самая критичная неделя)**
- Session start/cancel/end
- Concurrency handling
- Расчёт времени и суммы
- Безопасность транзакций
- Стресс-тесты

**Неделя 4 — Reports & Polish**
- Reports endpoints (aggregation queries)
- Subscriptions (basic)
- Audit log
- Документация (OpenAPI / Swagger)
- Production deployment
- Seed data + smoke test

## 13. Будущее (заметки на v2)

- Продажа напитков/товаров (products, order_items)
- Пауза/возобновление стола (таблица `sessionPauses`, вычитать из durationSeconds)
- Разные тарифы по времени (rate cards: будни день/вечер, выходные)
- Онлайн-платежи (интеграция MBank, Optima)
- WebSocket — обновление статуса стола в реальном времени
- Push-уведомления (FCM)
- Multi-tenancy (когда вырастем)

## 14. Открытые вопросы

- [ ] Как управляем time zone? Сервер в UTC, клиент — локальный. Для отчётов по датам нужна таймзона владельца.
- [ ] Учитывать ли cancelled-сессии в отчётности? (Моя рекомендация: нет.)
- [ ] Может ли менеджер отменять свою сессию так же, как завершать? Правило 60 сек — для кого?
- [ ] Может ли владелец запускать сессию в своём заведении? (Да, но в отчёте должен отображаться как «владелец».)
- [ ] Race: две попытки старта сессии в одну и ту же минуту — что должно произойти?
