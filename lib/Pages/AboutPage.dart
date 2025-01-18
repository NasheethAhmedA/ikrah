import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ImageIcon(AssetImage('assets/images/ikrah.png'), size: 100),
              Center(
                  child: Text("Ikrah",
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold))),
              Center(
                child: Text(
                  'About Our App',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Ikrah Allows users to read the Quran in a continuous scrolling format, bookmark verses, add journals, listen to audio recitations, and access translations in English.\n'
                  'It uses a simple and user-friendly interface with Social media like scrolling pages to make it easier for users to read and understand the Quran.\n'
                  'InshaAllah, we hope that this app will be beneficial for all users.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Feedbacks and Contributions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: SelectableText(
                  'Your feedback on the app is highly appreciated. If you have any suggestions or feedback, please feel free to contact us at our Github repository.\n'
                  'You can also contribute to the app by submitting a pull request or opening an issue on our Github repository.\n'
                  'Find us at: https://github.com/NasheethAhmedA/ikrah',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
