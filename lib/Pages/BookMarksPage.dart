import 'package:flutter/material.dart';
import 'package:ikrah/Models/bookmark.dart';
import 'package:ikrah/Providers/AppDataProvider.dart';
import 'package:ikrah/Services/DataBaseService.dart';
import 'package:provider/provider.dart';

class BookMarksPage extends StatefulWidget {
  @override
  State<BookMarksPage> createState() => _BookMarksPageState();
}

class _BookMarksPageState extends State<BookMarksPage> {
  final DataBaseService db = DataBaseService();

  List<Bookmark> bookmarks = [];

  Future<void> fetchBookmarks() async {
    final List<Bookmark> temp = await db.getBookmarks();
    temp.sort((a, b) => a.time.compareTo(b.time));
    setState(() {
      bookmarks = temp.reversed.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: bookmarks.isEmpty
          ? const Center(
              child: Text('No bookmarks yet'),
            )
          : ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Ayah ${bookmarks[index].ayah}"),
                  subtitle: Text(
                      "Bookmarked at ${bookmarks[index].time.hour.toString().padLeft(2, '0')}:${bookmarks[index].time.minute.toString().padLeft(2, '0')}:${bookmarks[index].time.second.toString().padLeft(2, '0')} - ${bookmarks[index].time.day.toString().padLeft(2, '0')}/${bookmarks[index].time.month.toString().padLeft(2, '0')}/${bookmarks[index].time.year.toString().padLeft(2, '0')}"),
                  trailing: IconButton(
                    color: Colors.red,
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Handles delete bookmark
                      db.deleteBookmark(bookmarks[index].ayah);
                      fetchBookmarks();
                    },
                  ),
                  onTap: () {
                    context
                        .read<AppDataProvider>()
                        .setAyahSelected(bookmarks[index].ayah);
                  },
                );
              },
            ),
    );
  }
}
