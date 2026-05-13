# Icons

App Store ve cihaz launcher ikonları.

## App Store Marketing Icon (zorunlu)

`app_store_icon_1024.png` — bu klasöre **dosya olarak eklenecek**.

| Özellik        | Değer                        |
| -------------- | ---------------------------- |
| Boyut          | **1024 × 1024 piksel**       |
| Format         | PNG (24-bit veya 32-bit)     |
| Alpha kanalı   | **YOK** (Apple reddeder)     |
| Saydam alan    | YOK                          |
| Yuvarlatma     | YOK (Apple kendisi yuvarlar) |
| Renk profili   | sRGB veya P3                 |
| Maksimum dosya | ~2 MB                        |

### Üretme adımları

1. [app/assets/images/app_icon.png](../../../app/assets/images/app_icon.png) kaynağından başla
2. 1024×1024'e çıkar (yukarı ölçeklenmiş bulanık değil, tasarımdan vektör/yüksek çözünürlük export)
3. Alpha kanalını düzleştir (örn. Sketch/Figma → Export → PNG, "Include Alpha" kapalı)
4. `pngcheck app_store_icon_1024.png` ile alpha yok onayı — `IHDR` color type **2** (RGB) olmalı, **6** (RGBA) **olmamalı**
5. Dosyayı bu klasöre koy

### Doğrulama

```bash
# Boyut
sips -g pixelHeight -g pixelWidth deploy/app_store/icons/app_store_icon_1024.png
# Alpha kontrol
file deploy/app_store/icons/app_store_icon_1024.png
# (RGB → ok, RGBA → düzleştir)
```

## Cihaz launcher ikonları

`flutter_launcher_icons` zaten üretiyor — kaynak:
[app/flutter_launcher_icons.yaml](../../../app/flutter_launcher_icons.yaml)

Üretilen ikonlar Xcode asset catalog'unda: `app/ios/Runner/Assets.xcassets/AppIcon.appiconset/`.

Yeniden üretmek için:

```bash
cd app
flutter pub run flutter_launcher_icons
```

Bu launcher ikonu **store icon ile aynı kaynaktan** üretilmeli — Apple her ikisinin tutarlı olmasını bekler. `app_icon.png` güncellenirse:

1. Aynı kaynaktan 1024'lük marketing icon export et
2. `flutter pub run flutter_launcher_icons` ile cihaz ikonlarını yenile
3. Yeni `app_store_icon_1024.png` dosyasını bu klasöre koy

## Dark mode / Tinted icon (iOS 18+)

iOS 18 ile **dark** ve **tinted** ikon varyantları opsiyonel — ilk sürümde atlanabilir. v1.1'de eklenirse Xcode asset catalog'unda "Appearances → Any, Dark, Tinted" katmanları açılır.
