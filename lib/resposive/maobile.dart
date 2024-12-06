import 'package:falmily/screen/add.dart';
import 'package:falmily/screen/home.dart';
import 'package:falmily/screen/love.dart';
import 'package:falmily/screen/person.dart';
import 'package:falmily/screen/search.dart';
import 'package:falmily/shaerd/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class mobile extends StatefulWidget {
  const mobile({super.key});

  @override
  State<mobile> createState() => _mobileState();
}

class _mobileState extends State<mobile> {
  final PageController _pageController = PageController();
  int wid = 0;
  @override

void dispose() {
   _pageController.dispose();
   super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false,
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    
      home: Scaffold(
          
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
      
        bottomNavigationBar: CupertinoTabBar(
            onTap: (index) { 
         _pageController.jumpToPage(index);

              setState(() {
                wid = index;
              });
            },
            activeColor: primaryColor,
            inactiveColor: secondaryColor,
            currentIndex: wid,
            backgroundColor: mobileBackgroundColor,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add_circle,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  label: ""),
            ]),
    
      ),
    );
  }
}
