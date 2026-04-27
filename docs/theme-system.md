# Theme System

> Canonical reference for colors, typography, spacing, radii, shadows, and
> component themes in Sport Manager Mobile.
>
> **Audience:** developers and AI agents writing UI code. Read this before
> adding any new screen or widget so the result adapts correctly to light /
> dark mode and matches the design system.
>
> **Looking for pre-built widgets?** See [ui-components.md](ui-components.md)
> first — text fields, banners, submit buttons, spinners, etc. already exist
> and use the tokens documented here. This file covers the tokens; that file
> covers the widgets that consume them.

---

## Folder layout

```
app/lib/ui/theme/
├── app_theme.dart                 ← AppTheme.light / AppTheme.dark assembly
├── theme.dart                     ← public barrel
├── colors/
│   ├── app_colors.dart            ← AppColors  (raw constants, single source of truth)
│   ├── app_colors_extension.dart  ← AppColorsExt (theme-aware non-Material colors + shadows)
│   └── color_schemes.dart         ← AppColorSchemes.light / .dark
├── components/                    ← one builder per Material widget theme
│   ├── app_bar_component_theme.dart
│   ├── button_component_theme.dart
│   ├── card_component_theme.dart
│   └── …
├── extension/
│   └── context_extensions.dart    ← context.colors / textTheme / appColors / appTextStyles
├── foundations/
│   ├── app_spacing.dart           ← AppSpacing.x1 … x16, AppSpacing.bottom(context)
│   ├── app_radius.dart            ← AppRadius.button / .input / .card / .modal / .chip
│   └── app_shadow.dart            ← AppShadow.{sm,md,lg}{Light,Dark}
└── typography/
    ├── app_text_theme.dart            ← AppTextTheme.from(color) — every Material role
    └── app_text_theme_extension.dart  ← AppTextThemeExt: error / disabled / muted / onPrimary / link
```

Everything is re-exported from `package:sport_manager_mobile/ui/ui.dart` —
features import that single barrel and never reach into subfolders directly.

---

## The four `BuildContext` shortcuts

```dart
context.colors          // ColorScheme           (Material 3 tokens)
context.textTheme       // TextTheme             (Material 3 text roles)
context.appColors       // AppColorsExt          (success / warning / info / shadows / brandAmberSoft)
context.appTextStyles   // AppTextThemeExt       (error / disabled / muted / onPrimary / link variants)
context.appTheme        // ThemeData             (escape hatch, rarely needed)
```

Always prefer these over `Theme.of(context).colorScheme` / `.textTheme` —
they're the same thing with less noise.

---

## Picking the right color token

Walk the list top to bottom and stop at the first match.

1. **Is it a Material 3 role?** (primary, secondary, surface, onSurface,
   error, outline, etc.) → `context.colors.X`.

2. **Is it success / warning / info / soft brand overlay / shadow?**
   → `context.appColors.X` (`success`, `successContainer`, `warning`,
   `info`, `brandAmberSoft`, `shadowSm/Md/Lg`).

3. **Is it a tinted overlay built from another token?**
   → `someColor.withValues(alpha: 0.12)` is fine — it adapts because
   the source `someColor` is theme-aware.

4. **Is it a third-party brand color** (WhatsApp green, Telegram blue)
   that should look the same in light and dark?
   → Hardcode it as a `const Color` _near the widget_ and add a comment
   explaining why it doesn't go through the theme.

5. **Anything else** → reach for `AppColors.X` only as a last resort, and
   only if the constant is truly mode-independent (e.g. `AppColors.transparent`,
   `AppColors.black`). If you're tempted to use `AppColors.brandAmber` in a
   widget, you almost always want `context.colors.primary` instead.

❌ **Never inline a hex literal** (`Color(0xFFD97706)`) in a widget.

❌ **Never use `Colors.X`** from `flutter/material.dart` directly — pick a
theme token instead.

---

## Picking the right text style

```dart
context.textTheme.headlineLarge          // 28 / 34 · w700  (screen title)
context.textTheme.titleLarge             // 22 / 28 · w600  (AppBar title)
context.textTheme.bodyMedium             // 16 / 24 · w400  (default body)
context.textTheme.bodySmall              // 13 / 18 · w500  (caption / helper)
context.textTheme.labelLarge             // 17 / 22 · w600  (button label)
context.textTheme.displayLarge           // 56 / 64 · w700  (timer, big numbers)
context.textTheme.displaySmall           // 32 / 40 · w700  (large amount)
```

Hover any field on `AppTextTheme` to see size / weight in your IDE.

For variants (error / disabled / muted / onPrimary), reach for
`context.appTextStyles`:

```dart
context.appTextStyles.error.bodySmall    // bodySmall in colorScheme.error
context.appTextStyles.disabled.bodyLarge // bodyLarge in onSurface @ 38%
context.appTextStyles.muted.bodyMedium   // bodyMedium in onSurfaceVariant
context.appTextStyles.onPrimary.titleLarge
context.appTextStyles.link               // single underlined primary style
```

❌ **Don't write `style.copyWith(color: colors.error)` zigzags** —
use `context.appTextStyles.error.X` instead.

---

## Spacing, radius, shadow, opacity

| Need        | Use                                                |
| ----------- | -------------------------------------------------- |
| Padding     | `AppSpacing.x1 … x16` (4 / 8 / 12 / … / 64)        |
| Bottom safe | `AppSpacing.bottom(context)`                       |
| Radius      | `AppRadius.buttonBorderRadius` etc.                |
| Shadow      | `context.appColors.shadowMd` (theme-aware)         |
| Opacity     | `AppOpacity.tint` (0.12) for tinted backgrounds; `disabledForeground` (0.38) / `disabledBackground` (0.12) for disabled states |

Direct shadow constants `AppShadow.smLight` / `smDark` exist for special
cases (e.g. you need a known set regardless of theme), but the default is
the theme-aware getter on `AppColorsExt`.

❌ **No magic numbers.** `EdgeInsets.all(13)` is wrong; use a token.

---

## Worked examples

### Default body text (adapts automatically)

```dart
Text('Hello', style: context.textTheme.bodyMedium)
```

### Error message under a form field

```dart
Text(errorText, style: context.appTextStyles.error.bodySmall)
```

### Tinted success badge

```dart
DecoratedBox(
  decoration: BoxDecoration(
    color: context.appColors.success.withValues(alpha: AppOpacity.tint),
    borderRadius: AppRadius.chipBorderRadius,
  ),
  child: Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.x3,
      vertical: AppSpacing.x1,
    ),
    child: Text(
      label,
      style: context.textTheme.bodySmall?.copyWith(
        color: context.appColors.success,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
)
```

### Card with elevation in both modes

```dart
DecoratedBox(
  decoration: BoxDecoration(
    color: context.colors.surface,
    borderRadius: AppRadius.cardBorderRadius,
    boxShadow: context.appColors.shadowMd,
  ),
  child: …,
)
```

### Filled button (no styling needed — theme handles it)

```dart
FilledButton(onPressed: …, child: Text('Save'))
```

The button gets its `backgroundColor`, `foregroundColor`, padding, radius
and text style from `ButtonComponentTheme.filled(...)`. **Don't override
them** unless you have a strong reason — instead extend the theme.

---

## Extending the theme

### Add a new color

1. Add the raw constant to [colors/app_colors.dart](../app/lib/ui/theme/colors/app_colors.dart) with a doc comment showing where it lands (`→ colorScheme.X` or `→ appColors.X`).
2. **If it's a Material 3 role** (primary, secondary, surface, …): wire it into [colors/color_schemes.dart](../app/lib/ui/theme/colors/color_schemes.dart) for both `light` and `dark`.
3. **If it falls outside Material 3** (success, warning, info, soft overlay): add a field to `AppColorsExt` in [colors/app_colors_extension.dart](../app/lib/ui/theme/colors/app_colors_extension.dart) and supply both `light` and `dark` values. The doc comment must list `- light:` and `- dark:` hex resolutions.

### Add a new text style

If it maps to a Material role, modify the value in
[typography/app_text_theme.dart](../app/lib/ui/theme/typography/app_text_theme.dart) `from(color)` factory.

If it's a variant on top of an existing role (e.g. "warning text"), add a
field to `AppTextThemeExt` in
[typography/app_text_theme_extension.dart](../app/lib/ui/theme/typography/app_text_theme_extension.dart).

### Theme a new Material widget

1. Create `components/<name>_component_theme.dart` exporting an
   `abstract final class XComponentTheme` with a `static build(...)`
   method that takes `ColorScheme` (and `TextTheme` / `AppColorsExt`
   when needed) and returns the theme data.
2. Wire it in [app_theme.dart](../app/lib/ui/theme/app_theme.dart) inside `_build({...})`.
3. Export from `theme.dart` barrel.

The component theme **never branches on `Brightness`** unless its structure
genuinely differs between modes — colors are always sourced from the
`ColorScheme` argument so the same builder works for both themes.

---

## Anti-patterns to reject in code review

| Anti-pattern                                         | Replacement                                      |
| ---------------------------------------------------- | ------------------------------------------------ |
| `Color(0xFFD97706)` inline                           | `context.colors.primary`                         |
| `Colors.red`, `Colors.grey[300]`                     | `context.colors.error`, `context.colors.outline` |
| `AppColors.brandAmber` in a widget                   | `context.colors.primary`                         |
| `AppColors.dangerRed`                                | `context.colors.error`                           |
| `AppColors.successGreen`                             | `context.appColors.success`                      |
| `Theme.of(context).colorScheme`                      | `context.colors`                                 |
| `Theme.of(context).textTheme`                        | `context.textTheme`                              |
| `style.copyWith(color: colors.error)` for error text | `context.appTextStyles.error.X`                  |
| `EdgeInsets.all(16)` magic number                    | `EdgeInsets.all(AppSpacing.x4)`                  |
| `BorderRadius.circular(12)` magic number             | `AppRadius.buttonBorderRadius`                   |
| Hardcoded `BoxShadow(color: Colors.black12, …)`      | `context.appColors.shadowMd`                     |
| `_buildXyz()` private widget method                  | Extract a `StatelessWidget` class                |

---

## Quick lookup

When the designer hands you a hex value, search [colors/app_colors.dart](../app/lib/ui/theme/colors/app_colors.dart). Every constant carries a doc comment that tells you the _theme-level_ token to use (not the constant itself). Use the token, not the raw color.
