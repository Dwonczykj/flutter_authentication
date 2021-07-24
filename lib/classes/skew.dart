import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SkewService {
  final skewRef = FirebaseFirestore.instance.collection('skews').withConverter(
        fromFirestore: (snapshot, _) =>
            SkewServiceModel.fromJson(snapshot.data()!),
        toFirestore: (skewModel, _) => skewModel.toJson(),
      );

  Future<void> updateskew({
    required SkewServiceModel skewServiceModel,
  }) async {
    return skewRef
        .doc(skewServiceModel.id)
        .update(skewServiceModel.toJson())
        .then((value) => value)
        .catchError((error) {
      print(error.toString());
    });
  }
}

class SkewServiceModel {
  final String username;
  final String uid;
  final String profilepic;
  final String id;
  final List<String> likes;
  final int commentcount;
  final int sharecount;
  final String songname;
  final String caption;
  final String producturl;
  final String originalproductid;
  final List<SkewServiceModel> children;

  const SkewServiceModel({
    required this.username,
    required this.uid,
    required this.profilepic,
    required this.id,
    required this.likes,
    required this.commentcount,
    required this.sharecount,
    this.songname = "",
    required this.caption,
    required this.producturl,
    required this.originalproductid,
    this.children = const [],
  });

  factory SkewServiceModel.fromJson(Map<String, dynamic> json) {
    return SkewServiceModel(
        username: json["username"],
        uid: json["uid"],
        profilepic: json["profilepic"],
        id: json["id"],
        likes: new List<String>.from(json["likes"]),
        commentcount: json["commentcount"],
        sharecount: json["sharecount"],
        songname: json["songname"],
        caption: json["caption"],
        producturl: json["producturl"],
        originalproductid: json["originalproductid"],
        children: new List<SkewServiceModel>.from(
            new List<dynamic>.from(json["children"])
                .map((e) => SkewServiceModel.fromJson(e))));
  }

  Map<String, dynamic> toJson() {
    return {
      'username': this.username,
      'uid': this.uid,
      'profilepic': this.profilepic,
      'id': this.id,
      'likes': this.likes,
      'commentcount': this.commentcount,
      'sharecount': this.sharecount,
      'songname': this.songname,
      'caption': this.caption,
      'producturl': this.producturl,
      'originalproductid': this.originalproductid,
      'children': this.children.map((e) => e.toJson()).toList()
    };
  }
}
