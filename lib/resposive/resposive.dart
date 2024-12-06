import 'package:falmily/provider/userprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class resposive extends StatefulWidget {
  final mywep;
  final mymobile;

  resposive({super.key, required this.mywep, required this.mymobile});

  @override
  State<resposive> createState() => _resposiveState();
}

class _resposiveState extends State<resposive> {


    getDataFromDB() async {
    UserProvider userProvider = Provider.of(context, listen: false);
       await userProvider.refreshUser();
      }
 
 
 @override
 void initState() {
    super.initState();
    getDataFromDB();
 }



  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (buildContext , boxConstraints) {
      if (boxConstraints.maxWidth > 600) {
        return widget.mywep;
      } else {
        return widget.mymobile;
      }
    });
  }
}
