class JournalEntry {
  int ayah;
  String content;

  JournalEntry({required this.ayah, required this.content});

  // You can add methods like toJson, fromJson, etc. if needed
  Map<String, dynamic> toJson() {
    return {
      'ayah': ayah,
      'content': content,
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      ayah: json['ayah'],
      content: json['content'],
    );
  }
}
