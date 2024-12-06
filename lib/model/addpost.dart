
import 'package:cloud_firestore/cloud_firestore.dart';

class Addpost {
  final String profileImg;
  final String username;
  final String description;
  final String imgPost;
  final String postId;
  final String uid;
  final DateTime datePublished;
  final List likes;

  Addpost(
      {required this.profileImg,
      required this.username,
      required this.description,
      required this.imgPost,
      required this.postId,
      required this.uid,
      required this.datePublished,
      required this.likes});

  Map<String, dynamic> convert2Map() {
    return {
      "profileImg": profileImg,
      "username": username,
      "description": description,
      "imgPost": imgPost,
      "postId": postId,
      "uid": uid,
      "datePublished": datePublished , 
      "likes": [],
    };
  }

  static convertSnap2Model(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Addpost(
      profileImg: snapshot["profileImg"],
      username: snapshot["username"],
      description: snapshot["description"],
      imgPost: snapshot["imgPost"],
      postId: snapshot["postId"],
      uid: snapshot["uid"],
      datePublished: snapshot["datePublished"],
      likes: snapshot["followers"],
    );
  }
}
