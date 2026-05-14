# App Review Notes

App Store Connect → Version → "App Review Information" altına yapıştırılacak metin.

## Sign-In Information

- **Required:** Yes

### Owner test hesabı

- Username: `<PROD owner username>`
- Password: `<PROD password>`

### Manager test hesabı

- Username: `<PROD manager username>`
- Password: `<PROD password>`

> **NOT:** Dev mock hesapları (`test`/`Test1234`, `manager`/`Test1234`, invite `INVITE-001`)
> sadece `Env.isMock = true` derlemelerinde çalışır — App Store build'inde devre dışıdır.
> Apple inceleyicisi için backend ekibinin prod'da kalıcı bir test hesabı oluşturması zorunludur.

## Notes (örnek metin — İngilizce)

```
Dula is a venue/facility management app for sports halls (billiard, etc.).

How to test:

1. Open the app, tap "Sign In" on the Welcome screen.
2. Use the credentials above (Owner account).
3. The Home screen will load with venues, tables, and active sessions.
4. Tap a venue → see tables → start/stop a session.
5. Open the Reports tab to view revenue and manager performance.
6. Open the Profile tab to test logout and account deletion.

To test the manager role:
- Sign out, sign in with the Manager account above.
- Manager has a reduced view (no admin actions).

To test registration:
- Tap "Sign Up" on the Welcome screen.
- Use invite code: <PROD invite code>

Subscriptions:
- The "Subscription" section in Profile shows the active plan.
- (If IAP is enabled: tap "Upgrade" to purchase through StoreKit.)

Backend base URL: <PROD BASE_URL>
Status page: <PROD status page if any>

Contact: <support email>
```

## Contact Information

- First name: `<contact-first>`
- Last name: `<contact-last>`
- Phone: `<+xx ...>`
- Email: `<support@dula.app>`

## Attachments

- (Opsiyonel) 30 saniyelik demo video — özellikle login + venue + session akışı
