# Theme Refactor Plan

> Hedef: `app/lib/ui/theme/` klasörünü modüler, ölçeklenebilir, sürdürülebilir hale getirmek. Light/Dark theme'ler arasındaki yapısal duplikasyonu yok etmek.

---

## 1. Mevcut Durum (Sorunlar)

```
app/lib/ui/theme/
├── app_colors.dart       (47 satır — flat constants, semantic + neutral + surface karışık)
├── app_spacing.dart      (62 satır — AppSpacing + AppRadius + AppShadow tek dosyada)
├── app_typography.dart   (98 satır — TextStyle + TextTheme builder tek dosyada)
├── app_theme.dart        (619 satır — light/dark için tüm component'ler iki kez)
└── theme.dart            (barrel)
```

**Belirlenen sorunlar:**

1. **`app_theme.dart` şişmiş (619 satır).** AppBar, Card, Button×4, Input, BottomSheet, Dialog, Chip, Divider, SnackBar, ListTile, Switch, ProgressIndicator, NavigationBar, PopupMenu, Tooltip — hepsi `_buildDark()` ve `_buildLight()` içinde **tekrar tekrar** yazılmış. Tek farkları renkler.
2. **AppSpacing + AppRadius + AppShadow tek dosyada.** Üçü farklı sorumluluk; ayrı dosyalarda olmalı.
3. **AppColors tek dosyada flat.** Brand / semantic / neutral / surface birbirine karışmış. Light–dark farklılık taşıyan veriler ColorScheme dışında ayrı bir `ThemeExtension` ile sunulmuyor; widget'lar `AppColors.*` constant'larını doğrudan import ediyor (M3 dışında değişen renkler için adapt etmiyor).
4. **Typography'de varyant yok.** `error` text stili, `disabled`, `muted` gibi türevler ad-hoc `.copyWith(color: ...)` ile her widget'ta üretiliyor.
5. **`textTheme.headlineSmall.copyWith(color: ...)` zincirleri** dialog/appbar içinde tekrarlanıyor — TextTheme zaten `displayColor` ile renklendirildiği için bu copyWith'ler çoğu zaman gereksiz.
6. **Magic value:** `Color(0x33D97706)` (brandAmber %20 alpha) NavigationBar indicator için inline yazılmış; semantic isim yok.

---

## 2. Hedef Klasör Yapısı

```
app/lib/ui/theme/
├── theme.dart                       ← public barrel (dışa açılan tek import noktası)
├── app_theme.dart                   ← AppTheme.light / AppTheme.dark final assembly (≤80 satır)
│
├── colors/
│   ├── colors.dart                  ← barrel
│   ├── brand_colors.dart            ← BrandColors (Amber paleti)
│   ├── semantic_colors.dart         ← SemanticColors (success/danger/warning/info)
│   ├── neutral_colors.dart          ← NeutralColors (ink scale + white)
│   ├── surface_colors.dart          ← SurfaceColors (dark/light bg paletleri)
│   ├── color_schemes.dart           ← AppColorSchemes.dark / .light (Material ColorScheme)
│   └── app_colors_extension.dart    ← AppColorsExt: ThemeExtension — M3 dışı semantic renkler
│
├── tokens/
│   ├── tokens.dart                  ← barrel
│   ├── app_spacing.dart             ← AppSpacing
│   ├── app_radius.dart              ← AppRadius
│   └── app_shadow.dart              ← AppShadow
│
├── typography/
│   ├── typography.dart              ← barrel
│   ├── app_text_styles.dart         ← AppTextStyles (raw TextStyle constants)
│   ├── app_text_theme.dart          ← AppTextTheme.build(Color) → TextTheme (Material rolleri)
│   └── app_text_theme_extension.dart ← AppTextThemeExt: error/disabled/muted varyantları
│
└── components/
    ├── components.dart              ← barrel
    ├── app_bar_component_theme.dart
    ├── bottom_sheet_component_theme.dart
    ├── button_component_theme.dart           ← filled / elevated / outlined / text
    ├── card_component_theme.dart
    ├── chip_component_theme.dart
    ├── dialog_component_theme.dart
    ├── divider_component_theme.dart
    ├── input_component_theme.dart
    ├── list_tile_component_theme.dart
    ├── navigation_bar_component_theme.dart
    ├── popup_menu_component_theme.dart
    ├── progress_indicator_component_theme.dart
    ├── snackbar_component_theme.dart
    ├── switch_component_theme.dart
    └── tooltip_component_theme.dart
```

---

## 3. Tasarım Prensipleri

### 3.1. "Tek tema, iki ColorScheme"

Component theme'ler **`ColorScheme` ve `TextTheme`'den türetilir** — light/dark farkı yalnızca bu iki girdide yatar. Component theme builder'ları `Brightness` bilmez (ihtiyaç olduğunda `colors.brightness` üzerinden alır).

```dart
abstract final class CardComponentTheme {
  static CardThemeData build(ColorScheme colors) => CardThemeData(
    color: colors.surface,
    elevation: 0,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.cardBorderRadius),
    margin: EdgeInsets.zero,
  );
}
```

Tek bir `build()` fonksiyonu hem light hem dark için çalışır; renkler `ColorScheme`'den gelir.

### 3.2. Yapısal fark gereken yerlerde brightness branch

Mevcut kodda sadece **OutlinedButton** light/dark arasında yapısal olarak farklı (light: `side: none`, ink100 bg; dark: gerçek outlined). Bu istisnayı builder içinde `colors.brightness` ile yönetiyoruz:

```dart
abstract final class ButtonComponentTheme {
  static OutlinedButtonThemeData outlined(ColorScheme colors) {
    final isDark = colors.brightness == Brightness.dark;
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: isDark ? null : colors.surfaceContainerHighest,
        foregroundColor: isDark ? colors.primary : colors.onSurface,
        side: isDark ? BorderSide(color: colors.outline) : BorderSide.none,
        // ortak kısımlar:
        disabledForegroundColor: colors.onSurface.withValues(alpha: 0.38),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonBorderRadius),
        minimumSize: const Size(double.infinity, 56),
        textStyle: AppTextStyles.button,
      ),
    );
  }
}
```

> Not: ileride bu farklılığı tasarımcı ile gözden geçirmek değer — ama şu an parite korunuyor.

### 3.3. ColorScheme + ThemeExtension ayrımı

| Veri tipi                                           | Nerede yaşar                                |
| --------------------------------------------------- | ------------------------------------------- |
| Material 3 standardındaki renkler                   | `ColorScheme` (`colors/color_schemes.dart`) |
| Sabit (mode-bağımsız) marka constant'ları           | `BrandColors`, `NeutralColors` const        |
| Light/dark'a göre değişen marka **olmayan** renkler | `AppColorsExt` (ThemeExtension)             |

`AppColorsExt` örnek alanları (M3 dışında kalanlar):

```dart
final class AppColorsExt extends ThemeExtension<AppColorsExt> {
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color info;
  final Color brandAmberSoft;     // navigation indicator vb. transparent overlay
  final List<BoxShadow> shadowSm;
  final List<BoxShadow> shadowMd;
  final List<BoxShadow> shadowLg;
  // copyWith / lerp...
}
```

`ColorScheme` zaten `primary/secondary/tertiary/error` ve `*Container` varyantlarını sağladığı için success/warning/info'yu **secondary** veya **tertiary**'e map etmek bir alternatif — ama bu uygulamada secondary zaten "olive" (yeşil) için kullanılıyor. Net yol: success/warning/info'yu `AppColorsExt`'e koymak ve secondary'yi olive yerine başka bir role kaydırmak (ileri iş, opsiyonel).

Widget'lar `AppColors.successGreen` yerine:

```dart
Theme.of(context).extension<AppColorsExt>()!.success
// veya kısa erişim:
context.appColors.success   // BuildContext extension üzerinden
```

### 3.4. Typography varyantları

Raw `TextStyle` constant'ları renksiz tutulur (Material `bodyColor`/`displayColor` ile uygulanır). Türev varyantlar (`error`, `disabled`, `muted`, `link`) `AppTextThemeExt` içinde belirli bir TextTheme + ColorScheme'den türetilir:

```dart
final class AppTextThemeExt extends ThemeExtension<AppTextThemeExt> {
  final TextStyle bodyError;
  final TextStyle bodyDisabled;
  final TextStyle bodyMuted;
  final TextStyle captionError;
  final TextStyle link;
  // copyWith / lerp
}
```

Fabrika:

```dart
AppTextThemeExt.from(textTheme: ..., colors: ...)
```

Kullanım:

```dart
Text(error.message, style: context.appTextStyles.bodyError)
```

Bu sayede her widget'ta `Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.dangerRed)` zincirinden kurtuluyoruz.

### 3.5. Token dosyaları

Her token sınıfı kendi dosyasında, `abstract final class` + `static const` üyeler olarak. Mevcut API isimleri korunur (`AppSpacing.x4`, `AppRadius.cardBorderRadius`, `AppShadow.md`) — değişen sadece klasör.

`AppShadow` artık ThemeExtension'a paralel olarak hem `tokens/app_shadow.dart`'ta sabit liste, hem de `AppColorsExt`'te referans olarak yaşar (light/dark'ta farklı opacity gerekirse). Şu an `Color(0x14000000)` gibi sabit black overlay kullandığımız için ek değişiklik gerekmiyor; ileride mode-aware shadow gerekirse extension üzerinden eklenir.

---

## 4. Final Assembly: `app_theme.dart`

Hedef: ≤ 80 satır.

```dart
abstract final class AppTheme {
  static ThemeData get dark => _build(
    colors: AppColorSchemes.dark,
    scaffoldBackground: SurfaceColors.darkBgPrimary,
    overlayStyle: SystemUiOverlayStyle.light,
    extensions: [AppColorsExt.dark, AppTextThemeExt.dark],
  );

  static ThemeData get light => _build(
    colors: AppColorSchemes.light,
    scaffoldBackground: SurfaceColors.bgWarm,
    overlayStyle: SystemUiOverlayStyle.dark,
    extensions: [AppColorsExt.light, AppTextThemeExt.light],
  );

  static ThemeData _build({
    required ColorScheme colors,
    required Color scaffoldBackground,
    required SystemUiOverlayStyle overlayStyle,
    required List<ThemeExtension<dynamic>> extensions,
  }) {
    final textTheme = AppTextTheme.build(colors.onSurface);

    return ThemeData(
      useMaterial3: true,
      brightness: colors.brightness,
      colorScheme: colors,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: textTheme,
      extensions: extensions,

      appBarTheme: AppBarComponentTheme.build(colors, textTheme, overlayStyle),
      cardTheme: CardComponentTheme.build(colors),
      filledButtonTheme: ButtonComponentTheme.filled(colors),
      elevatedButtonTheme: ButtonComponentTheme.elevated(colors),
      outlinedButtonTheme: ButtonComponentTheme.outlined(colors),
      textButtonTheme: ButtonComponentTheme.text(colors),
      inputDecorationTheme: InputComponentTheme.build(colors, textTheme),
      bottomSheetTheme: BottomSheetComponentTheme.build(colors),
      dialogTheme: DialogComponentTheme.build(colors, textTheme),
      chipTheme: ChipComponentTheme.build(colors, textTheme),
      dividerTheme: DividerComponentTheme.build(colors),
      snackBarTheme: SnackbarComponentTheme.build(colors, textTheme),
      listTileTheme: ListTileComponentTheme.build(colors),
      switchTheme: SwitchComponentTheme.build(colors),
      progressIndicatorTheme: ProgressIndicatorComponentTheme.build(colors),
      navigationBarTheme: NavigationBarComponentTheme.build(colors, textTheme),
      popupMenuTheme: PopupMenuComponentTheme.build(colors, textTheme),
      tooltipTheme: TooltipComponentTheme.build(colors, textTheme),
    );
  }
}
```

---

## 5. Geriye Uyumluluk (API Surface)

Dış kullanıcılar (features) şu sembolleri kullanıyor:

| Sembol                               | Strateji                                                                                                                |
| ------------------------------------ | ----------------------------------------------------------------------------------------------------------------------- |
| `AppColors.brandAmber`, vb.          | **Korunur.** `AppColors` deprecated facade olarak kalır; `BrandColors.amber`'a yönlendirir. Geçiş tamamlanınca silinir. |
| `AppSpacing.x4`, `AppSpacing.bottom` | **Aynen korunur** (sadece dosya yeri değişir).                                                                          |
| `AppRadius.cardBorderRadius`         | **Aynen korunur.**                                                                                                      |
| `AppShadow.sm/md/lg`                 | **Aynen korunur.**                                                                                                      |
| `AppTypography.button` vb.           | **Korunur** ama yeni isim `AppTextStyles`. Geçiş için typedef/alias verilir.                                            |
| `AppTheme.dark` / `AppTheme.light`   | **Aynen korunur** — yalnızca iç implementasyon değişir.                                                                 |

Tek `theme.dart` barrel hâlâ aynı yerde: `app/lib/ui/theme/theme.dart`. Mevcut import'lar (`import 'package:.../ui/theme/theme.dart'`) bozulmaz.

---

## 6. Migration Adımları (Önerilen Sıra)

PR'ı küçük tutmak için aşamalı migration:

1. **Tokens**: `app_spacing.dart` → 3 dosyaya böl (`tokens/`). Eski dosyayı re-export'a çevir, sonra sil. (Risk: minimal)
2. **Colors klasörü**: Renkleri kategoriye böl. `AppColors` re-export façade. ColorScheme'leri `colors/color_schemes.dart`'a taşı.
3. **Typography**: TextStyle'ları `app_text_styles.dart`'a, TextTheme builder'ı `app_text_theme.dart`'a böl.
4. **Components**: Her component theme için ayrı dosya + builder. Adım adım taşı, her component için:
   - Dosyayı oluştur
   - `_buildDark` ve `_buildLight`'tan ilgili bloğu sil ve `XComponentTheme.build(...)` ile değiştir
   - `flutter analyze` yeşil; spot-check ekran
5. **AppColorsExt + AppTextThemeExt**: ThemeExtension'ları ekle. İlk aşamada boş/minimal — sonra ihtiyaç oldukça doldur.
6. **Final assembly**: `app_theme.dart`'ı yukarıdaki ≤80 satırlık hâle indir.
7. **Cleanup**: deprecated façade'leri kullanan call-site'ları yeni isimlere geçir; façade'ları kaldır.

Her adım sonrası: `melos run analyze && melos run unit-test`. Görsel regresyon yok — tüm renkler/spacing aynı semantic değerlerden besleniyor.

---

## 7. Kazanımlar

| Önce                                            | Sonra                                       |
| ----------------------------------------------- | ------------------------------------------- |
| `app_theme.dart` 619 satır                      | `app_theme.dart` ≤80 satır + 15 küçük dosya |
| Component theme 2× yazılı (light + dark)        | 1× yazılı, ColorScheme'den türetilir        |
| Renkler tek flat dosyada                        | Brand/semantic/neutral/surface ayrı         |
| TextTheme varyantları widget'larda copyWith     | `AppTextThemeExt` üzerinden hazır           |
| `Color(0x33D97706)` magic                       | `AppColorsExt.brandAmberSoft` semantic      |
| Yeni component eklemek için 619 satıra dokunmak | Yeni dosya + 1 satır assembly               |

---

## 8. Açık Tasarım Soruları (Onay Bekliyor)

1. **`AppColors` deprecated façade vs. tek seferde rename?** Dış kullanım dar (yalnızca features altında ~10 widget); tek PR'da rename de yapılabilir. Hangisini tercih ediyorsun?
2. **`AppColorsExt` erişim kısayolu**: `context.appColors.success` BuildContext extension'ı tanıtmak istiyor musun, yoksa `Theme.of(context).extension<AppColorsExt>()!.success` yeterli mi?
3. **OutlinedButton light tasarımı**: light mode'da gerçekten "outlined" mı (ink300 border) yoksa şu anki gibi "tonal" (ink100 bg, no border) mu kalsın? Şimdilik mevcut davranış korunacak — onayını istiyorum.
4. **`AppTypography` → `AppTextStyles` rename**: Anlamca daha doğru ("typography" bir disiplin, "textStyles" veri). Onaylıyor musun?

---

## 9. Tahmini Efor

- Aşamalı migration (yukarıdaki 7 adım): ~3-4 saat odaklı çalışma.
- Tek PR mı, ardışık küçük PR'lar mı? Senin tercihin.
