import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:falmily/firebase_services/store.dart';
import 'package:falmily/shaerd/color.dart';
import 'package:falmily/shaerd/contants.dart';
import 'package:falmily/shaerd/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show basename;

class editeprofilee extends StatefulWidget {
  dynamic data;
  editeprofilee({super.key, required this.data});

  @override
  State<editeprofilee> createState() => _editeprofileeState();
}

class _editeprofileeState extends State<editeprofilee> {
  bool isVisable = true;
  Uint8List? imgPath1;
  String? imgName1;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final usernameController = TextEditingController();
  final titleController = TextEditingController();

  String erro = "";
  ipp(data) async {
    String urlll = await getomgurl(
        imgName: imgName1, imgPath: imgPath1, FolderName: "ProfileImage");

    await FirebaseFirestore.instance
        .collection("userSSS")
        .doc(data["uid"])
        .update({"prfileImg": urlll});

    // dynamic dt = await FirebaseFirestore.instance
    //     .collection('postSSS')
    //     .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    //     .get();

    // await FirebaseFirestore.instance
    //     .collection("postSSS")
    //     .doc(dt["postId"])
    //     .update({
    //   "profileImg":
    //       "https://www.bing.com/images/search?view=detailV2&ccid=avb9nDfw&id=59FBEDD9CB9BCD23A902D151D5BAD36A32AA99E7&thid=OIP.avb9nDfw3kq7NOoP0grM4wHaEK&mediaurl=https%3a%2f%2fmy.alfred.edu%2fzoom%2f_images%2ffoster-lake.jpg&cdnurl=https%3a%2f%2fth.bing.com%2fth%2fid%2fR.6af6fd9c37f0de4abb34ea0fd20acce3%3frik%3d55mqMmrTutVR0Q%26pid%3dImgRaw%26r%3d0&exph=3261&expw=5797&q=image&simid=608005032998300783&FORM=IRPRST&ck=B0158D4D407B4160E2EEC26C24481AA8&selectedIndex=0&itb=0&ajaxhist=0&ajaxserp=0"
    //   //  urlll
    // });
  }

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

  updatetitle(date) async {
    if (titleController.text.isEmpty) {
      showSnackBar(context, "Can Not Be Empty ");
    } else {
      await FirebaseFirestore.instance
          .collection("userSSS")
          .doc(date["uid"])
          .update({"title": titleController.text});
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    usernameController.text = widget.data["username"];
    titleController.text = widget.data["title"];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Edite Profile"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: widthScreen > 600 ? widthScreen * .25 : 33,
              vertical: widthScreen > 600 ? 10 : 10),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "\n  التحديث يكون على المنشورات الجدبدة فقط , بعد التعديل اغلق الصفحة وارجع افتحها حتى يتم التحديث",
                    style: TextStyle(fontFamily: "snac", fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(125, 78, 91, 110),
                    ),
                    child: Stack(
                      children: [
                        imgPath1 == null
                            ? CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 225, 225, 225),
                                radius: 71,
                                backgroundImage:
                                    NetworkImage(widget.data["prfileImg"])
                                // backgroundImage: AssetImage("images/user.png"),
                                )
                            : CircleAvatar(
                                radius: 71,
                                backgroundImage: MemoryImage(imgPath1!),
                              ),
                        Positioned(
                          left: 99,
                          bottom: -10,
                          child: IconButton(
                            onPressed: () {
                              // uploadImage2Screen();
                              showmodel();
                            },
                            icon: const Icon(Icons.add_a_photo),
                            color: Color.fromARGB(255, 254, 255, 255),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Text in bio ",
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      decoration: decorationTextfield.copyWith(
                          hintText: "Edite Your title Bio : ",
                          suffixIcon: const Icon(Icons.person_outline))),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(erro),
                  ElevatedButton(
                    onPressed: () async {
                      updatetitle(widget.data);
                      ipp(widget.data);
                      showSnackBar(context, "Modified successfully");
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(webBackgroundColor),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(12)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "update",
                            style: TextStyle(fontSize: 19),
                          ),
                  ),
                  const SizedBox(
                    height: 33,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
