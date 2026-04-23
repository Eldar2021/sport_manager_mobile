extension StringX on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  static final _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  /// Checks if the string ends with '.svg'
  bool get isSvg => endsWith('.svg');

  /// Checks if the string is a URL
  bool get isUrl => startsWith('http');

  /// Checks if the string is a valid email format
  bool get isEmail => _emailRegExp.hasMatch(this);

  /// Obfuscates an email address by replacing the middle part with asterisks
  String get obscureEmail {
    final parts = split('@');
    var email = '';
    email = parts.first.substring(0, 1) + ('*' * (parts.first.substring(1).length - 1));
    email = '$email${parts.first.substring(parts.first.length - 1)}@${parts.last}';
    return email;
  }
}

extension StringNull on String? {
  /// Checks if the string is null or empty
  bool get isNullOrEmpty {
    return this == null || this!.isEmpty;
  }

  /// Checks if the string is not null and not empty
  bool get isNotNullOrEmpty {
    return this != null && this?.isEmpty == false;
  }

  /// Checks if the string contains the specified substring (case-insensitive)
  bool include(String str) {
    return this?.toLowerCase().contains(str.toLowerCase()) ?? false;
  }
}
