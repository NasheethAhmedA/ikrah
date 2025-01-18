class Bookmark {
  final int ayah;
  final DateTime time;

  Bookmark({
    required this.ayah,
    required this.time,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      ayah: json['ayah'],
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ayah': ayah,
      'time': time.toIso8601String(),
    };
  }
}
