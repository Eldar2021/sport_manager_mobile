# Screenshots

App Store screenshot gereksinimleri ve çekim rehberi.

## Klasör yapısı

```
screenshots/
├── README.md           ← bu dosya
├── en/                 ← English (Primary)
│   ├── 6.9_iphone/
│   ├── 6.7_iphone/
│   ├── 5.5_iphone/
│   └── 12.9_ipad/
├── ru/                 ← Russian
│   └── … (aynı altyapı)
└── ky/                 ← Kyrgyz
    └── …
```

> Her dil için ekran görüntüsü ayrı. Apple, dil seçilince mağaza önizlemesinde o dile özel olanları gösterir.

## Cihaz boyutları (en az birini her dil için ekle)

| Klasör        | Cihaz                          | Çözünürlük (px) | Min | Max |
| ------------- | ------------------------------ | --------------- | --- | --- |
| `6.9_iphone/` | iPhone 16 Pro Max              | **1320×2868**   | 3   | 10  |
| `6.7_iphone/` | iPhone 15 Pro Max / 14 Pro Max | **1290×2796**   | 3   | 10  |
| `5.5_iphone/` | iPhone 8 Plus                  | **1242×2208**   | 3   | 10  |
| `12.9_ipad/`  | iPad Pro 12.9" (3rd-6th gen)   | **2048×2732**   | 3   | 10  |

**Pratik kural:** 6.9" ve 6.7"'yi mutlaka ekle (yeni cihazlar) + 12.9" iPad (uygulama iPad'i destekliyor). 5.5"'yi atlamak App Store tarafında kabul edilir, **fakat eski cihazlar için sıralama düşer**. İlk sürüm için **6.9 + 6.7 + 12.9 iPad** zorunlu sayalım, 5.5'i v1.1'e bırak.

## İçerik planı (5 ekran)

| #   | Ekran                         | İngilizce başlık                       | Rusça                                         | Kırgızca                                          |
| --- | ----------------------------- | -------------------------------------- | --------------------------------------------- | ------------------------------------------------- |
| 1   | Welcome / Login               | "Run your venue from one place"        | "Управляйте заведением из одного места"       | "Жайыңызды бир жерден башкарыңыз"                 |
| 2   | Venues list                   | "Switch between halls instantly"       | "Переключайтесь между залами мгновенно"       | "Залдар арасында тез которулуңуз"                 |
| 3   | Tables + live session         | "See free and busy tables at a glance" | "Свободные и занятые столы одним взглядом"    | "Бош жана иштеп жаткан столдорду бир караштан"    |
| 4   | Reports / KPI                 | "Know your numbers in real time"       | "Все цифры в реальном времени"                | "Сандарыңызды реалдуу убакытта көрүңүз"           |
| 5   | Manager invite / Subscription | "Invite managers, control access"      | "Приглашайте менеджеров, управляйте доступом" | "Менеджерлерди чакырыңыз, мүмкүндүктү башкарыңыз" |

> Apple kuralı: ekran görüntüsü **gerçek uygulama ekranını** göstermeli. "Mockup-only" / pazarlama görseli reddedilebilir. Üst tarafa metin overlay'i (yukarıdaki başlıklar) eklemek **serbest**.

## Çekim yöntemi

### Seçenek A — Gerçek cihaz (önerilir)

1. iOS Simulator (Xcode → Window → Devices) veya gerçek cihazda mock veri ile uygulamayı aç
2. Simulator → File → Save Screen (`Cmd+S`) → otomatik doğru çözünürlük PNG kaydeder
3. Status bar: gerçek pil/saat değerleri kullanma — `xcrun simctl status_bar` ile düzenle:
   ```bash
   xcrun simctl status_bar "iPhone 16 Pro Max" override \
     --time "9:41" --batteryLevel 100 --batteryState charged \
     --cellularBars 4 --cellularMode active --wifiBars 3
   ```
4. Status bar override sadece simulator'de çalışır — gerçek cihazda fotoğraf düzenleyiciyle düzeltilir

### Seçenek B — Fastlane snapshot (gelecekte tekrarlanabilir)

```bash
gem install fastlane
cd app/ios
fastlane snapshot init
```

`Snapfile`'a cihaz listesi + dil listesi yaz, `fastlane snapshot` ile otomatik üretim — v1.1+ için planlanabilir.

## Tasarım kuralları

- [ ] Status bar düzeltildi (9:41, %100 pil, full sinyal)
- [ ] Kişisel veri yok (test kullanıcısı + örnek venue isimleri)
- [ ] Telefon numarası, e-posta, kart bilgisi gerçek değil
- [ ] Dil tutarlı (RU klasöründeki ekran tamamen RU)
- [ ] Cihaz frame'i **yok** (Apple kendisi gösterir)
- [ ] Transparan alan yok
- [ ] Çözünürlük tam doğru (yukarıdaki tabloyu kontrol et)

## Doğrulama

Bir ekran görüntüsü hazır olduğunda:

```bash
sips -g pixelHeight -g pixelWidth \
  deploy/app_store/screenshots/en/6.9_iphone/01_welcome.png
# pixelHeight: 2868, pixelWidth: 1320 → ok
```

App Store Connect upload'ı yanlış boyutta dosyayı reddeder, ancak hatadan önce 30+ dosyayı tek tek yüklediğine pişman olursun — önceden `sips` ile her dosyayı doğrula.
