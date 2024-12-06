import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:falmily/screen/appbarpass.dart';
import 'package:falmily/screen/love.dart';
import 'package:falmily/shaerd/color.dart';
import 'package:falmily/shaerd/postdesgin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          widthScreen > 600 ? webBackgroundColor : mobileBackgroundColor,
      appBar: widthScreen > 600
          ? null
          : AppBar(
              actions: [


           FirebaseAuth.instance.currentUser!.uid=="hJfVC08lGwQGaFKXJ4nIqf9OUtt1" ? 
                  IconButton(
                    onPressed: () async {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return apppass();
                        },
                      ));
                    },
                    icon: Icon(
                      Icons.show_chart_outlined,
                      color: Colors.white,
                    )):Text(""),


                IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return love();
                        },
                      ));
                    },
                    icon: Icon(
                      Icons.message_outlined,
                      color: Colors.white,
                    )),
        
                IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Colors.white,
                    )),
              
              ],
              backgroundColor: mobileBackgroundColor,
              title: Image.asset(
                "images/familylo.png",
                height: 47,
              ),
            ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('postSSS')
            .orderBy("datePublished", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Image.asset("images/palestine.png");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return postdesign(
                data: data,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
