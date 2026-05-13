# deploy/

App Store ve Play Store yayın hazırlık klasörü. Tüm metadata, görseller, açıklamalar ve adım adım yayın planı burada toplanır.

## Yapı

```
deploy/
├── README.md                ← bu dosya
└── app_store/               ← Apple App Store
    ├── PLAN.md              ← ANA YAYIN PLANI (önce bunu oku)
    ├── checklist.md         ← submission öncesi kontrol listesi
    ├── metadata/            ← bundle, sürüm, hesap, App Privacy, URL'ler
    ├── descriptions/        ← title / subtitle / short / long / keywords (en, ru, ky)
    ├── icons/               ← 1024×1024 App Store icon + cihaz ikonları
    └── screenshots/         ← 6.7" / 6.5" / 5.5" iPhone + 12.9" iPad ekran görüntüleri
```

Play Store için ayrı klasör (`deploy/play_store/`) App Store yayını biter bitmez eklenecek.

## Sıra

1. [app_store/PLAN.md](app_store/PLAN.md) — yayın planını oku
2. [app_store/metadata/README.md](app_store/metadata/README.md) — hesap & teknik bilgiler
3. [app_store/descriptions/README.md](app_store/descriptions/README.md) — açıklama metinleri
4. [app_store/icons/README.md](app_store/icons/README.md) — ikon gereksinimleri
5. [app_store/screenshots/README.md](app_store/screenshots/README.md) — ekran görüntüsü gereksinimleri
6. [app_store/checklist.md](app_store/checklist.md) — submission öncesi son kontrol
