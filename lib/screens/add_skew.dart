import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_authentication/screens/confirm_page.dart';
import 'package:flutter_authentication/utils/variables.dart';
import 'package:image_picker/image_picker.dart';

class AddSkewPage extends StatefulWidget {
  const AddSkewPage({Key? key}) : super(key: key);

  @override
  _AddSkewPageState createState() => _AddSkewPageState();
}

class _AddSkewPageState extends State<AddSkewPage> {
  pickImage(ImageSource src) async {
    Navigator.pop(context);
    final image = await ImagePicker().getImage(source: src);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ConfirmPage(File(image!.path), image.path, src)));
  }

  showOptionsDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () => pickImage(ImageSource.gallery),
                child: Text(
                  "Gallery",
                  style: mystyle(20),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => pickImage(ImageSource.camera),
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
    return InkWell(
      onTap: () => showOptionsDialog(),
      child: Center(
        child: Container(
            width: 190,
            height: 80,
            decoration: BoxDecoration(color: Colors.red[200]),
            child: Center(
              child: Text("Add Product", style: mystyle(30)),
            )),
      ),
    );
  }
}
