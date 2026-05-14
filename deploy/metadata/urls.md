# URLs

App Store Connect → App Information & Version Information altına girilecek URL'ler.
Hepsi **HTTPS** ve **herkese açık** olmalı (login arkasında değil).

## Zorunlu

### Privacy Policy URL

`https://dula.app/privacy` _(placeholder — yayınla)_

İçeriği [privacy.md](privacy.md) ile birebir uyumlu olmalı. Eksik veri tipi → submission reddi.

### Support URL

`https://dula.app/support` _(placeholder — yayınla)_

Sayfada şu olmalı:

- Destek e-posta adresi
- SSS / yardım merkezi linki (opsiyonel)
- Yanıt süresi beklentisi

## Opsiyonel

### Marketing URL

`https://dula.app` _(placeholder)_

Olmazsa sorun değil, varsa store sayfasında "Developer Website" linki olarak görünür.

### EULA

Standart Apple EULA kullanılacaksa boş bırakılır. Custom EULA varsa metin yüklenir.

## Kontrol

- [ ] Privacy ve Support URL'leri canlı (200 OK, login gerektirmez)
- [ ] Privacy Policy 3 dilde mevcut (en/ru/ky) — App Store dil sayısına paralel
- [ ] Support sayfasında en az 1 iletişim kanalı var
- [ ] URL'ler `.html` ile değil, "kalıcı" path ile (yayın sonrası değişmesin)
