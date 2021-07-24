import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_authentication/classes/skew.dart';
import 'package:flutter_authentication/utils/db_variables.dart';
import 'package:flutter_authentication/utils/variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

class ConfirmPage extends StatefulWidget {
  final File mediafile;
  final String mediapath_astring;
  final ImageSource imageSource;
  final String? OriginalMediaId;

  const ConfirmPage(this.mediafile, this.mediapath_astring, this.imageSource,
      {this.OriginalMediaId});

  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  TextEditingController musicontroller = TextEditingController();
  TextEditingController captioncontroller = TextEditingController();
  bool isUploading = false;
  Uuid productUuid = Uuid();
  late User _currentUser;
  // TODO: Perhaps find some sort of ImageEdittingController to use for editting and uploading the image.

  @override
  void initState() {
    super.initState();
    _currentUser != FirebaseAuth.instance.currentUser;
    // setState(() {
    //   controller = VideoPlayerController.file(widget.videofile);
    // });
    // controller.initialize();
    // controller.play();
    // controller.setVolume(1);
    // controller.setLooping(true);
    print(widget.mediapath_astring);
  }

  @override
  void dispose() {
    super.dispose();
    // controller.dispose();
  }

  uploadimagetostorage(String id) async {
    UploadTask storageUploadTask =
        imagesfolder.child(id).putFile(widget.mediafile);
    TaskSnapshot storageTaskSnapshot =
        await storageUploadTask.whenComplete(() {});
    String downloadurl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadurl;
  }

  uploadProduct() async {
    setState(() {
      isUploading = true;
    });

    try {
      var firebaseuseruid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userdoc =
          await usercollection.doc(firebaseuseruid).get();
      String id = productIdFromUuid(productUuid);
      String productImgUrl = await uploadimagetostorage(id);
      if (userdoc.data() != null) {
        //var userdata = userdoc.data()!;
        Map<String, dynamic> newProduct = {
          'username': _currentUser.displayName,
          'uid': firebaseuseruid,
          'profilepic': _currentUser.photoURL,
          'id': id,
          'likes': [],
          'commentcount': 0,
          'sharecount': 0,
          'songname': musicontroller.text,
          'caption': captioncontroller.text,
          'producturl': productImgUrl,
          'originalproductid': widget.OriginalMediaId,
          'children': []
        };
        if (widget.OriginalMediaId != null) {
          DocumentSnapshot<SkewServiceModel> originalProduct =
              await skewscollection
                  .doc(widget.OriginalMediaId)
                  .withConverter<SkewServiceModel>(
                      fromFirestore: (snapshot, _) =>
                          SkewServiceModel.fromJson(snapshot.data()!),
                      toFirestore: (skewModel, _) => skewModel.toJson())
                  .get();
          skewscollection
              .doc(widget.OriginalMediaId)
              .update({
                ...originalProduct.data()!.toJson(),
                ...{
                  'children': [...originalProduct.data()!.children, newProduct]
                }
              })
              .then((v) => v)
              .catchError((error) {
                displayErrorToAdminsFailedToUsers(error);
              });
        } else {
          skewscollection.doc().set(newProduct);
        }
      }

      Navigator.pop(context);
    } catch (e) {
      print(e);
    }

    

    // UploadTask storageUploadTask =
    //     imagesfolder.child(id).putFile(widget.mediafile);
    // TaskSnapshot storageTaskSnapshot =
    //     await storageUploadTask.whenComplete(() {});
    // String downloadurl = await storageTaskSnapshot.ref.getDownloadURL();
    // return downloadurl;
  }

  displayErrorToAdminsFailedToUsers(error) {
    print(error.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isUploading == true
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Uploading......", style: mystyle(25)),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: Container(
                      height: 180,
                      width: 120,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(widget.mediapath_astring),
                              fit: BoxFit.fill),
                          shape: BoxShape.circle),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            controller: musicontroller,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Song name",
                                labelStyle: mystyle(20),
                                prefixIcon: Icon(Icons.music_note),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          margin: EdgeInsets.only(right: 40),
                          child: TextField(
                            controller: captioncontroller,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Caption",
                                labelStyle: mystyle(20),
                                prefixIcon: Icon(Icons.closed_caption),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => uploadProduct(),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.green;
                              return Colors
                                  .lightBlue; // Use the component's default.
                            },
                          ),
                          textStyle: mystyle(20, Colors.white),
                        ),
                        child: Text(
                          "Upload Product",
                          style: mystyle(20, Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return Colors.red;
                            },
                          ),
                          textStyle: mystyle(20, Colors.white),
                        ),
                        child: Text(
                          "Back",
                          style: mystyle(20, Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
