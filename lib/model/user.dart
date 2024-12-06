import 'package:cloud_firestore/cloud_firestore.dart';

class userdata {
  String pass;
  String Email;
  String title;
  String username;
  String prfileImg;
  String uid;
  List followers;
  List following;
  userdata(
      {required this.Email,
      required this.pass,
      required this.title,
      required this.prfileImg,
      required this.username,
      required this.uid,
      required this.followers,
      required this.following,

      });
Map<String, dynamic> convert2Map() {
    return {
      "pass": pass,
      "Email": Email,
      "title": title,
      "username": username,
      "prfileImg" : prfileImg, 
      "uid" : uid ,
      "followers" :[] ,
      "following": [] , 
    };
  }

  static    convertSnap2Model(DocumentSnapshot snap) {
 var snapshot = snap.data() as Map<String, dynamic>;
 return userdata(
  Email: snapshot["Email"],
  username: snapshot["username"],
  pass: snapshot["pass"],
  prfileImg: snapshot["prfileImg"],
  title: snapshot["title"],
  uid: snapshot["uid"],
  following: snapshot["following"],
  followers: snapshot["followers"],

);
 }




}



