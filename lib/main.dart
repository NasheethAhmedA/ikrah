import 'package:flutter/material.dart';
import 'package:ikrah/Models/settings.dart';
import 'package:ikrah/Pages/MainPage.dart';
import 'package:ikrah/Providers/AppDataProvider.dart';
import 'package:ikrah/Providers/OptionsProvider.dart';
import 'package:ikrah/Services/DataBaseService.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = DataBaseService();
  final options = OptionsProvider();
  final appdata = AppDataProvider();
  await options.getSettings();
  appdata.setCurrentAyah(await db.getCurrentAyah());

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => options),
      ChangeNotifierProvider(create: (context) => appdata),
    ], child: const MainPage()),
  );
}
