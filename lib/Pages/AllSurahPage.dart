import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ikrah/Components/SurahTile.dart';

class AllSurahPage extends StatefulWidget {
  const AllSurahPage({super.key});

  @override
  _AllSurahPageState createState() => _AllSurahPageState();
}

class _AllSurahPageState extends State<AllSurahPage> {
  List<dynamic> surahs = [];

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
    return Container(
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
    );
  }
}
