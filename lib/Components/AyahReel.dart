import 'dart:convert';
import 'package:ikrah/Models/bookmark.dart';
import 'package:ikrah/Services/DataBaseService.dart';
import 'package:flutter/material.dart';
import 'package:ikrah/Components/CommentSection.dart';
import 'package:ikrah/Components/JournalSection.dart';
import 'package:ikrah/Providers/OptionsProvider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

Future<String> getAyahText(
    {required int AyahNo, required String edition}) async {
  final response = await http
      .get(Uri.parse('http://api.alquran.cloud/v1/ayah/${AyahNo}/${edition}'));
  return json.decode(response.body)["data"]["text"] as String;
}

Future<Map<String, dynamic>> getAyahOBJ({required int AyahNo}) async {
  final response =
      await http.get(Uri.parse('http://api.alquran.cloud/v1/ayah/${AyahNo}'));
  return json.decode(response.body)["data"] as Map<String, dynamic>;
}

class AyahReel extends StatefulWidget {
  final int ayahNumber;
  final PageController pageController;
  AyahReel({
    required this.ayahNumber,
    required this.pageController,
  });

  @override
  State<AyahReel> createState() => _AyahReelState();
}

class _AyahReelState extends State<AyahReel> {
  final DataBaseService db = DataBaseService();
  final _player = AudioPlayer();
  late final AyahOBJ;
  late String playmode;
  bool paused = false;
  bool bookmarked = false;
  bool Sajda = false;
  String? AyahArabicText;
  String? AyahEnglishText;

  final TextStyle AyahStyle = const TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    textBaseline: TextBaseline.alphabetic,
  );

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> bookmark() async {
    if (!bookmarked) {
      await db.insertBookmark(
          Bookmark(ayah: widget.ayahNumber, time: DateTime.now()));
    } else {
      await db.deleteBookmark(widget.ayahNumber);
    }
    setState(() {
      bookmarked = !bookmarked;
    });
  }

  Future<void> _init() async {
    AyahOBJ = await getAyahOBJ(AyahNo: widget.ayahNumber);
    final AET =
        await getAyahText(AyahNo: widget.ayahNumber, edition: "en.sahih");

    bookmarked = await db.bookmarkExists(widget.ayahNumber);

    final settings = await db.getSettings();
    playmode = settings.PlayMode;

    if (mounted) {
      setState(() {
        AyahArabicText = AyahOBJ["text"];
        AyahEnglishText = AET;
        Sajda = AyahOBJ["sajda"] is bool
            ? AyahOBJ["sajda"]
            : AyahOBJ["sajda"]["obligatory"];
      });
      await _player.setUrl(
          "https://cdn.islamic.network/quran/audio/128/ar.alafasy/${widget.ayahNumber}.mp3");
      _player.positionStream.listen((event) {
        if (_player.duration != null &&
            event.inMilliseconds == _player.duration!.inMilliseconds) {
          switch (playmode) {
            case 'next':
              widget.pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
              break;
            case 'once':
              _player.pause();
              _player.seek(const Duration());
              setState(() {
                paused = !paused;
              });
              break;
            case 'loop':
              _player.seek(const Duration());
              _player.play();
              break;
          }
        }
      });
    }

    _player.play();
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    playmode = context.watch<OptionsProvider>().playMode;
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onDoubleTap: () {
            bookmark();
          },
          onTap: () {
            paused ? _player.play() : _player.pause();
            setState(() {
              paused = !paused;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            color: context.watch<OptionsProvider>().darkMode
                ? Colors.black12
                : Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: SingleChildScrollView(
                      child: Text(
                        AyahArabicText ?? "Loading...",
                        style: AyahStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AyahEnglishText == null
                      ? const CircularProgressIndicator()
                      : Flexible(
                          child: SingleChildScrollView(
                            child: SelectableText(
                              AyahEnglishText ?? "Loading...",
                              style: AyahStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
        paused
            ? GestureDetector(
                onTap: () {
                  _player.play();
                  setState(() {
                    paused = !paused;
                  });
                },
                child: Center(
                  child: SizedBox.square(
                    dimension: MediaQuery.of(context).size.height * .15,
                    child: ClipOval(
                      child: Container(
                        color: const Color.fromARGB(100, 100, 100, 100),
                        child: Icon(
                          Icons.play_arrow,
                          size: MediaQuery.of(context).size.height * .1,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        PositionedDirectional(
            bottom: MediaQuery.of(context).size.height * .05,
            end: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bookmark Button
                IconButton(
                  onPressed: () {
                    bookmark();
                  },
                  icon: Icon(
                    bookmarked ? Icons.bookmark : Icons.bookmark_border,
                    size: 35,
                  ),
                ),
                Text(bookmarked ? "Bookmarked" : "Bookmark",
                    style: const TextStyle(fontSize: 10)),
                // Journal Button
                IconButton(
                  onPressed: () {
                    if (!paused) {
                      _player.pause();
                      setState(() {
                        paused = !paused;
                      });
                    }
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return JournalSection();
                        });
                  },
                  icon: const Icon(
                    Icons.add_circle_outline,
                    size: 35,
                  ),
                ),
                const Text("Add Journal", style: TextStyle(fontSize: 10)),
                // Comment Button
                IconButton(
                  onPressed: () {
                    if (!paused) {
                      _player.pause();
                      setState(() {
                        paused = !paused;
                      });
                    }
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return CommentSection();
                        });
                  },
                  icon: const Icon(
                    Icons.mode_comment_outlined,
                    size: 35,
                  ),
                ),
                const Text("Comments", style: TextStyle(fontSize: 10)),
                // Info Button
                IconButton(
                  onPressed: () {
                    if (!paused) {
                      _player.pause();
                      setState(() {
                        paused = !paused;
                      });
                    }
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Center(
                                child: Text("Info about the Ayah",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ))),
                            content: Text(
                              "Ayah no: ${AyahOBJ["number"]}\n"
                              "Surah no: ${AyahOBJ["surah"]["number"]}\n"
                              "Surah Name: ${AyahOBJ["surah"]["name"]}\n"
                              "Surah English Name: ${AyahOBJ["surah"]["englishName"]}\n"
                              "Surah English Name Translation: ${AyahOBJ["surah"]["englishNameTranslation"]}\n"
                              "Revelation Type: ${AyahOBJ["surah"]["revelationType"]}\n"
                              "Ayah no in Surah: ${AyahOBJ["numberInSurah"]}\n"
                              "Juz: ${AyahOBJ["juz"]}\n"
                              "Manzil: ${AyahOBJ["manzil"]}\n",
                              textAlign: TextAlign.justify,
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    _player.play();
                                    setState(() {
                                      paused = !paused;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: const Center(child: Text("Close")))
                            ],
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.info_outline,
                    size: 35,
                  ),
                ),
                const Text("Info", style: TextStyle(fontSize: 10)),
              ],
            )),
        // Sajda Icon
        Sajda
            ? const PositionedDirectional(
                top: 5,
                start: 5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageIcon(
                      AssetImage("assets/images/sujud.png"),
                      color: Colors.grey,
                      size: 35,
                    ),
                    Text("Sajda", style: TextStyle(fontSize: 10)),
                  ],
                ))
            : const SizedBox(),
      ],
    );
  }
}
