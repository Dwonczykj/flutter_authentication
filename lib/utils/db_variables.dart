import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


var usercollection = FirebaseFirestore.instance.collection('users');
var videoscollection = FirebaseFirestore.instance.collection('videos');
var skewscollection = FirebaseFirestore.instance.collection('skews');

Reference videosfolder = FirebaseStorage.instance.ref().child('videos');
Reference imagesfolder = FirebaseStorage.instance.ref().child('images');