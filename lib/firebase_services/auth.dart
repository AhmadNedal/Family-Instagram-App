import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:falmily/firebase_services/store.dart';
import 'package:falmily/model/sendchat.dart';
import 'package:falmily/model/user.dart';
import 'package:falmily/shaerd/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class AuthMethods {
  Future<userdata> getUserDetails() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('userSSS')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return userdata.convertSnap2Model(snap);
  }

  register({
    required emailll,
    required passworddd,
    required context,
    required titleee,
    required usernameee,
    required imgName,
    required imgPath,
  }) async {
    String message = "ERROR => Not starting the code";

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailll,
        password: passworddd,
      );
      message = "ERROR => Registered only";

      String urlll = await getomgurl(
          imgName: imgName, imgPath: imgPath, FolderName: "ProfileImage");

      CollectionReference users =
          FirebaseFirestore.instance.collection('userSSS');

      userdata userr = userdata(
        Email: emailll,
        pass: passworddd,
        title: titleee,
        username: usernameee,
        prfileImg: urlll,
        uid: credential.user!.uid,
        followers: [],
        following: [],
      );

      users.doc(credential.user!.uid).set(userr.convert2Map()).then((value) =>
          showSnackBar(context, "User Added").catchError(
              (error) => showSnackBar(context, "Failed to add user: $error")));
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR :  ${e.code} ");
    } catch (e) {
      showSnackBar(context, "Erorr : $e");
    }

    showSnackBar(context, message);
  }

  siginn({required password, required emailAddress, required context}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(context, "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, "Wrong password provided for that user.");
      }
    }
  }

  sentchats({
    required context,
    required titleee,
    required profileImg,
    required usernameee,
    required datePublished,
  }) async {
    try {
      String idchat = const Uuid().v1();

      CollectionReference users =
          FirebaseFirestore.instance.collection('chaTTT');

      sendchats userr = sendchats(
        username: usernameee,
        uid: FirebaseAuth.instance.currentUser!.uid,
        profileImg: profileImg,
        description: titleee,
        datePublished: datePublished, idchat:idchat ,
      );

      users
          .doc(idchat)
          .set(userr.convert2Map())
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR :  ${e.code} ");
    } catch (e) {
      showSnackBar(context, "Erorr : $e");
    }
  }
}
