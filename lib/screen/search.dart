import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:falmily/screen/follow.dart';
import 'package:falmily/shaerd/color.dart';
import 'package:flutter/material.dart';

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  final control = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    control.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        title: TextFormField(
          onChanged: (value) {
            setState(() {});
          },
          controller: control,
          decoration: InputDecoration(labelText: "Search from a User"),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('userSSS')
            .where("username", isEqualTo: control.text)
            .get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return follow(userdata: snapshot.data!.docs[index]);
                        },
                      ));
                    },
                    title: Text(
                      snapshot.data!.docs[index]["username"],
                      style: TextStyle(fontSize: 20),
                    ),
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundImage:
                          NetworkImage(snapshot.data!.docs[index]["prfileImg"]),
                    ));
              },
            );
          }

          return Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ));
        },
      ),
    );
  }
}
