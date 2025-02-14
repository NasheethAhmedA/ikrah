import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:ikrah/Models/settings.dart';
import 'package:ikrah/Services/DataBaseService.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

int getExtendedVersionNumber(String version) {
  // check if it is not a valid version format
  if (!RegExp(r'^\d+\.\d+\.\d+$').hasMatch(version)) {
    return 0;
  }
  List versionCells = version.split('.');
  versionCells = versionCells.map((i) => int.parse(i)).toList();
  return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
}

class OptionsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final DataBaseService _db = DataBaseService();

  OptionsProvider() {
    _updateAvailable = false;
    _availableVersion = "";
    _currentVersion = "";
    _darkMode = false;
    _playMode = 'once';
  }

  void getPackageVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _currentVersion = packageInfo.version;
    if (_checkUpdate) checkLatestVersion();
  }

  bool _checkUpdate = true;

  bool _updateAvailable = false;

  String _availableVersion = "";

  String _currentVersion = "";

  bool _darkMode = false;

  String _playMode = 'once';

  get darkMode => _darkMode;
  get playMode => _playMode;
  get updateAvailable => _updateAvailable;
  get availableVersion => _availableVersion;
  get currentVersion => _currentVersion;
  get checkUpdate => _checkUpdate;

  Future<void> checkLatestVersion() async {
    final response = await http.get(Uri.parse(
      'https://nasheethahmeda.github.io/ikrah_version/version.json',
    ));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      _availableVersion = data['android']['latestVersion'];
    }
    if (getExtendedVersionNumber(_currentVersion) <
        getExtendedVersionNumber(_availableVersion)) {
      _updateAvailable = true;
      notifyListeners();
    }
  }

  void toggleCheckUpdate() {
    _checkUpdate = !_checkUpdate;
    if (_checkUpdate) {
      checkLatestVersion();
    } else {
      _updateAvailable = false;
    }
    _db.updateSettings(Settings(
        DarkMode: _darkMode, CheckUpdate: _checkUpdate, PlayMode: _playMode));
    notifyListeners();
  }

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    _db.updateSettings(Settings(
        DarkMode: _darkMode, CheckUpdate: _checkUpdate, PlayMode: _playMode));
    notifyListeners();
  }

  void setPlayMode(String mode) {
    _playMode = mode;
    _db.updateSettings(Settings(
        DarkMode: _darkMode, CheckUpdate: _checkUpdate, PlayMode: _playMode));
    notifyListeners();
  }

  Future<void> getSettings() async {
    final settings = await _db.getSettings();
    _darkMode = settings.DarkMode;
    _playMode = settings.PlayMode;
    _checkUpdate = settings.CheckUpdate;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('darkMode', darkMode));
    properties.add(DiagnosticsProperty<String>('playMode', playMode));
    properties
        .add(DiagnosticsProperty<bool>('updateAvailable', updateAvailable));
    properties
        .add(DiagnosticsProperty<String>('availableVersion', availableVersion));
    properties
        .add(DiagnosticsProperty<String>('currentVersion', currentVersion));
    properties.add(DiagnosticsProperty<bool>('checkUpdate', checkUpdate));
  }
}
