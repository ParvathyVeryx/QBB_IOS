class Language {
  final int id;
  final String name;
  final String lanCode;

  Language(
    this.id,
    this.name,
    this.lanCode,
  );

  static List<Language> languageList() {
    return <Language>[
      Language(1, "English", "en"),
      Language(2, "عربي", "ar")
    ];
  }
}
