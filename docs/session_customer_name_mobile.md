# Session — `customerName` Eklentisi (Mobile)

> **Amaç.** Session başlatılırken **opsiyonel** bir müşteri adı girilebilsin. Aktif session listesinde / masa kartında / detay ekranında bu ad görünür; manager böylece "şu müşteri" diye masayı bulabilir. Tamamlanmış session'larda da ad korunur, raporlarda gösterilir.
>
> **Bağlam.** Backend kontratı: [backend_doc/session_customer_name.md](../backend_doc/session_customer_name.md). Bu doc, monorepo'nun **hangi dosyalarında ne değişir** sorusunu cevaplar. Mimari ve isimlendirme kuralları için [code-rules.md](code-rules.md), `XxxExc` pipeline için [error-handling.md](error-handling.md), UI token'ları için [theme-system.md](theme-system.md) ve [ui-components.md](ui-components.md) geçerli — burada tekrar açıklanmaz.

---

## 0. Etkilenen yerler (özet)

```
packages/facility/lib/
  models/session_model.dart            ← +customerName alanı (+ .g.dart regen)
  source/remote/
    session_remote_source.dart         ← startSession imzası genişler
    session_remote_source_impl.dart    ← body'ye customerName eklenir (boşsa atlanır)
    session_remote_source_mock.dart    ← imza paritesi
  repository/session_repository.dart   ← passthrough

app/lib/features/tables/table_detail/
  cubits/table_detail_cubit/
    table_detail_cubit.dart            ← startSession({String? customerName})
  view/free_table_view.dart            ← "Başlat" akışı: bottom sheet → name → start
  widgets/
    start_session_sheet.dart           ← YENİ: opsiyonel ad girişi (AppTextField)
    session_info_card.dart             ← customerName satırı (varsa)
    occupied_table_body.dart           ← AppBar / başlık altı satırı

app/lib/features/home/widgets/
  <masa kartı widget'ı>                ← aktif session'da customerName etiketi (varsa)

app/lib/features/report/                ← session listeleyen yerlerde customerName kolonu

app/lib/l10n/arb/                      ← yeni anahtarlar (en/ru/ky), flutter gen-l10n
```

`FacilityExc` / `FacilityErrorCode` **değişmez** — backend tarafında 422 `INVALID_CUSTOMER_NAME` eklendi ama UI 80 karakter sınırını maxLength ile zaten engelleyeceği için domain enum'a yeni case eklemiyoruz; gelirse `unknown`'a düşer ve `ApiClientException.message` UI'a yansır. Sınır client tarafında bloklandığı için pratikte tetiklenmez.

---

## 1. `packages/facility` — model + source + repo

### `SessionModel`

[packages/facility/lib/models/session_model.dart](../packages/facility/lib/models/session_model.dart) içine **tek alan** eklenir; constructor, `props`, `.g.dart` regen.

```diff
 final class SessionModel extends Equatable {
   const SessionModel({
     required this.id,
     required this.tableId,
     required this.status,
     required this.startedAt,
+    this.customerName,
     this.totalPausedSeconds = 0,
     this.pausedAt,
     ...
   });
   ...
+  /// Optional customer label captured at session start. Immutable for the
+  /// life of the session — backend ignores updates from later requests.
+  final String? customerName;
   ...
   List<Object?> get props => [
     id,
     tableId,
     status,
     startedAt,
+    customerName,
     ...
   ];
 }
```

- `@JsonSerializable()` annotation aynen kalır; `make build-runner` ile `.g.dart` regen ve commit.
- `fromJson` workaround'u (active/paused → status) dokunulmadan kalır; yeni alan otomatik decode edilir (gelmemişse `null`).

### `SessionRemoteSource` arayüzü

[packages/facility/lib/source/remote/session_remote_source.dart](../packages/facility/lib/source/remote/session_remote_source.dart):

```diff
- Future<SessionModel> startSession(String tableId);
+ Future<SessionModel> startSession(String tableId, {String? customerName});
```

`pause` / `resume` / `finish` / `cancel` imzaları değişmez.

### `SessionRemoteSourceImpl`

[packages/facility/lib/source/remote/session_remote_source_impl.dart](../packages/facility/lib/source/remote/session_remote_source_impl.dart):

```diff
 @override
-Future<SessionModel> startSession(String tableId) {
+Future<SessionModel> startSession(String tableId, {String? customerName}) {
+  final trimmed = customerName?.trim();
   return _client
       .postType<SessionModel>(
         '/api/v1/session/start',
         fromJson: SessionModel.fromJson,
-        data: {'tableId': tableId},
+        data: {
+          'tableId': tableId,
+          if (trimmed != null && trimmed.isNotEmpty) 'customerName': trimmed,
+        },
       )
       .mapTo(FacilityExc.fromApiClientExc);
 }
```

- Trim + boş kontrolü burada; backend de zaten trim ediyor ama gereksiz alan göndermemek log gürültüsünü azaltır.
- `.mapTo(FacilityExc.fromApiClientExc)` korunur — yeni try/catch eklenmez.

### `SessionRemoteSourceMock`

[packages/facility/lib/source/remote/session_remote_source_mock.dart](../packages/facility/lib/source/remote/session_remote_source_mock.dart): imza güncellenir, mock döndürdüğü `SessionModel`'e gelen `customerName` set edilir. Hatasız parite — mock'ta da boşsa `null`.

### `SessionRepository`

[packages/facility/lib/repository/session_repository.dart](../packages/facility/lib/repository/session_repository.dart):

```diff
- Future<SessionModel> startSession(String tableId) {
-   return _remote.startSession(tableId);
+ Future<SessionModel> startSession(String tableId, {String? customerName}) {
+   return _remote.startSession(tableId, customerName: customerName);
 }
```

Düz passthrough — repo `final class`, interface yok ([code-rules.md § Repositories](code-rules.md#repositories)).

---

## 2. `app/lib/features/tables/table_detail` — başlatma akışı

### `TableDetailCubit.startSession`

[app/lib/features/tables/table_detail/cubits/table_detail_cubit/table_detail_cubit.dart](../app/lib/features/tables/table_detail/cubits/table_detail_cubit/table_detail_cubit.dart):

```diff
-Future<void> startSession() async {
+Future<void> startSession({String? customerName}) async {
   if (state is! TableDetailFree) return;
   final s = state as TableDetailFree;
   emit(s.copyWith(startStatus: const RequestLoading()));
   try {
-    final session = await _sessionRepo.startSession(s.table.id);
+    final session = await _sessionRepo.startSession(
+      s.table.id,
+      customerName: customerName,
+    );
     emit(TableDetailOccupied(table: s.table, session: session));
   } on Object catch (e) {
     emit(s.copyWith(startStatus: RequestFailure(e)));
   }
 }
```

State sınıflarına dokunulmaz — `customerName` zaten `SessionModel` içinde taşınır.

### UI — `StartSessionSheet` (YENİ)

Yeni dosya: `app/lib/features/tables/table_detail/widgets/start_session_sheet.dart`.

`showModalBottomSheet` ile açılan, opsiyonel ad alan küçük bir sheet. **`AppTextField`** kullanır ([ui-components.md § AppTextField](ui-components.md#apptextfield)); altta primary `AppButton` ("Başlat") + üstte "Atla / Boş başlat" linki. View ≤ 160 satır kuralı için ayrı widget dosyası gerekiyor — sheet'i `FreeTableView` içinde inline yazma.

İskelet (tam kod değil — token / l10n yerine kavram):

```dart
class StartSessionSheet extends StatefulWidget {
  const StartSessionSheet({super.key});

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const StartSessionSheet(),
    );
  }
  ...
}
```

`show` dönüşü:

- `null` → kullanıcı sheet'i kapattı, **session başlatma**.
- `''` → kullanıcı "Atla" dedi → cubit'e `customerName: null` ile gider.
- `'Asan'` → cubit'e `customerName: 'Asan'` ile gider.

Validation:

- `maxLength: 80` (kullanıcı görmeden de bloklanır, backend'in 422'sine düşmez).
- Validator gerekmez — ad opsiyonel; boş submit edilirse `null`'a çevrilir.
- `textInputAction: TextInputAction.done`, `keyboardType: TextInputType.name`, `textCapitalization: TextCapitalization.words`.

Sheet aynı sub-folder'ın widget'ı olduğu için sub-feature barrel'dan re-export edilir ([code-rules.md § Barrels are exhaustive](code-rules.md#barrels-are-exhaustive)).

### `FreeTableView` — Başlat butonunun davranışı

[app/lib/features/tables/table_detail/view/free_table_view.dart](../app/lib/features/tables/table_detail/view/free_table_view.dart) içinde FAB `onPressed` `widget.tableCubit.startSession`'a doğrudan bağlı. Onu küçük bir handler'a çevir:

```diff
-onPressed: isLoading ? null : widget.tableCubit.startSession,
+onPressed: isLoading ? null : () => _onStartPressed(context),
```

```dart
Future<void> _onStartPressed(BuildContext context) async {
  final customerName = await StartSessionSheet.show(context);
  if (customerName == null) return;
  await widget.tableCubit.startSession(
    customerName: customerName.isEmpty ? null : customerName,
  );
}
```

View dosyası ≤ 160 satır kuralı korunur (sheet ayrı widget'ta, helper tek metod). Logic inline değil; sheet kendi state'ini yönetir.

---

## 3. Aktif / bitmiş session'da `customerName`'in gösterimi

### `SessionInfoCard`

[app/lib/features/tables/table_detail/widgets/session_info_card.dart](../app/lib/features/tables/table_detail/widgets/session_info_card.dart): `customerName` doluysa en üste yeni bir `TableInfoRow` ekle:

```diff
 Column(
   children: [
+    if (session.customerName != null) ...[
+      TableInfoRow(
+        label: context.l10n.sessionCustomerNameLabel,
+        value: session.customerName!,
+      ),
+      const SizedBox(height: AppSpacing.x2),
+    ],
     TableInfoRow(
       label: context.l10n.tableDetailStartTime,
       ...
```

### `OccupiedTableBody` / başlık

[app/lib/features/tables/table_detail/widgets/occupied_table_body.dart](../app/lib/features/tables/table_detail/widgets/occupied_table_body.dart) AppBar başlığının altına küçük bir subtitle:
"`Müşteri: Asan`" — `context.appTextStyles.muted.bodySmall` ile. Doluysa göster, değilse rendering yok.

### Home — masa kartı

`features/home/widgets/` altındaki aktif masa kartına aynı kural: ad varsa masa numarası altında küçük bir satır. Tıklama / detay açma davranışı aynı.

### Reports

`features/report/`'taki session listelerinde mevcut satır şablonuna `customerName` kolonu eklenir (varsa, yoksa em-dash / boş). Filtreleme / arama **bu sürümde yapılmaz** — backend tarafı da v1'de filtreyi açmıyor.

---

## 4. Lokalizasyon

Üç ARB dosyasına ([app/lib/l10n/arb/](../app/lib/l10n/arb/)) yeni anahtarlar — `flutter gen-l10n` çalıştırılır:

| Anahtar                          | EN                              | RU                              | KY                              |
| -------------------------------- | ------------------------------- | ------------------------------- | ------------------------------- |
| `sessionCustomerNameLabel`       | "Customer"                      | "Клиент"                        | "Кардар"                        |
| `sessionCustomerNameFieldLabel`  | "Customer name (optional)"      | "Имя клиента (необязательно)"   | "Кардардын аты (милдеттүү эмес)"|
| `sessionCustomerNameHint`        | "e.g. Asan"                     | "напр. Асан"                    | "мис. Асан"                     |
| `sessionStartSheetTitle`         | "Start session"                 | "Начать сессию"                 | "Сессияны баштоо"               |
| `sessionStartSheetSkipCta`       | "Start without name"            | "Начать без имени"              | "Атсыз баштоо"                  |

Anahtar adlandırma `camelCase` ([code-rules.md § Localization](code-rules.md#localization)).

---

## 5. Build / kontrol listesi

1. `SessionModel` düzenlemesi sonrası **`make build-runner`** — `.g.dart` regen + commit (CI bunu zorlar).
2. `flutter gen-l10n` — yeni anahtarlar derlensin.
3. `melos run format` + `melos run analyze` + `melos run unit-test` (mock kullanan testler imza güncellemesi ister).
4. Manuel kontrol (golden path):
   - [ ] FAB'a bas → sheet açılır → ad gir → "Başlat" → session ACTIVE; detay kartında ad görünür.
   - [ ] FAB'a bas → sheet → ad girmeden "Atla" → session ACTIVE; ad satırı görünmez.
   - [ ] FAB'a bas → sheet'i kapat (back / dışına dokun) → session başlamaz, FAB eski hâlinde.
   - [ ] Ad ile başlatılmış session'ı pause/resume/finish → her durumda ad korunur, UI doğru gösterir.
   - [ ] `maxLength: 80` — TextField 81. karakteri girmiyor.
   - [ ] Home'daki aktif masa kartında ad altta görünür.
   - [ ] Reports session listesinde ad kolonu doluysa görünür.

---

## 6. Scope dışı (v1'de yapılmaz)

- "En sık gelen müşteri" sıralaması / arama — backend de v2'ye bıraktı.
- Müşteri adına göre filtreleme / autocomplete — endpoint yok, mobile de açmaz.
- Session ortasında ismi düzenleme — backend silent ignore ediyor, UI da düzenleme yolu sunmaz.
- Telefon / kart numarası alanları — sadece `customerName`. Daha fazla alan istenirse ayrı bir feature olarak gelir.
