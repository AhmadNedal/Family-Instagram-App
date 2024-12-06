import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:falmily/screen/follow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class apppass extends StatefulWidget {
  const apppass({super.key});

  @override
  State<apppass> createState() => _apppassState();
}

class _apppassState extends State<apppass> {
  delett(uid) async {
    dynamic userdata =
        await FirebaseFirestore.instance.collection("userSSS").doc(uid).get();

    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return follow(userdata: userdata);
      },
    ));
  }

  showmodel(uidd) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            SimpleDialogOption(
              onPressed: () async {
                delett(uidd);

                Navigator.pop(context);
              },
              padding: EdgeInsets.all(20),
              child: Text(
                "View This profile",
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
        body: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('userSSS').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Scaffold(
          appBar: AppBar(title: Text("All Account"),),
          body: Center(
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(data["prfileImg"]),
                    ),
                    title: Text(data['username']),
                    subtitle: Text(data['Email']),
                    trailing: Container(
                        width: 90,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(data["pass"]),
                              IconButton(
                                  onPressed: () {
                                    showmodel(data['uid']);
                                  },
                                  icon: Icon(Icons.more_vert))
                            ],
                          ),
                        )));
              }).toList(),
            ),
          ),
        );
      },
    ));
  }
}
