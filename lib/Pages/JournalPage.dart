import 'package:flutter/material.dart';
import 'package:ikrah/Components/AyahReel.dart';
import 'package:ikrah/Providers/AppDataProvider.dart';
import 'package:provider/provider.dart';

class JournalPage extends StatefulWidget {
  final int currentAyah;
  JournalPage({required this.currentAyah});
  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late final PageController _PageController;

  @override
  void initState() {
    super.initState();
    _PageController = PageController(initialPage: widget.currentAyah - 1);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _PageController,
      onPageChanged: (index) =>
          context.read<AppDataProvider>().setCurrentAyah(index + 1),
      scrollDirection: Axis.vertical,
      itemCount: 6235,
      itemBuilder: (context, index) {
        return AyahReel(
          ayahNumber: index + 1,
          pageController: _PageController,
        );
      },
    );
  }
}
