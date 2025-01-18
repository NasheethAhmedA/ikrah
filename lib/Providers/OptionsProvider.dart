import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ikrah/Models/settings.dart';
import 'package:ikrah/Services/DataBaseService.dart';

class OptionsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final DataBaseService _db = DataBaseService();

  OptionsProvider() {
    _darkMode = false;
    _playMode = 'once';
  }

  bool _darkMode = false;

  String _playMode = 'once';

  get darkMode => _darkMode;
  get playMode => _playMode;

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    _db.updateSettings(Settings(DarkMode: _darkMode, PlayMode: _playMode));
    notifyListeners();
  }

  void setPlayMode(String mode) {
    _playMode = mode;
    _db.updateSettings(Settings(DarkMode: _darkMode, PlayMode: _playMode));
    notifyListeners();
  }

  Future<void> getSettings() async {
    final settings = await _db.getSettings();
    _darkMode = settings.DarkMode;
    _playMode = settings.PlayMode;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('darkMode', darkMode));
    properties.add(DiagnosticsProperty<String>('playMode', playMode));
  }
}
