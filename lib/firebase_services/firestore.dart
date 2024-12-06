import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:falmily/firebase_services/store.dart';
import 'package:falmily/model/addpost.dart';
import 'package:falmily/shaerd/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class firestore {
  addpostss({
    required profileImg,
    required username,
    required description,
    required imgName,
    required imgPath,
    required context,
  }) async {
    String urlll = await getomgurl(
        imgName: imgName,
        imgPath: imgPath,
        FolderName: "PostImage/${FirebaseAuth.instance.currentUser!.uid}");

    try {
      CollectionReference posts =
          FirebaseFirestore.instance.collection('postSSS');

      String id = Uuid().v1();
      Addpost postt = Addpost(
          profileImg: profileImg,
          username: username,
          description: description,
          imgPost: urlll,
          uid: FirebaseAuth.instance.currentUser!.uid,
          postId: id,
          datePublished: DateTime.now(),
          likes: []);

      posts
          .doc(id)
          .set(postt.convert2Map())
          .then((value) =>
              print("*********************   DDoneee ***********************"))
          .catchError((error) => print(
              "*********************   Erorr ***********************: $error"));
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR :  ${e.code} ");
    } catch (e) {
      print("*********************   Erorr ***********************");
    }
  }

  sendacomment(
      {required allDataFromDB, required mycontroller, required data}) async {
    String commentid = Uuid().v1();
    
    await FirebaseFirestore.instance
        .collection("postSSS")
        .doc(data["postId"])
        .collection("comSS")
        .doc(commentid)
        .set({
      "profileImg": allDataFromDB!.prfileImg,
      "username": allDataFromDB.username,
      "textcomment": mycontroller.text,
      "uid": allDataFromDB.uid,
      "idcomment": commentid,
      "datePublished": DateTime.now(),
    });
  }

  controllikes({required data, required context}) async {
    try {
      if (data["likes"].contains(FirebaseAuth.instance.currentUser!.uid)) {
        await FirebaseFirestore.instance
            .collection("postSSS")
            .doc(data["postId"])
            .update({
          "likes":
              FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection("postSSS")
            .doc(data["postId"])
            .update({
          "likes":
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
        });
      }
    } catch (e) {
      showSnackBar(context, "Erorr: $e");
    }
  }

  doublelike({required data, required context}) async {
    try {
      await FirebaseFirestore.instance
          .collection("postSSS")
          .doc(data["postId"])
          .update({
        "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
      });
    } catch (e) {
      showSnackBar(context, "Erorr: $e");
    }
  }
}

