import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ikrah/Components/SurahTile.dart';
import 'package:ikrah/Providers/AppDataProvider.dart';
import 'package:provider/provider.dart';

class AllSurahPage extends StatefulWidget {
  const AllSurahPage({super.key});

  @override
  _AllSurahPageState createState() => _AllSurahPageState();
}

class _AllSurahPageState extends State<AllSurahPage> {
  List<dynamic> surahs = [];
  final surahNoController = TextEditingController();
  final ayahNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSurahs();
  }

  Future<void> fetchSurahs() async {
    final response =
        await http.get(Uri.parse('https://api.alquran.cloud/v1/surah'));

    if (response.statusCode == 200) {
      setState(() {
        surahs = json.decode(response.body)["data"] as List<dynamic>;
      });
    } else {
      throw Exception('Failed to load surahs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Container(
          child: surahs.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: surahs.length,
                  itemBuilder: (context, index) {
                    return SurahTile(
                      surah: surahs[index],
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            onPressed: () => showAdaptiveDialog(
              context: context,
              builder: (context) {
                return Center(
                  child: AlertDialog(
                    actionsAlignment: MainAxisAlignment.spaceAround,
                    actionsOverflowAlignment: OverflowBarAlignment.center,
                    actionsOverflowDirection: VerticalDirection.down,
                    title:
                        const Text('Go To Ayah', textAlign: TextAlign.center),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: surahNoController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Surah Number',
                            ),
                          ),
                          TextField(
                            controller: ayahNoController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Ayah Number',
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Random random = Random();
                          context
                              .read<AppDataProvider>()
                              .setAyahSelected((random.nextInt(6236) + 1));
                          Navigator.pop(context);
                        },
                        child: const Text('Randomize'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (surahNoController.text.isEmpty ||
                              ayahNoController.text.isEmpty) {
                            return;
                          }
                          context.read<AppDataProvider>().gotoAyah(
                              int.parse(surahNoController.text),
                              int.parse(ayahNoController.text));
                          Navigator.pop(context);
                        },
                        child: const Text('Go'),
                      )
                    ],
                  ),
                );
              },
            ),
            child: Icon(
              Icons.input,
              color: IconTheme.of(context).color,
              size: 30,
            ),
          ),
        )
      ],
    );
  }
}
