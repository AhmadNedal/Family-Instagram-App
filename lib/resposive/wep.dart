import 'package:falmily/screen/add.dart';
import 'package:falmily/screen/home.dart';
import 'package:falmily/screen/love.dart';
import 'package:falmily/screen/search.dart';
import 'package:falmily/shaerd/color.dart';
import 'package:flutter/material.dart';

import '../screen/person.dart';

class wep extends StatefulWidget {
  const wep({super.key});

  @override
  State<wep> createState() => _wepState();
}

class _wepState extends State<wep> {
  final PageController _pageController = PageController();
  int page = 0;

  movepage(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      page = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false,
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Image.asset(
            "images/familylo.png",
            height: 47,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  movepage(0);
                },
                icon: Icon(
                  Icons.home,
                  color: page == 0 ? primaryColor : secondaryColor,
                )),
            IconButton(
                onPressed: () {
                    movepage(1);
                },
                icon: Icon(Icons.search,
                    color: page == 1 ? primaryColor : secondaryColor)),
            IconButton(
                onPressed: () {
                    movepage(2);
                },
                icon: Icon(Icons.add_a_photo,
                    color: page == 2 ? primaryColor : secondaryColor)),
            IconButton(
                onPressed: () {
                  movepage(3);
                },
                icon: Icon(Icons.favorite,
                    color: page == 3 ? primaryColor : secondaryColor)),
            IconButton(
                onPressed: () {
                  movepage(4);
                },
                icon: Icon(Icons.person,
                    color: page == 4 ? primaryColor : secondaryColor)),
          ],
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            home(),
            search(),
            add(),
            love(),
            person(),
          ],
        ),
      ),
    );
  }
}
