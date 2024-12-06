import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:falmily/edite.dart';
import 'package:falmily/screen/postss.dart';
import 'package:falmily/shaerd/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class person extends StatefulWidget {
  const person({super.key});

  @override
  State<person> createState() => _personState();
}

class _personState extends State<person> {
  bool isloging = true;

  int followers = 0;
  int following = 0;
  int postlen = 0;

  getdatas(data) async {
    dynamic dat =await FirebaseFirestore.instance
        .collection("postSSS")
        .doc(data["postId"])
        .get();

    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return postss(data: dat);
      },
    ));
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  Map userdata = {};
  getdata() async {
    setState(() {
      isloging = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('userSSS')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      userdata = snapshot.data()!;

      followers = userdata["followers"].length;
      following = userdata["following"].length;
    } catch (e) {
      print(e);
    }

    dynamic Snapshotpost = await FirebaseFirestore.instance
        .collection('postSSS')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    postlen = Snapshotpost.docs.length;

    setState(() {
      isloging = false;
    });
    // users.doc(documentId).get(),
  }

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;

    return isloging
        ? Container(
            color: mobileBackgroundColor,
            child: Image.asset("images/palestine.png"))
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              title: Text(userdata["username"]),
              backgroundColor: mobileBackgroundColor,
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
                          userdata["prfileImg"],
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
                              "${postlen}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
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
                              "$followers",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
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
                                  fontWeight: FontWeight.bold, fontSize: 22),
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
                      userdata["title"],
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
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return editeprofilee(data: userdata);
                          },
                        ));
                      },
                      label: Text(
                        "Edite Profie",
                      ),
                      icon: Icon(
                        Icons.edit,
                        size: 19,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                      label: Text(
                        "Log out",
                        style: TextStyle(
                            color: Color.fromARGB(255, 236, 145, 139)),
                      ),
                      icon: Icon(
                        Icons.logout,
                        size: 19,
                        color: Color.fromARGB(255, 236, 145, 139),
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
                      .where('uid',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                                    getdatas(snapshot.data!.docs[int]);
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
