
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class sendchats {
  final String profileImg;
  final String username;
  final String description;
  final String uid;
  final DateTime datePublished;
  

  sendchats(
      {required this.profileImg,
      required this.username,
      required  this.datePublished,
      required this.description,
      required this.idchat,
      
      required this.uid,
    });
      String id =FirebaseAuth.instance.currentUser!.uid;
      String idchat = const Uuid().v1();

  Map<String, dynamic> convert2Map() {
    return {
      "profileImg": profileImg,
      "username": username,
      "description": description,
      "uid": id,
      "idchat" :idchat, 
      "datePublished" :DateTime.now(),
    };
  }

  static convertSnap2Model(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return sendchats(
      idchat :snapshot["idchat"],
      profileImg: snapshot["profileImg"],
      username: snapshot["username"],
      description: snapshot["description"],
      uid: snapshot["uid"], datePublished: snapshot["datePublished"],
    );
  }
}
