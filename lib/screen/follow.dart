import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:falmily/screen/postss.dart';
import 'package:falmily/shaerd/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class follow extends StatefulWidget {
  dynamic userdata;
  follow({super.key, required this.userdata});

  @override
  State<follow> createState() => _followState();
}

class _followState extends State<follow> {
  bool iffolow = false;
  int postCount = 0;

  late int followers;
  late int following;
  bool showwidget = true;

  getdata() async {
    var snapshotPosts = await FirebaseFirestore.instance
        .collection('postSSS')
        .where("uid", isEqualTo: widget.userdata["uid"])
        .get();
    postCount = snapshotPosts.docs.length;

    iffolow = widget.userdata['followers']
        .contains(FirebaseAuth.instance.currentUser!.uid);

    followers = widget.userdata["followers"].length;
    following = widget.userdata["following"].length;
    setState(() {
      showwidget = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getdata();
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;

    follows() async {
      await FirebaseFirestore.instance
          .collection("userSSS")
          .doc(widget.userdata["uid"])
          .update({
        "followers":
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
      });
      await FirebaseFirestore.instance
          .collection("userSSS")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "following": FieldValue.arrayUnion([widget.userdata["uid"]])
      });
    }

    unfollow() async {
      await FirebaseFirestore.instance
          .collection("userSSS")
          .doc(widget.userdata["uid"])
          .update({
        "followers":
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
      });
      await FirebaseFirestore.instance
          .collection("userSSS")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "following": FieldValue.arrayRemove([widget.userdata["uid"]])
      });
    }

    return showwidget
        ? Center(
            child: CircularProgressIndicator(
            color: Colors.white,
          ))
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              title: Row(children: [  widget.userdata["uid"]=="hJfVC08lGwQGaFKXJ4nIqf9OUtt1" ? Icon(Icons.check_circle, color: Colors.blue,size: 20,)   : Text(""),
                          SizedBox(
                          width:4,
                        ),   Text(widget.userdata["username"]),],),
              backgroundColor: mobileBackgroundColor,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          widget.userdata["prfileImg"],
                        ),
                        radius: 40,
                      ),
                    ),
                    SizedBox(
                      width: 53,
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              "${postCount}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "Post",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Text(
                              "${followers}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "followers",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Text(
                              "$following",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "following",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 25,
                    ),
                  ],
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 17, 260, 25),
                    width: double.infinity,
                    child: Text(
                      widget.userdata["title"],
                      textAlign: TextAlign.center,
                    )),
                Divider(
                  color: Colors.white,
                  thickness: widthScreen > 600 ? 0.06 : 0.09,
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(iffolow
                              ? Color.fromARGB(255, 215, 47, 47)
                              : const Color.fromARGB(255, 4, 101, 181))),
                      onPressed: () async {
                        iffolow ? unfollow() : follows();
                        setState(() {
                          iffolow ? followers-- : followers++;
                          iffolow = !iffolow;
                        });
                      },
                      label: Text(
                        style: TextStyle(color: Colors.white),
                        iffolow ? " unFolow " : "Folow",
                      ),
                      icon: Icon(
                        Icons.add,
                        size: 19,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 7,
                ),
                Divider(
                  color: Colors.white,
                  thickness: widthScreen > 600 ? 0.06 : 0.09,
                ),
                SizedBox(
                  height: 16,
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('postSSS')
                      .where('uid', isEqualTo: widget.userdata["uid"])
                      .get(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: widthScreen > 600 ? 55 : 8),
                          child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 3 / 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext, int) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return postss(
                                            data: snapshot.data!.docs[int]);
                                      },
                                    ));
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.36,

                                      snapshot.data!.docs[int]["imgPost"],
                                      // "https://th.bing.com/th/id/OIP.DXoEptmY3nmo9GFy8fU9QwAAAA?rs=1&pid=ImgDetMain",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }),
                        ),
                      );
                    }

                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  },
                )
              ],
            ));
  }
}
