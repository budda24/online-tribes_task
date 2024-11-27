extension StringExtensions on String {
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');
  String limitToTwoSentences() {
    if (isEmpty) return '';

    // Handle common abbreviations
    final withProtectedAbbreviations = replaceAllMapped(
      RegExp(r'([A-Z][a-z]*\.) (?=[A-Z])'),
      (match) => match.group(0)!.replaceAll('. ', '.<DOT>'),
    );

    // Split on sentence endings and clean up
    final sentences = withProtectedAbbreviations
        .split(RegExp('[.!?] +'))
        .map((s) => s.replaceAll('.<DOT>', '. ').trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (sentences.isEmpty) return this;
    if (sentences.length == 1) return sentences[0];
    return '${sentences[0]}. ${sentences[1]}.';
  }
}

extension SanitizationExtensions on String {
  // Sanitize for general use, including Firebase
  String get sanitizedForFirebase {
    // Replace common dangerous characters with safe alternatives
    return replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;')
        .replaceAll(
          '.',
          '&#x2E;',
        ) // Prevents potential issues with Firebase keys
        .replaceAll('[', '&#x5B;')
        .replaceAll(']', '&#x5D;')
        .replaceAll('#', '&#x23;')
        .replaceAll(
          r'$',
          '&#x24;',
        ); // Prevents issues with Firebase's path structure
  }

  // General input sanitization for mobile apps
  String get sanitized {
    return replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;');
  }

  String sanitizedForFirebaseKey() {
    // Firebase keys cannot contain '.', '#', '$', '[', or ']'
    return replaceAll('.', ',')
        .replaceAll('#', '%23')
        .replaceAll(r'$', '%24')
        .replaceAll('[', '%5B')
        .replaceAll(']', '%5D');
  }
}

extension DiacriticsAwareString on String {
  static const diacritics = 'ąęćłńóśźż';
  static const nonDiacritics = 'aeclnoszz';

  static final _diacriticsMap = Map.fromIterables(
    diacritics.split(''),
    nonDiacritics.split(''),
  );

  String get withoutDiacriticalMarks =>
      split('').map((char) => _diacriticsMap[char] ?? char).join();
}
