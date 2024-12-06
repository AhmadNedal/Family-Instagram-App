import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:falmily/firebase_services/firestore.dart';
import 'package:falmily/provider/userprovider.dart';
import 'package:falmily/shaerd/contants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Comment extends StatefulWidget {
  final dynamic data;
  const Comment({super.key, required this.data});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final mycontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final allDataFromDB = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Comment Post"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 660,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("postSSS")
                      .doc(widget.data["postId"])
                      .collection("comSS")
                      .orderBy("datePublished", descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Image.asset("images/palestine.png");
                    }

                    return Container(
                      height: 300,
                      child: ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> dataa =
                              document.data()! as Map<String, dynamic>;
                          return ListTile(
                            title: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dataa["username"],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  dataa["uid"] == "hJfVC08lGwQGaFKXJ4nIqf9OUtt1"
                                      ? Icon(
                                          Icons.check_circle,
                                          color: Colors.blue,
                                          size: 17,
                                        )
                                      : Text(""),
                                
                                ],
                              ),
                            ),
                            leading: Container(
                                padding: EdgeInsets.all(1.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(dataa["profileImg"]),
                                    radius: 23)),
                            subtitle: Text(
                              "${DateFormat.Md().format(dataa["datePublished"].toDate())}  ${DateFormat.Hm().format(dataa["datePublished"].toDate())}",
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Color.fromARGB(118, 255, 255, 255)),
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text(
                                dataa["textcomment"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 23,
                    backgroundImage: NetworkImage(allDataFromDB!.prfileImg),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                        controller: mycontroller,
                        keyboardType: TextInputType.text,
                        decoration: decorationTextfield.copyWith(
                            hintText: "Send A Comment  ",
                            suffixIcon: IconButton(
                                onPressed: () async {
                                  mycontroller.text.isEmpty
                                      ? null
                                      : firestore().sendacomment(
                                          allDataFromDB: allDataFromDB,
                                          mycontroller: mycontroller,
                                          data: widget.data);

                                  mycontroller.clear();
                                },
                                icon: const Icon(Icons.send)))),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
