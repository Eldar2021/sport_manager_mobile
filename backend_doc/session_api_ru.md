# Session Management API

Endpoint'ы для управления временем использования столов. Когда клиент садится за стол — сессия начинается, когда уходит — сессия завершается и принимается оплата. Если в процессе клиент делает перерыв, сессию можно поставить на паузу.

**Base URL:** `<BASE_URL>`
**Content-Type:** `application/json; charset=utf-8`
**Authorization:** Все endpoint'ы требуют `Bearer <accessToken>`.

---

## Общая логика и правила

### Жизненный цикл сессии

```
                     ┌──────────────┐
                     │ Стол свободен│
                     │ session=null │
                     └──────┬───────┘
                            │ start
                            ▼
                     ┌──────────────┐
                     │ ACTIVE       │◄──────────┐
                     └──┬────┬──────┘           │
                        │    │                  │ resume
                  pause │    │ finish           │
                        ▼    │                  │
                 ┌──────────┐│            ┌─────┴──────┐
                 │ PAUSED   │└─────────►  │ ACTIVE     │
                 │          │             │ (продолж.) │
                 └────┬─────┘             └────────────┘
                      │ finish
                      ▼
               ┌──────────────┐
               │ COMPLETED    │ ← сессия записана в БД
               │ оплата принят│   (учитывается в отчётах)
               └──────────────┘

  при start/active            при finish
  ───────────────             ─────────────
  cancel (60сек)
  ───────────────
   CANCELLED
   (не учитывается в отчётах)
```

### Критические правила

1. **Все timestamp'ы пишет backend.** Клиент не отправляет `startedAt`, `pausedAt`, `resumedAt`, `endedAt`. Это предотвращает ситуацию, когда manager меняет время на телефоне для фальсификации расчётов — **самое важное правило, защищающее владельца от менеджера**.

2. **Правило snapshot.** При старте сессии копируются значения `tarifAmount` и `tarifType` стола. Если владелец изменит тариф во время активной сессии — текущая сессия не затрагивается.

3. **Используй sessionId, а не tableId.** В endpoint'ах `pause`, `resume`, `finish`, `cancel` всегда работаем по `sessionId`. На одном столе со временем может быть много сессий.

4. **`tableId` только для `start`.** При создании новой сессии передаём `tableId`, потому что сессии ещё нет.

5. **На столе одновременно может быть только 1 активная сессия.** Активная сессия = `status = ACTIVE` или `status = PAUSED`. Повторная попытка start → `409 TABLE_HAS_ACTIVE_SESSION`.

6. **Завершённую сессию нельзя открыть повторно.** После ухода клиента стол снова свободен, для нового клиента создаётся новая сессия. **Один и тот же стол может использоваться 20 раз в день.**

7. **История пауз хранится на backend, в mobile не отдаётся.** Mobile использует только `totalPausedSeconds` для корректного отсчёта времени. Детальная история пауз остаётся в БД (для audit/отчётов).

---

## Роли и права (Authorization)

| Endpoint                        | OWNER | MANAGER |
| ------------------------------- | :---: | :-----: |
| POST `/session/start`           |   ✅   |    ✅    |
| POST `/session/{id}/pause`      |   ✅   |    ✅    |
| POST `/session/{id}/resume`     |   ✅   |    ✅    |
| POST `/session/{id}/finish`     |   ✅   |    ✅    |
| POST `/session/{id}/cancel`     |   ✅   |    ✅*   |

> *Manager может вызвать `cancel`, но **только в течение первых 60 секунд** после старта сессии. После истечения этого времени отменить может только owner.

---

## Response модели

Используются два типа response. Какой возвращается — зависит от endpoint'а.

### SessionLite

Для активной (ACTIVE или PAUSED) сессии. Возвращается в ответах `start`, `pause`, `resume` и в карточке стола на Home-экране.

```ts
{
  id: string (uuid),
  tableId: string (uuid),
  status: "ACTIVE" | "PAUSED",
  startedAt: string (ISO 8601),
  totalPausedSeconds: integer,         // для подсчёта таймера на mobile
  pausedAt: string (ISO 8601) | null,  // заполнено если PAUSED, null если ACTIVE
  tarifAmountSnapshot: integer,
  tarifTypeSnapshot: "MINUTE" | "HOUR" | "DAY"
}
```

### SessionResult

Для завершённой сессии. Возвращается в ответах `finish` и `cancel`.

```ts
{
  id: string (uuid),
  tableId: string (uuid),
  status: "COMPLETED" | "CANCELLED",
  startedAt: string (ISO 8601),
  endedAt: string (ISO 8601),

  // заполнено если COMPLETED, null если CANCELLED:
  durationSeconds: integer | null,
  subtotal: integer | null,
  discountPercent: integer | null,
  totalAmount: integer | null,

  // заполнено если CANCELLED, null если COMPLETED:
  cancelReason: string | null
}
```

### Формулы расчёта

```
billableSeconds = (endedAt - startedAt) - totalPausedSeconds

# в зависимости от tarifType:
if HOUR:    billableUnits = billableSeconds / 3600
if MINUTE:  billableUnits = billableSeconds / 60
if DAY:     billableUnits = billableSeconds / 86400

subtotal       = round(billableUnits * tarifAmountSnapshot)
discountAmount = round(subtotal * discountPercent / 100)
totalAmount    = subtotal - discountAmount
```

> **Округление:** Стандартное математическое округление (0.5 → вверх). Без копеек, все суммы — целые числа.

---

## Стандартная структура ошибок

```json
{
  "code": "TABLE_HAS_ACTIVE_SESSION",
  "message": {
    "en": "Table already has an active session",
    "ru": "Стол уже имеет активную сессию",
    "ky": "Стол активдүү сессияга ээ"
  },
  "details": null
}
```

### Коды ошибок, специфичные для сессии

| Code                        | HTTP | Значение                                                       |
| --------------------------- | :--: | -------------------------------------------------------------- |
| `SESSION_NOT_FOUND`         | 404  | Сессия не найдена                                              |
| `TABLE_NOT_FOUND`           | 404  | Стол не найден                                                 |
| `TABLE_HAS_ACTIVE_SESSION`  | 409  | На столе уже есть активная/paused сессия                       |
| `SESSION_NOT_ACTIVE`        | 409  | Сессия не в статусе ACTIVE (например, уже paused или completed)|
| `SESSION_NOT_PAUSED`        | 409  | Сессия не в статусе PAUSED (resume невозможен)                 |
| `SESSION_ALREADY_COMPLETED` | 409  | Сессия уже завершена, действие невозможно                      |
| `CANCEL_WINDOW_EXPIRED`     | 422  | Истекло 60-секундное окно отмены                               |
| `INVALID_DISCOUNT`          | 422  | Скидка вне диапазона 0-100                                     |

---

## Endpoints

### 1. Start Session

При нажатии на свободный стол manager жмёт кнопку start. Создаётся новая сессия.

**Endpoint:**
```
POST /api/v1/session/start
```

**Body:**
```json
{
  "tableId": "660e8400-e29b-41d4-a716-446655440001"
}
```

> `startedAt` не передаётся в body. Backend использует своё серверное время.

**Validation:**
| Field    | Type | Required | Правила                          |
| -------- | ---- | :------: | -------------------------------- |
| tableId  | uuid |    ✅     | Стол, доступный пользователю     |

**Response (201) — SessionLite:**
```json
{
  "id": "770e8400-e29b-41d4-a716-446655440002",
  "tableId": "660e8400-e29b-41d4-a716-446655440001",
  "status": "ACTIVE",
  "startedAt": "2026-04-27T18:42:00.000Z",
  "totalPausedSeconds": 0,
  "pausedAt": null,
  "tarifAmountSnapshot": 250,
  "tarifTypeSnapshot": "HOUR"
}
```

**Errors:**
- `404 TABLE_NOT_FOUND`
- `409 TABLE_HAS_ACTIVE_SESSION`
- `403 FORBIDDEN`

**Race condition:** Backend блокирует стол внутри транзакции. Если приходят два параллельных запроса start — один пройдёт, второй получит 409.

---

### 2. Pause Session

Когда клиент выходит покурить / в туалет — сессия ставится на паузу. Таймер останавливается.

**Endpoint:**
```
POST /api/v1/session/{id}/pause
```

**Path Params:**
- `id` (uuid) — ID сессии

**Body:** Пустое — `{}`

> `pausedAt` не передаётся в body. Backend пишет своё серверное время.

**Response (200) — SessionLite:**
```json
{
  "id": "770e8400-e29b-41d4-a716-446655440002",
  "tableId": "660e8400-e29b-41d4-a716-446655440001",
  "status": "PAUSED",
  "startedAt": "2026-04-27T18:42:00.000Z",
  "totalPausedSeconds": 0,
  "pausedAt": "2026-04-27T19:02:00.000Z",
  "tarifAmountSnapshot": 250,
  "tarifTypeSnapshot": "HOUR"
}
```

**Примечания:**
- Одну сессию можно ставить на паузу **несколько раз**.
- Пока сессия на паузе, `totalPausedSeconds` не обновляется — обновится при resume.

**Errors:**
- `404 SESSION_NOT_FOUND`
- `409 SESSION_NOT_ACTIVE`
- `403 FORBIDDEN`

---

### 3. Resume Session

Возвращение из паузы.

**Endpoint:**
```
POST /api/v1/session/{id}/resume
```

**Path Params:**
- `id` (uuid) — ID сессии

**Body:** Пустое — `{}`

**Response (200) — SessionLite:**
```json
{
  "id": "770e8400-e29b-41d4-a716-446655440002",
  "tableId": "660e8400-e29b-41d4-a716-446655440001",
  "status": "ACTIVE",
  "startedAt": "2026-04-27T18:42:00.000Z",
  "totalPausedSeconds": 600,
  "pausedAt": null,
  "tarifAmountSnapshot": 250,
  "tarifTypeSnapshot": "HOUR"
}
```

**Примечания:**
- `totalPausedSeconds` теперь обновлён (10 минут = 600 секунд).
- Если будет ещё одна пауза — `totalPausedSeconds` накопительно увеличится.
- `pausedAt` теперь null (статус PAUSED → ACTIVE).

**Errors:**
- `404 SESSION_NOT_FOUND`
- `409 SESSION_NOT_PAUSED`
- `403 FORBIDDEN`

---

### 4. Finish Session

Клиент уходит, принимается оплата, сессия завершается. **За один шаг выполняется и расчёт, и сохранение.**

**Endpoint:**
```
POST /api/v1/session/{id}/finish
```

**Path Params:**
- `id` (uuid) — ID сессии

**Body:**
```json
{
  "discountPercent": 10
}
```

**Validation:**
| Field           | Type    | Required | Правила              |
| --------------- | ------- | :------: | -------------------- |
| discountPercent | integer |    ❌     | 0-100, по умолчанию 0|

> `endedAt` не передаётся в body. Backend пишет своё серверное время.

**Логика backend:**
1. Если сессия в статусе PAUSED — автоматически делается resume, затем finish.
2. `endedAt` = now (server time)
3. `durationSeconds` = (endedAt - startedAt) - totalPausedSeconds
4. `subtotal` = round(durationSeconds / unitDivisor × tarifAmountSnapshot)
5. `totalAmount` = subtotal - round(subtotal × discountPercent / 100)
6. Status = COMPLETED, стол освобождается.

**Response (200) — SessionResult:**
```json
{
  "id": "770e8400-e29b-41d4-a716-446655440002",
  "tableId": "660e8400-e29b-41d4-a716-446655440001",
  "status": "COMPLETED",
  "startedAt": "2026-04-27T18:42:00.000Z",
  "endedAt": "2026-04-27T20:12:00.000Z",
  "durationSeconds": 4800,
  "subtotal": 333,
  "discountPercent": 10,
  "totalAmount": 300,
  "cancelReason": null
}
```

**Пример расчёта:**
- Общее время: 18:42 → 20:12 = 90 минут = 5400 секунд
- Пауза: 600 секунд
- billableSeconds: 5400 - 600 = 4800 секунд = 80 минут = 1.333 часа
- subtotal: round(1.333 × 250) = 333 KGS
- discount: round(333 × 10 / 100) = 33 KGS
- totalAmount: 333 - 33 = 300 KGS

**Примечания:**
- После finish стол сразу доступен для нового клиента.

**Errors:**
- `404 SESSION_NOT_FOUND`
- `409 SESSION_ALREADY_COMPLETED`
- `422 INVALID_DISCOUNT`
- `403 FORBIDDEN`

---

### 5. Cancel Session

Случай «случайно нажал start». Сессия отменяется и не учитывается в отчётах.

**Endpoint:**
```
POST /api/v1/session/{id}/cancel
```

**Path Params:**
- `id` (uuid) — ID сессии

**Body:**
```json
{
  "reason": "Нажал не на тот стол"
}
```

**Validation:**
| Field  | Type   | Required | Правила         |
| ------ | ------ | :------: | --------------- |
| reason | string |    ✅     | 1-200 символов  |

> Manager может отменить сессию **только в течение первых 60 секунд**. По истечении этого времени → `422 CANCEL_WINDOW_EXPIRED`. После этого отмену может выполнить только owner.

**Response (200) — SessionResult:**
```json
{
  "id": "770e8400-e29b-41d4-a716-446655440002",
  "tableId": "660e8400-e29b-41d4-a716-446655440001",
  "status": "CANCELLED",
  "startedAt": "2026-04-27T18:42:00.000Z",
  "endedAt": "2026-04-27T18:42:30.000Z",
  "durationSeconds": null,
  "subtotal": null,
  "discountPercent": null,
  "totalAmount": null,
  "cancelReason": "Нажал не на тот стол"
}
```

**Примечания:**
- Cancelled сессия освобождает стол.
- Cancelled сессии **отображаются в отчётах** (для audit), но **не учитываются** в расчёте выручки.
- Owner должен видеть в месячном отчёте: «Manager X отменил 12 сессий за месяц» — для выявления подозрительной активности.

**Errors:**
- `404 SESSION_NOT_FOUND`
- `409 SESSION_ALREADY_COMPLETED`
- `422 CANCEL_WINDOW_EXPIRED`
- `403 FORBIDDEN`

---

## Сводная таблица endpoints

| Method | Path                              | Тип response   | Auth   | Cancel Window  |
| ------ | --------------------------------- | -------------- | ------ | -------------- |
| POST   | `/api/v1/session/start`           | SessionLite    | Both   | —              |
| POST   | `/api/v1/session/{id}/pause`      | SessionLite    | Both   | —              |
| POST   | `/api/v1/session/{id}/resume`     | SessionLite    | Both   | —              |
| POST   | `/api/v1/session/{id}/finish`     | SessionResult  | Both   | —              |
| POST   | `/api/v1/session/{id}/cancel`     | SessionResult  | Both*  | 60сек (manager)|

*Для manager отмена доступна только в течение 60 секунд; затем — только owner.

---

## Примечания для Mobile

### Расчёт таймера сессии (Client-Side)

При отображении живого таймера на телефоне manager'а:

```
# при ACTIVE:
elapsedSeconds = (now - startedAt) - totalPausedSeconds

# при PAUSED:
elapsedSeconds = (pausedAt - startedAt) - totalPausedSeconds
```

- Сессия ACTIVE: таймер постоянно увеличивается.
- Сессия PAUSED: таймер останавливается, остаётся фиксированным согласно `pausedAt`.
- Разница между серверным и клиентским временем (`server_time_offset`) должна вычисляться при login и применяться к таймеру.

### Правило UI для Pause/Resume

- Сессия ACTIVE: видны кнопки `[Пауза]` и `[Завершить]`.
- Сессия PAUSED: видны кнопки `[Продолжить]` и `[Завершить]`. Таймер становится серым.

### Видимость кнопки Cancel

- Первые 60 секунд: для manager'а видна кнопка `[Ошибочный старт]`.
- После 60 секунд кнопка скрывается у manager'а.
- Owner видит её всегда.

---

## Открытые вопросы / Решения, которые нужно принять

- [ ] Достаточно ли 60 секунд для manager'а на cancel? Нужно практическое тестирование.
- [ ] Может ли пауза длиться неограниченно? (например, клиент вышел покурить на 3 часа?) Нужен ли автоматический timeout / auto-resume?
- [ ] Действительно ли нужен `tarifType: DAY` для MVP?
- [ ] Нужен ли отдельный endpoint `GET /sessions/active` для получения списка активных сессий?
