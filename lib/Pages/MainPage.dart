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
import 'package:url_launcher/url_launcher.dart';

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
                thumbIcon: context.watch<OptionsProvider>().darkMode
                    ? MaterialStateProperty.all(const Icon(Icons.dark_mode))
                    : MaterialStateProperty.all(const Icon(Icons.light_mode)),
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
        body:
            Stack(alignment: Alignment.center, fit: StackFit.expand, children: [
          Center(
            child: _pages
                .elementAt(context.watch<AppDataProvider>().selectedIndex),
          ),
          context.watch<OptionsProvider>().updateAvailable
              ? BottomSheet(
                  enableDrag: false,
                  elevation: 10,
                  constraints: const BoxConstraints(maxHeight: 50),
                  onClosing: () {},
                  builder: (context) {
                    return Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  launchUrl(
                                    Uri.parse(
                                        "https://github.com/NasheethAhmedA/ikrah/releases/latest/download/ikrah.apk"),
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                                icon: const Icon(Icons.launch)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Flexible(
                                  child: Text(
                                    'Update Available',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    "Version: ${context.watch<OptionsProvider>().availableVersion}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                context
                                    .read<OptionsProvider>()
                                    .toggleCheckUpdate();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  })
              : const SizedBox(),
        ]),
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
