import 'package:flutter/material.dart';
import 'package:ikrah/Providers/OptionsProvider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            title: const Text('Dark Mode', style: TextStyle(fontSize: 20)),
            subtitle: const Text('Enable dark mode for the app'),
            trailing: Switch(
              value: context.watch<OptionsProvider>().darkMode,
              thumbIcon: context.watch<OptionsProvider>().darkMode
                  ? MaterialStateProperty.all(const Icon(Icons.dark_mode))
                  : MaterialStateProperty.all(const Icon(Icons.light_mode)),
              onChanged: (value) {
                context.read<OptionsProvider>().toggleDarkMode();
              },
            ),
          ),
          ListTile(
            title: const Text('Play Mode', style: TextStyle(fontSize: 20)),
            subtitle: const Text('Play Audio on each Ayah'),
            trailing: DropdownButton(
              focusColor: Colors.transparent,
              items: const [
                DropdownMenuItem(
                  value: 'once',
                  child: Text('Once'),
                ),
                DropdownMenuItem(
                  value: 'loop',
                  child: Text('Looped'),
                ),
                DropdownMenuItem(
                  value: 'next',
                  child: Text('Next'),
                ),
              ],
              value: context.watch<OptionsProvider>().playMode as String,
              onChanged: (String? s) {
                context.read<OptionsProvider>().setPlayMode(s!);
              },
            ),
          ),
          ListTile(
            title: const Text('Check Updates', style: TextStyle(fontSize: 20)),
            subtitle: const Text('Checks for latest updates of ikrah'),
            trailing: Switch(
              value: context.watch<OptionsProvider>().checkUpdate,
              onChanged: (value) {
                context.read<OptionsProvider>().toggleCheckUpdate();
              },
            ),
          ),
        ],
      ),
    );
  }
}
