import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareApp extends StatelessWidget {
  const ShareApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            shareContent('Check out this awesome app!');
          },
          child: Text('Share'),
        ),
      ),
    );
  }
}

void shareContent(String text) {
  Share.share(text, subject: 'Share App');
}
