abstract final class Env {
  static const baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: '---BASE_URL_NOT_PROVIDED---',
  );

  static const bool isMock = bool.fromEnvironment(
    'IS_MOCK',
    defaultValue: true,
  );
}
