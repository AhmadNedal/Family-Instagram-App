import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:falmily/firebase_services/auth.dart';
import 'package:falmily/shaerd/contants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class love extends StatefulWidget {
  const love({super.key});

  @override
  State<love> createState() => _loveState();
}

class _loveState extends State<love> {
  final mycontroller = TextEditingController();

  delett({required data}) async {
    await FirebaseFirestore.instance
        .collection("chaTTT")
        .doc(data["idchat"])
        .delete();
  }

  showmodel(data) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
              onPressed: () async {
                delett(data: data);
                Navigator.pop(context);
              },
              padding: EdgeInsets.all(20),
              child: Text(
                "Delete This Chat ",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Group Chat"),
          actions: [],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 630,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chaTTT')
                      .orderBy("datePublished")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Image.asset("images/palestine.png");
                    }

                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return ListTile(
                          title: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data["description"],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                data["uid"] == "hJfVC08lGwQGaFKXJ4nIqf9OUtt1"
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.blue,
                                        size: 17,
                                      )
                                    : Text(""),
                                FirebaseAuth.instance.currentUser!.uid ==
                                            "hJfVC08lGwQGaFKXJ4nIqf9OUtt1" ||
                                        FirebaseAuth
                                                .instance.currentUser!.uid ==
                                            "DiF4DiSJBeZRSLYnWzcalBUlsv73"
                                    ? IconButton(
                                        onPressed: () async {
                                          showmodel(data);
                                        },
                                        icon: Icon(Icons.more_vert))
                                    : Text(""),
                              ],
                            ),
                          ),
                          leading: CircleAvatar(
                            radius: 23,
                            backgroundImage: NetworkImage(data["profileImg"]),
                          ),
                          subtitle: Text(
                            "${DateFormat.Md().format(data["datePublished"].toDate())}  ${DateFormat.Hm().format(data["datePublished"].toDate())}",
                            style: TextStyle(
                                fontSize: 11,
                                color: Color.fromARGB(118, 255, 255, 255)),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              TextField(
                  controller: mycontroller,
                  keyboardType: TextInputType.text,
                  decoration: decorationTextfield.copyWith(
                      hintText: "Send A Chat  ",
                      suffixIcon: IconButton(
                          onPressed: () async {
                            try {
                              DocumentSnapshot<Map<String, dynamic>> snapshot =
                                  await FirebaseFirestore.instance
                                      .collection('userSSS')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .get();
                              await AuthMethods().sentchats(
                                datePublished: DateTime.now(),
                                context: context,
                                titleee: mycontroller.text,
                                profileImg: snapshot["prfileImg"],
                                usernameee: snapshot["username"],
                              );
                            } catch (r) {
                              print(r);
                            }

                            mycontroller.clear();
                          },
                          icon: const Icon(Icons.send)))),
            ],
          ),
        ));
  }
}
