import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_authentication/screens/confirmations_tiktok.dart';
import 'package:flutter_authentication/utils/db_variables.dart';
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
  late Stream<QuerySnapshot<Map<String,dynamic>>> mostPopularTemplateSkewsStream;

  @override
  void initState() {
    _currentUser = widget.user;
    mostPopularTemplateSkewsStream = skewscollection.snapshots();
    super.initState();
  }

  pickvideo(ImageSource src) async {
    Navigator.pop(context);
    final video = await ImagePicker().getVideo(source: src);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConfirmPage_Tiktok(
                File(video!.path), video.path, src,
                user: _currentUser)));
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

  // @override
  // Widget build(BuildContext context) {
  //   var size = MediaQuery.of(context).size;
  //   return Scaffold(
  //     body: Stack(
  //       children: [
  //         SingleChildScrollView(
  //           child: Column(
  //             children: [
  //               Row(
  //                 children: [
  //                   InkWell(
  //                       onTap: () => showoptionsdialog(),
  //                       child: Center(
  //                         child: Container(
  //                             width: 190,
  //                             height: 80,
  //                             decoration: BoxDecoration(color: Colors.red[180]),
  //                             child: Center(
  //                               child: Text("Add Video", style: mystyle(30)),
  //                             )),
  //                       ))
  //                 ],
  //               )
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );

    @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var size = MediaQuery.of(context).size;
    return Scaffold(body: 
      StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
        stream: mostPopularTemplateSkewsStream,
        builder: (context, snapshot)
        {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return PageView.builder(
                itemCount: snapshot.data!.docs.length,
                controller: PageController(initialPage: 0, viewportFraction: 1),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot<Map<String,dynamic>> skewCollection = snapshot.data!.docs[index];
                  List<dynamic> urls = [{...skewCollection.data(), ...{'children': []}}, ...skewCollection['children']];
                  return Stack(children: [
                      //TODO: Similar to the PageView.Builder, we want a row component of length of media in the line below.
                      
                      ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 1,
                        itemBuilder: (context, rowindex) {
                          String mediaUrl = urls[rowindex];
                          return Stack(children: [
                            Image(image: NetworkImage(mediaUrl),),
                            //TODO: this part contains the stuff around the current image, not the next images in teh row, the mext images in the scroll are contained above in the rowindex
                            // Row(children: [
                            //   Container(
                            //     height: 100
                            //   )
                            // ],)
                          ],);
                        },
                      )]);
                }
          );
        }
      ));
    
  }
  
}
