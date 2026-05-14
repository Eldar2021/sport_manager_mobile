# App Store Submission Checklist — Dula

Submit'e basmadan önce her satırı doğrula.

## Proje

- [ ] `app/pubspec.yaml` → `version` doğru artırıldı (build number unique)
- [ ] `app/ios/Runner/Info.plist` → `CFBundleDisplayName` = "Dula" (App Store Name ile aynı)
- [ ] `ITSAppUsesNonExemptEncryption` Info.plist'e eklendi (false)
- [ ] `prod.env` doğru `BASE_URL` içeriyor ve `.gitignore`'da
- [ ] `Env.isMock` prod build'inde false (manuel doğrulama)
- [ ] `melos run analyze-check` temiz
- [ ] `melos run unit-test` yeşil
- [ ] `make build-runner` çalıştırıldı, `.g.dart` güncel ve commit'li
- [ ] Talker / Dio logger release modunda kapalı

## App Store Connect record

- [ ] App record oluşturuldu (`Dula`, bundle `com.sport.manager.mobile`)
- [ ] Primary Language: English (U.S.)
- [ ] Category: Business / Productivity
- [ ] Age Rating: 4+
- [ ] Paid Apps Agreement imzalı (abonelik için)
- [ ] Vergi & banka bilgileri tamam

## Sertifika & profil

- [ ] Distribution certificate aktif
- [ ] App Store provisioning profile aktif (Xcode otomatik yönetiyor)
- [ ] Team `K9JN47N96M` doğrulandı

## Görsel materyal

- [ ] 1024×1024 App Store icon (PNG, alpha yok, sRGB) — `icons/app_store_icon_1024.png`
- [ ] 6.9" iPhone screenshots × en az 3 (en, ru, ky)
- [ ] 6.7" iPhone screenshots × en az 3 (en, ru, ky)
- [ ] 5.5" iPhone screenshots × en az 3 (en, ru, ky)
- [ ] 12.9" iPad screenshots × en az 3 (en, ru, ky) — iPad destekleniyor
- [ ] Screenshot'larda durum çubuğunda %100 batarya, full sinyal, 9:41 saati (gerçek değil ise mock olmalı)

## Metin materyali (her dil için)

- [ ] App Name (max 30)
- [ ] Subtitle (max 30)
- [ ] Promotional Text (max 170)
- [ ] Description (max 4000)
- [ ] Keywords (max 100)
- [ ] What's New (max 4000) — ilk sürüm: "Initial release"

## URL'ler

- [ ] Privacy Policy URL (zorunlu, HTTPS, herkese açık)
- [ ] Support URL (zorunlu, HTTPS, e-posta dahil)
- [ ] Marketing URL (opsiyonel)

## App Privacy

- [ ] Toplanan tüm veri tipleri işaretli
- [ ] Linked/Not Linked to User cevaplanmış
- [ ] Used for Tracking cevaplanmış (büyük olasılıkla "No")
- [ ] Üçüncü taraf SDK'lar (Firebase) için veri tipi cevaplanmış

## Demo hesap & notes

- [ ] App Review Sign-In info: username + password (owner ve manager rolleri için)
- [ ] App Review Notes alanında özet: "Owner: x / Test1234. Manager: y / Test1234. Invite code for register: INVITE-001"
- [ ] Demo hesap stabil, içinde örnek venue/table/session verisi var

## Zorunlu özellikler

- [ ] **Hesap silme akışı uygulama içinde mevcut** (Apple Guideline 5.1.1(v))
- [ ] Şifre sıfırlama akışı çalışıyor
- [ ] Logout akışı çalışıyor
- [ ] Bütün hata mesajları lokalize (3 dil)

## Build

- [ ] Archive `Any iOS Device (arm64)` ile alındı
- [ ] Validation hatasız geçti
- [ ] TestFlight'a yüklendi
- [ ] İç testte en az 1 tur çökme/regression doğrulaması yapıldı
- [ ] iPhone (en küçük + en büyük) + iPad'de el ile sınandı

## Submit

- [ ] Release option: **Manual release** (ilk sürüm) veya **Phased release** seçili
- [ ] "Submit for Review" basıldı
- [ ] Doğru build seçildi

## Yayın sonrası

- [ ] Onay sonrası "Release this version" butonu hazır
- [ ] Crashlytics canlı izleniyor
- [ ] App Store Connect Analytics izleniyor
