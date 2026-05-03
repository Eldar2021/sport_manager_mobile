import 'package:core/core.dart';
import 'package:sport_manager_mobile/core/core.dart';

abstract final class AppConfigEntries {
  static final ConfigEntry<String> whatsappPhone = stringEntry(
    key: 'support_whatsapp_phone',
    defaultValue: SupportContacts.whatsappPhone,
  );

  static final ConfigEntry<String> telegramHandle = stringEntry(
    key: 'support_telegram_handle',
    defaultValue: SupportContacts.telegramHandle,
  );

  static final ConfigEntry<String> supportEmail = stringEntry(
    key: 'support_email',
    defaultValue: SupportContacts.supportEmail,
  );

  static final ConfigEntry<String> callPhone = stringEntry(
    key: 'support_call_phone',
    defaultValue: SupportContacts.callPhone,
  );

  static List<ConfigEntry<dynamic>> get all => [
    whatsappPhone,
    telegramHandle,
    supportEmail,
    callPhone,
  ];
}
