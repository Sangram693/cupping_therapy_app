class Validators {
  Validators._();

  static String? validateRequired(
    String? value, {
    required String requiredMessage,
  }) {
    if (value == null || value.trim().isEmpty) {
      return requiredMessage;
    }
    return null;
  }

  static String? validateEmail(
    String? value, {
    required String requiredMessage,
    required String invalidMessage,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return requiredMessage;
    }
    const emailPattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$";
    if (!RegExp(emailPattern).hasMatch(trimmed)) {
      return invalidMessage;
    }
    return null;
  }

  static String? validatePassword(
    String? value, {
    int minLength = 8,
    required String requiredMessage,
    required String minLengthMessage,
  }) {
    if (value == null || value.isEmpty) {
      return requiredMessage;
    }
    if (value.length < minLength) {
      return minLengthMessage;
    }
    return null;
  }
}
