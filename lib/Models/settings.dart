class Settings {
  bool DarkMode;
  String PlayMode;

  Settings({
    required this.DarkMode,
    required this.PlayMode,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      DarkMode: json['DarkMode'] == 1 ? true : false,
      PlayMode: json['PlayMode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DarkMode': DarkMode ? 1 : 0,
      'PlayMode': PlayMode,
    };
  }
}
