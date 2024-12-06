import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:falmily/firebase_services/firestore.dart';
import 'package:falmily/screen/comment.dart';
import 'package:falmily/shaerd/heart_animation.dart';
import 'package:falmily/shaerd/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class postss extends StatefulWidget {
  dynamic data;
  postss({super.key, required this.data});

  @override
  State<postss> createState() => _postssState();
}

class _postssState extends State<postss> {
  late int like;
  int numcomment = 0;
  bool showhart = false;
  bool isLikeAnimating = false;
  late bool islike;
  late int numlike;

  @override
  void initState() {
    numlike = widget.data["likes"].length;
    islike =
        widget.data['likes'].contains(FirebaseAuth.instance.currentUser!.uid);
    claculate();
    super.initState();
  }

  addlikedouble() {
    if (islike) {
    } else {
      setState(() {
        numlike++;
        islike = !islike; 
      });
    }
  }

  clikelike() {
    if (islike) {
      setState(() {
        numlike--;
      });
    } else {
      setState(() {
        numlike++;
      });
    }
  }

  claculate() async {
    try {
      QuerySnapshot dataaa = await FirebaseFirestore.instance
          .collection("postSSS")
          .doc(widget.data["postId"])
          .collection("comSS")
          .get();
      setState(() {
        numcomment = dataaa.docs.length;
      });
    } catch (e) {
      showSnackBar(context, "Erorr : ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    delett() async {
      await FirebaseFirestore.instance
          .collection("postSSS")
          .doc(widget.data["postId"])
          .delete();
      Navigator.pop(context);
      showSnackBar(context, "The post has been deleted");
    }

    showmodel() {
      return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () async {
                  widget.data["uid"] == FirebaseAuth.instance.currentUser!.uid
                      ? delett()
                      : null;

                  Navigator.pop(context);
                },
                padding: EdgeInsets.all(20),
                child: Text(
                  widget.data["uid"] == FirebaseAuth.instance.currentUser!.uid
                      ? "Delete Post"
                      : "View The Profile",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.all(20),
                child: Text(
                  "Cancle",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          );
        },
      );
    }

    gotocomment() {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return Comment(
              data: FirebaseFirestore.instance
                  .collection("postSSS")
                  .doc(widget.data["postId"])
                  .get());
        },
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                          padding: EdgeInsets.all(1.7),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.data["profileImg"]),
                            radius: 26,
                          )),
                      SizedBox(
                        width: 14,
                      ),

                          widget.data["uid"]=="hJfVC08lGwQGaFKXJ4nIqf9OUtt1" ? Icon(Icons.check_circle, color: Colors.blue,size: 20,)   : Text(""),
                          SizedBox(
                          width:4,
                        ),
                      Text(
                        widget.data["username"],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        showmodel();
                      },
                      icon: Icon(Icons.more_vert))
                ],
              ),
            ),
            GestureDetector(
              onDoubleTap: () {
                addlikedouble();
                setState(() {
                  isLikeAnimating = true;
                });

                firestore().doublelike(data: widget.data, context: context);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.83,
                    child: Image.network(
                      loadingBuilder: (context, child, progress) {
                        return progress == null
                            ? child
                            : SpinKitSquareCircle(
                                color: Colors.white,
                                size: 50.0,
                              );
                      },
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.8,
                      widget.data["imgPost"],
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                        isAnimating: isLikeAnimating,
                        duration: const Duration(
                          milliseconds: 400,
                        ),
                        onEnd: () {
                          setState(() {
                            isLikeAnimating = false;
                          });
                        },
                        child: Container(
                          child: Image.asset("images/love.png"),
                          height: 160,
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      LikeAnimation(
                        isAnimating: widget.data['likes']
                            .contains(FirebaseAuth.instance.currentUser!.uid),
                        smallLike: true,
                        child: IconButton(
                          onPressed: () async {
                            setState(() {
                              clikelike();
                              islike = !islike;
                              firestore().controllikes(
                                  data: widget.data, context: context);
                            });
                          },
                          icon: islike
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return Comment(
                                  data: widget.data,
                                );
                              },
                            ));
                          },
                          icon: Icon(Icons.comment_outlined)),
                      IconButton(onPressed: () {
                        showSnackBar(context, "Not Available now");

                      }, icon: Icon(Icons.send)),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        showSnackBar(context, "Not Available now");
                      },
                      icon: Icon(Icons.bookmark_outline_outlined)),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 10, bottom: 10),
                width: double.infinity,
                child: widget.data["likes"].length >= 2
                    ? Text("${numlike}  Likes")
                    : Text(
                        "${numlike}  Like",
                        textAlign: TextAlign.start,
                      )),
            Row(
              children: [
                Text(
                  widget.data["username"],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text(
                  "    ${widget.data["description"]} ",
                  style: TextStyle(fontSize: 14),
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                gotocomment();
              },
              child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 4),
                  width: double.infinity,
                  child: Text(
                    "View $numcomment comment ",
                    textAlign: TextAlign.start,
                  )),
            ),
            Container(
                width: double.infinity,
                child: Text(
                  // Widget.data["datePublished"].toDate().toString(),
                  "${DateFormat.Md().format(widget.data["datePublished"].toDate())}  ${DateFormat.Hm().format(widget.data["datePublished"].toDate())}",

                  textAlign: TextAlign.start,
                )),
          ],
        ),
      ),
    );
  }
}
