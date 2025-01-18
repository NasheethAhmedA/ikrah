import 'package:flutter/material.dart';
import 'package:ikrah/Pages/AboutPage.dart';
import 'package:ikrah/Pages/AllSurahPage.dart';
import 'package:ikrah/Pages/BookMarksPage.dart';
import 'package:ikrah/Pages/JournalPage.dart';
import 'package:ikrah/Pages/SettingsPage.dart';
import 'package:ikrah/Providers/AppDataProvider.dart';
import 'package:ikrah/Providers/OptionsProvider.dart';
import 'package:ikrah/Themes/theme_constants.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();
  final List<String> _titles = <String>['All Surahs', 'Journal', 'Book Marks'];

  void _onItemTapped(int index) {
    context.read<AppDataProvider>().setIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = <Widget>[
      const AllSurahPage(),
      JournalPage(currentAyah: context.watch<AppDataProvider>().CurrentAyah),
      BookMarksPage(),
    ];
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/settings': (BuildContext context) => SettingsPage(),
        '/about': (context) => AboutPage(),
      },
      initialRoute: '/',
      navigatorKey: _navigator,
      title: 'Ikrah',
      debugShowCheckedModeBanner: false,
      theme: context.watch<OptionsProvider>().darkMode ? darkTheme : lightTheme,
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: context.watch<OptionsProvider>().darkMode
                      ? Colors.black
                      : Colors.green,
                ),
                child: const Column(
                  children: [
                    Flexible(
                      child: ImageIcon(
                        AssetImage('assets/images/ikrah.png'),
                        size: 100,
                      ),
                    ),
                    Center(
                        child: Text(
                      'Ikrah',
                      style:
                          TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
                    )),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Settings'),
                onTap: () {
                  _navigator.currentState!.pushNamed('/settings');
                },
              ),
              ListTile(
                title: const Text('About'),
                onTap: () {
                  _navigator.currentState!.pushNamed('/about');
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          actions: [
            Switch(
                value: context.watch<OptionsProvider>().darkMode,
                onChanged: (newValue) {
                  setState(() {
                    context.read<OptionsProvider>().toggleDarkMode();
                  });
                })
          ],
          title: Center(
            child: Text(
              _titles.elementAt(context.watch<AppDataProvider>().selectedIndex),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        body: Center(
          child:
              _pages.elementAt(context.watch<AppDataProvider>().selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'All Surahs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Journal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Book Marks',
            ),
          ],
          currentIndex: context.watch<AppDataProvider>().selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
