# App Privacy

App Store Connect → App Privacy bölümünün taslak cevapları. **Submit öncesi backend ile final ekibi onayı gerekir.**

## Privacy Policy
URL: `https://dula.app/privacy` *(yayınlanmış olmalı — placeholder)*

## Veri tipleri

### Contact Info
- **Name** — TOPLANIYOR
  - Linked to user: Yes
  - Used for tracking: No
  - Purposes: App Functionality, Account Management
- **Email Address** — TOPLANIYOR (auth)
  - Linked to user: Yes · Tracking: No
  - Purposes: App Functionality, Account Management
- **Phone Number** — TOPLANIYORSA (auth flow telefon kullanıyorsa doğrula)
  - Linked to user: Yes · Tracking: No
  - Purposes: App Functionality

### Identifiers
- **User ID** — TOPLANIYOR (backend user id, auth token)
  - Linked to user: Yes · Tracking: No
  - Purposes: App Functionality

### Usage Data (Firebase Analytics aktifse)
- **Product Interaction**
  - Linked to user: No · Tracking: No
  - Purposes: Analytics

### Diagnostics (Crashlytics aktifse)
- **Crash Data, Performance Data**
  - Linked to user: No · Tracking: No
  - Purposes: App Functionality, Analytics

### Financial Info (subscription IAP varsa)
Apple StoreKit ile satın alma — Apple kendisi toplar, sen yine de "Purchase History" alanını işaretleyebilirsin.
- **Purchase History**
  - Linked to user: Yes · Tracking: No
  - Purposes: App Functionality

## Üçüncü taraf SDK'lar
- **Firebase Remote Config** — kullanıcı verisi göndermez (config indirir)
- **Firebase Analytics** — Usage Data (eğer aktifleştirilirse)
- **Firebase Crashlytics** — Diagnostics (eğer aktifleştirilirse)
- **Google Fonts** — runtime'da font indirir (network, kullanıcı verisi göndermez)
- **Dio + Talker** — network log (sadece dev/release-debug, prod release'de kapatılmalı)

## Tracking
- **Do you or your third-party partners use data for tracking?** → **No**
- AppTrackingTransparency (`NSUserTrackingUsageDescription`) → **gerek yok** (IDFA toplanmıyor)

## Doğrulama kontrolleri
- [ ] Backend ekibi hangi PII'yi (kişisel veri) gerçekten depoluyor onayladı
- [ ] Privacy Policy URL canlı ve cevaplara uyumlu
- [ ] Crashlytics/Analytics aktivasyonu kararı alındı (aktifse cevaplara eklendi)
