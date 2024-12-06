




import 'package:firebase_storage/firebase_storage.dart';

getomgurl( { required imgName , required  imgPath  , required FolderName})async { 

  final storageRef = FirebaseStorage.instance.ref("$FolderName/$imgName");
    UploadTask uploadTask = storageRef.putData(imgPath);
    TaskSnapshot snap = await uploadTask;

   String url = await snap.ref.getDownloadURL();
      return url ;
}

