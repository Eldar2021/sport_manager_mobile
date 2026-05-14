# App Info

| Alan                | Değer                                                                        |
| ------------------- | ---------------------------------------------------------------------------- |
| App Name            | `Dula`                                                                       |
| Bundle ID           | `com.sport.manager.mobile`                                                   |
| SKU                 | `dula-ios-001`                                                               |
| Apple Team ID       | `K9JN47N96M`                                                                 |
| Primary Language    | English (U.S.)                                                               |
| Supported Languages | English, Russian, Kyrgyz                                                     |
| Version (Marketing) | `1.0.0`                                                                      |
| Build               | `1` (her yüklemede artır)                                                    |
| Primary Category    | Business                                                                     |
| Secondary Category  | Productivity                                                                 |
| Age Rating          | 4+                                                                           |
| Device Family       | iPhone, iPad                                                                 |
| Orientations        | Portrait, Landscape Left, Landscape Right (iPad ayrıca Portrait Upside Down) |
| Minimum iOS         | 13.0 (Flutter 3.41 varsayılanı — Xcode projede doğrula)                      |
| Pricing             | Free (subscription IAP ile)                                                  |

## Capabilities (Developer Portal)

- [ ] In-App Purchase — gerekli (abonelik)
- [ ] Push Notifications — opsiyonel (ileride)
- [ ] Sign in with Apple — gerekirse
- [ ] Background Modes — yok
- [ ] Associated Domains — yok (deeplink gerekirse eklenecek)

## Encryption (ITSAppUsesNonExemptEncryption)

`false` — uygulama HTTPS dışında özel kripto kullanmıyor.
Info.plist'e eklenecek (her sürümde sorulmasını engeller):

```xml
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```
