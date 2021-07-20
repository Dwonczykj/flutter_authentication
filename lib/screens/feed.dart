import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_authentication/screens/confirmations.dart';
import 'package:flutter_authentication/utils/variables.dart';
import 'package:image_picker/image_picker.dart';

class Feed extends StatefulWidget {
  final User user;

  const Feed({Key? key, required this.user}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  pickvideo(ImageSource src) async {
    Navigator.pop(context);
    final video = await ImagePicker().getVideo(source: src);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ConfirmPage(File(video!.path), video.path, src, user: _currentUser)));
  }

  showoptionsdialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () => pickvideo(ImageSource.gallery),
                child: Text(
                  "Gallery",
                  style: mystyle(20),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => pickvideo(ImageSource.camera),
                child: Text(
                  "Camera",
                  style: mystyle(20),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: mystyle(20),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                        onTap: () => showoptionsdialog(),
                        child: Center(
                          child: Container(
                              width: 190,
                              height: 80,
                              decoration: BoxDecoration(color: Colors.red[180]),
                              child: Center(
                                child: Text("Add Video", style: mystyle(30)),
                              )),
                        ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
