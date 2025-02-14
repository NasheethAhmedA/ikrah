import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ikrah/Services/DataBaseService.dart';

int surahAyahToGlobalAyah(int surah, int ayah) {
  const List<int> SurahOffset = [
    0,
    7,
    293,
    493,
    669,
    789,
    954,
    1160,
    1235,
    1364,
    1473,
    1596,
    1707,
    1750,
    1802,
    1901,
    2029,
    2140,
    2250,
    2348,
    2483,
    2595,
    2673,
    2791,
    2855,
    2932,
    3159,
    3252,
    3340,
    3409,
    3469,
    3503,
    3533,
    3606,
    3660,
    3705,
    3788,
    3970,
    4058,
    4133,
    4218,
    4272,
    4325,
    4414,
    4473,
    4510,
    4545,
    4583,
    4612,
    4630,
    4675,
    4735,
    4784,
    4846,
    4901,
    4979,
    5075,
    5104,
    5126,
    5150,
    5163,
    5177,
    5188,
    5199,
    5217,
    5229,
    5241,
    5271,
    5323,
    5375,
    5419,
    5447,
    5475,
    5495,
    5551,
    5591,
    5622,
    5672,
    5712,
    5758,
    5800,
    5829,
    5848,
    5884,
    5909,
    5931,
    5948,
    5967,
    5993,
    6023,
    6043,
    6058,
    6079,
    6090,
    6098,
    6106,
    6125,
    6130,
    6138,
    6146,
    6157,
    6168,
    6176,
    6179,
    6188,
    6193,
    6197,
    6204,
    6207,
    6213,
    6216,
    6221,
    6225,
    6230,
    6236
  ];

  // Validate input
  if (surah < 1 || surah > 114) {
    throw ArgumentError("Surah number must be between 1 and 114.");
  }
  if (ayah < 1 || ayah > (SurahOffset[surah] - SurahOffset[surah - 1])) {
    throw ArgumentError("Invalid ayah number for the given surah.");
  }

  // Calculate the global ayah number

  return SurahOffset[surah - 1] + ayah;
}

class AppDataProvider with ChangeNotifier, DiagnosticableTreeMixin {
  final DataBaseService _db = DataBaseService();

  int _CurrentAyah = 1;

  int _selectedIndex = 0;

  get CurrentAyah => _CurrentAyah;

  get selectedIndex => _selectedIndex;

  void setCurrentSurah(Map<String, dynamic> surah) {
    _CurrentAyah = surahAyahToGlobalAyah(surah["number"], 1);
    _db.updateCurrentAyah(_CurrentAyah);
    _selectedIndex = 1;
    notifyListeners();
  }

  void setAyahSelected(int ayah) {
    _CurrentAyah = ayah;
    _db.updateCurrentAyah(_CurrentAyah);
    _selectedIndex = 1;
    notifyListeners();
  }

  void gotoAyah(int surah, int ayah) {
    _CurrentAyah = surahAyahToGlobalAyah(surah, ayah);
    _db.updateCurrentAyah(_CurrentAyah);
    _selectedIndex = 1;
    notifyListeners();
  }

  void setCurrentAyah(int ayah) {
    _CurrentAyah = ayah;
    _db.updateCurrentAyah(_CurrentAyah);
    notifyListeners();
  }

  Future<void> setIndex(int index) async {
    _selectedIndex = index;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<int>('selectedIndex', selectedIndex));
    properties.add(DiagnosticsProperty<int>('currentAyah', CurrentAyah));
  }
}
