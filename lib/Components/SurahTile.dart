import 'package:flutter/material.dart';
import 'package:ikrah/Providers/AppDataProvider.dart';
import 'package:provider/provider.dart';

class SurahTile extends StatelessWidget {
  final Map<String, dynamic> surah;

  const SurahTile({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.center,
      isThreeLine: true,
      contentPadding: const EdgeInsets.all(10),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: Text(surah["number"].toString()),
      ),
      title: Center(child: Text(surah["englishName"] + ' - ' + surah["name"])),
      subtitle: Center(
          child: Text(
              '${surah["englishNameTranslation"]}\n${surah["numberOfAyahs"]} Ayahs - ${surah["revelationType"]}',
              textAlign: TextAlign.center)),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {
        context.read<AppDataProvider>().setCurrentSurah(surah);
      },
    );
  }
}
