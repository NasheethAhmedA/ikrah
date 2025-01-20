// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:ikrah/Models/journalentry.dart';
import 'package:ikrah/Providers/AppDataProvider.dart';
import 'package:ikrah/Providers/OptionsProvider.dart';
import 'package:ikrah/Services/DataBaseService.dart';
import 'package:provider/provider.dart';

class JournalSection extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final DataBaseService db = DataBaseService();

  Future<void> getJournalEntry(int ayah) async {
    final exists = await db.journalEntryExists(ayah);
    if (exists) {
      final journal = await db.getJournalEntry(ayah);
      controller.text = journal.content;
    } else {
      db.insertJournalEntry(JournalEntry(ayah: ayah, content: ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    getJournalEntry(context.watch<AppDataProvider>().CurrentAyah);

    void JournalSave() {
      db.updateJournalEntry(JournalEntry(
          ayah: context.read<AppDataProvider>().CurrentAyah,
          content: controller.text));
    }

    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        PositionedDirectional(
          top: 10,
          child: Text(
              "Journal Ayah ${context.watch<AppDataProvider>().CurrentAyah}",
              style: const TextStyle(
                fontSize: 24.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.watch<OptionsProvider>().darkMode
                  ? Colors.black26
                  : Colors.white24,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black),
            ),
            child: EditableText(
              textAlign: TextAlign.justify,
              showSelectionHandles: true,
              selectionColor: Colors.blue,
              enableInteractiveSelection: true,
              expands: true,
              autofocus: true,
              maxLines: null,
              backgroundCursorColor: context.watch<OptionsProvider>().darkMode
                  ? Colors.black
                  : Colors.white,
              cursorColor: context.watch<OptionsProvider>().darkMode
                  ? Colors.white
                  : Colors.black,
              style: TextStyle(
                color: context.watch<OptionsProvider>().darkMode
                    ? Colors.white
                    : Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              focusNode: FocusNode(),
              controller: controller,
              onChanged: (val) {
                JournalSave();
              },
            ),
          ),
        ),
        PositionedDirectional(
          end: 10,
          top: 10,
          child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context)),
        ),
        PositionedDirectional(
          bottom: 5,
          child: ElevatedButton(
            onPressed: () {
              JournalSave();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        )
      ],
    );
  }
}
