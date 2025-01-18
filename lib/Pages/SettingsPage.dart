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
                  child: Text('Once'),
                  value: 'once',
                ),
                DropdownMenuItem(
                  child: Text('Looped'),
                  value: 'loop',
                ),
                DropdownMenuItem(
                  child: Text('Next'),
                  value: 'next',
                ),
              ],
              value: context.watch<OptionsProvider>().playMode as String,
              onChanged: (String? s) {
                context.read<OptionsProvider>().setPlayMode(s!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
