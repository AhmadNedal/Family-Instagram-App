import 'dart:math';
import 'dart:typed_data';
import 'package:falmily/firebase_services/firestore.dart';
import 'package:falmily/provider/userprovider.dart';
import 'package:path/path.dart' show basename;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class add extends StatefulWidget {
  const add({super.key});

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  Uint8List? imgPath1;
  String? imgName1;
  bool istrue = true;

  final description = new TextEditingController();

  uploadImage2Screen(ImageSource source) async {
    Navigator.pop(context);
    final pickedImg = await ImagePicker().pickImage(source: source);
    try {
      if (pickedImg != null) {
        imgPath1 = await pickedImg.readAsBytes();
        setState(() {
          imgName1 = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName1 = "$random$imgName1";
          print(imgName1);
        });
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }

    if (!mounted) return;
  }

  showmodel() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(22),
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await uploadImage2Screen(ImageSource.camera);
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.camera,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Camera",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              GestureDetector(
                onTap: () {
                  uploadImage2Screen(ImageSource.gallery);
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.photo_outlined,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Gallery",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final allDataFromDB = Provider.of<UserProvider>(context).getUser;
    final description = new TextEditingController();

    return imgPath1 != null
        ? Scaffold(
            appBar: AppBar(
              title: IconButton(
                onPressed: () {
                  setState(() {
                    imgPath1 = null;
                    istrue = true;
                  });
                },
                icon: Icon(Icons.arrow_back),
              ),
              actions: [
                TextButton(
                    onPressed: () async{
                        setState(() {
                        istrue = false;
                      });
                    await  firestore().addpostss(
                          profileImg: allDataFromDB!.prfileImg,
                          username: allDataFromDB.username,
                          description: description.text,
                          imgName: imgName1,
                          imgPath: imgPath1,
                          context: context);
                      setState(() {
                        istrue = true;
                        imgPath1=null; 
                      });
                    },
                    child: Text(
                      "Post",
                      style: TextStyle(fontSize: 21),
                    )),
              ],
            ),
            body: Column(
              children: [
                istrue
                    ? Divider(
                        color: Colors.white,
                        height: 12,
                      )
                    : LinearProgressIndicator(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      padding: EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            // "https://cdnimg.royanews.tv/imageserv/Size728Q100/news/20210310/PkXeOj13DYXT3n8vFnOesRddLPDFnwdbN6gClAlB.png"
                            allDataFromDB!.prfileImg),
                        radius: 33,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: description,
                        maxLines: 4,
                        decoration: InputDecoration(
                          
                            hintText: "write a caption ...",
                            border: InputBorder.none),
                      ),
                    ),
                    Container(
                      width: 66,
                      height: 74,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(imgPath1!),
                              fit: BoxFit.cover)),
                    )
                  ],
                ),
              ],
            ))
        : Scaffold(
            body: Center(
                child: IconButton(
                    onPressed: () {
                      showmodel();
                    },
                    icon: Icon(
                      Icons.upload,
                      size: 35,
                    ))));
  }
}
