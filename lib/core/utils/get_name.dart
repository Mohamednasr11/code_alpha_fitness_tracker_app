class AppHelpers {
  static String getDisplayName(String email) {
    final localPart = email.split('@').first;
    final nameOnly = localPart.split(RegExp(r'\d'))[0];
    final parts = nameOnly.split(RegExp(r'[._\-]'));
    return parts
        .take(2)
        .map((p) => p.isNotEmpty
            ? '${p[0].toUpperCase()}${p.substring(1).toLowerCase()}'
            : '')
        .where((p) => p.isNotEmpty)
        .join(' ');
  }
}
