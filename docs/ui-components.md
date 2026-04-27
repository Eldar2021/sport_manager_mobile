# UI Components

> Pre-built widgets in [`app/lib/ui/components/`](../app/lib/ui/components/),
> exported via [`package:sport_manager_mobile/ui/ui.dart`](../app/lib/ui/ui.dart).
>
> **Read this before writing a new widget.** If something close to what you need
> already exists, extend or compose it instead of introducing a parallel
> component. Components below are themed, accessibility-friendly, and adapt
> to light/dark via the design tokens — copying their look ad-hoc usually
> produces drift.

For tokens (colors, spacing, radii, typography, opacity) consumed by these
components, see [theme-system.md](theme-system.md).

---

## Index

| Component                       | Use it for                                                |
| ------------------------------- | --------------------------------------------------------- |
| [AppBanner](#appbanner)         | Tinted notice with icon (hint or filled info)             |
| [AppSubmitButton](#appsubmitbutton) | Form submit / primary CTA with loading state         |
| [AppTextField](#apptextfield)   | Text input with label above, validator, helper text       |
| [AppPasswordField](#apppasswordfield) | Password input with show/hide toggle                |
| [AppCheckboxField](#appcheckboxfield) | Checkbox tied to `Form` validation                  |
| [AppActivityIndicator](#appactivityindicator) | Inline loading spinner                      |
| [AppLogo](#applogo)             | Brand mark (gradient cue + ball)                          |
| [DashedRoundedBorderPainter](#dashedroundedborderpainter) | Dashed RRect border painter   |

---

## AppBanner

[banner/app_banner.dart](../app/lib/ui/components/banner/app_banner.dart)

Tinted strip with a leading icon and a body of text. Two visual weights via
`AppBannerVariant`:

- `hint` *(default)* — soft `primary` overlay (`AppOpacity.tint`); inline help
  under form fields.
- `info` — filled `primaryContainer`; prominent informational notices.

```dart
// Soft hint under a form field
AppBanner(context.l10n.authInviteCodeHint)

// Filled info notice with a custom icon
AppBanner(
  context.l10n.authForgotPasswordBanner,
  variant: AppBannerVariant.info,
  icon: Icons.lock_outline_rounded,
)
```

**Don't** create another tinted-row widget. Need a new variant
(success/warning)? Extend the enum and the `(bg, fg)` switch in
`AppBanner.build`.

---

## AppSubmitButton

[button/app_submit_button.dart](../app/lib/ui/components/button/app_submit_button.dart)

Primary `FilledButton` with a built-in loading spinner and an optional leading
icon. Height fixed to `AppSpacing.x14` (56px) so primary CTAs stay consistent
across forms.

```dart
AppSubmitButton(
  label: context.l10n.authSignIn,
  isLoading: state.isLoading,
  onPressed: _login,
)

// With a leading icon (e.g. social sign-in)
AppSubmitButton(
  label: 'Continue with Google',
  onPressed: _signInWithGoogle,
  leadingIcon: Assets.icons.google.svg(width: 20),
)
```

While `isLoading` is true the button auto-disables and shows a 22px
`CircularProgressIndicator` in `onPrimary` color.

**Don't** wrap raw `FilledButton(..., child: isLoading ? Spinner : Text(...))`
in feature code — call this. **Don't** override `minimumSize` or button colors
at the call site; that's what the theme is for.

---

## AppTextField

[form/app_text_field.dart](../app/lib/ui/components/form/app_text_field.dart)

`TextFormField` wrapped with a static label rendered as a `Text` above the
input (intentional — the design system wants the label always visible, not
floating). All borders, focus animations, and error rendering come from
`InputDecorationTheme`; you don't need to wire any of that.

```dart
AppTextField(
  label: context.l10n.authEmailLabel,
  controller: _emailCtr,
  keyboardType: TextInputType.emailAddress,
  textInputAction: TextInputAction.next,
  validator: (v) => InputValidators.emailValidator(v, context),
)

// With phone formatter + helper text
AppTextField(
  label: context.l10n.authPhoneLabel,
  controller: _phoneCtr,
  hintText: '+996 ___ __ __ __',
  inputFormatters: [MaskTextInputFormatter(...)],
  helperText: context.l10n.phoneHint,
  validator: (v) => InputValidators.phoneValidator(v, context, expectedLength: 12),
)
```

Available parameters: `controller`, `focusNode`, `validator`, `onChanged`,
`onSubmitted`, `keyboardType`, `textInputAction`, `inputFormatters`,
`prefixIcon`, `suffixIcon`, `hintText`, `helperText`, `enabled`, `maxLength`,
`maxLines`, `autofocus`, `obscureText`.

**Don't** build `TextField` + custom `Container` borders ad-hoc. **Don't**
swap the static label for `InputDecoration.labelText` — that's a design
discussion, not a one-off override.

---

## AppPasswordField

[form/app_password_field.dart](../app/lib/ui/components/form/app_password_field.dart)

`AppTextField` preset for passwords with a built-in show/hide toggle as
`suffixIcon`. State is owned internally; you only pass the controller and
validator.

```dart
AppPasswordField(
  label: context.l10n.authPassword,
  controller: _passwordCtr,
  textInputAction: TextInputAction.next,
  validator: (v) => InputValidators.passwordValidator(v, context),
)

// Start with the password visible (e.g. registration flows)
AppPasswordField(
  label: 'New password',
  controller: _newPasswordCtr,
  initiallyObscured: false,
  validator: ...,
)
```

**Don't** add a third "field that obscures text" widget. If you need extra
behavior (strength meter, etc.), wrap or extend this.

---

## AppCheckboxField

[form/app_checkbox_field.dart](../app/lib/ui/components/form/app_checkbox_field.dart)

`FormField<bool>` + `CheckboxListTile`. Plays well with `Form.validate()` —
return a non-null string from the validator to fail the form (e.g. "you must
accept the terms"). Error text appears as a subtitle.

```dart
AppCheckboxField(
  label: context.l10n.authAgreeTerms,
  validator: (v) => (v ?? false) ? null : context.l10n.authAgreeTermsError,
)
```

`initialValue` defaults to `false`. The checkbox is rendered slightly larger
than the Material default (`_checkboxScaleFactor = 1.3`) for tap-target
comfort.

**Don't** roll your own `Checkbox` + manual error `Text` — you'll lose form
integration.

---

## AppActivityIndicator

[indicators/app_activity_indicator.dart](../app/lib/ui/components/indicators/app_activity_indicator.dart)

Wraps `CupertinoActivityIndicator` — used on **every platform** intentionally
for visual consistency. Don't fall back to the Material spinner on Android.

```dart
const AppActivityIndicator()

// With a fixed size and padding
AppActivityIndicator(
  width: 24,
  height: 24,
  padding: EdgeInsets.all(AppSpacing.x4),
)
```

For the inline-button spinner case, use `AppSubmitButton(isLoading: true)` —
don't manually compose a button + this indicator.

---

## AppLogo

[logo/app_logo.dart](../app/lib/ui/components/logo/app_logo.dart)

The brand mark — a billiard cue + cue ball on a gradient rounded square,
with a soft drop shadow tinted by `AppOpacity.brandGlow`. Defaults to 88px;
pass `size:` for splash / smaller header variants.

```dart
const AppLogo()
const AppLogo(size: 48)
```

The mark itself is drawn by an internal `_CuePainter` in a 24×24 reference
grid that scales with `size`. **Don't** introduce a separate logo widget for
sizing variants — pass `size:`.

---

## DashedRoundedBorderPainter

[painter/dashed_rounded_border_painter.dart](../app/lib/ui/components/painter/dashed_rounded_border_painter.dart)

`CustomPainter` that paints a dashed `RRect` border at `AppRadius.card`. Wrap
any child in a `CustomPaint` to give it a dashed outline (used for "tap to
contact support" cards and similar low-emphasis containers).

```dart
CustomPaint(
  painter: DashedRoundedBorderPainter(context.colors.outline),
  child: ListTile(...),
)
```

**Don't** ship multiple dashed-border painters. If you need different dash /
gap lengths, parameterize this one rather than forking.

---

## Adding a new component

1. **Search this index first.** If a close cousin exists, extend it (parameter,
   variant enum) instead of creating a sibling.
2. Place the file under `app/lib/ui/components/<group>/`. Use an existing
   group (`form/`, `banner/`, `button/`, `indicators/`, `painter/`, `logo/`)
   if it fits; only create a new group when you'll have at least two
   widgets in it.
3. Pull every visual value from the design tokens — colors via
   `context.colors` / `context.appColors`, sizes via `AppSpacing`, radius
   via `AppRadius`, opacity via `AppOpacity`. No magic numbers, no inline
   hex. See [theme-system.md](theme-system.md) for the picking rules.
4. Export from [`components.dart`](../app/lib/ui/components/components.dart).
5. Add a row to the index above and a short section below — same shape as
   the existing entries (when to use, code snippet, "don't" notes).
6. Prefer composition: most new "components" should be a thin wrapper over
   an existing one (`AppPasswordField` → `AppTextField`) rather than a
   bottom-up build.

If a widget is **feature-specific** (uses feature l10n keys, hard-codes
business data, or is only consumed from one screen), it belongs in
`features/<name>/widgets/`, not here. `ContactSupportSheet` lives under
`features/auth/forgot_password/widgets/` for exactly this reason.
