 import 'package:falmily/firebase_services/auth.dart';
import 'package:falmily/model/user.dart';
import 'package:flutter/material.dart';


class UserProvider with ChangeNotifier {
  userdata? _userData;
  userdata? get getUser => _userData;
  
  refreshUser() async {
    userdata userData = await AuthMethods().getUserDetails();
    _userData = userData;
    notifyListeners();
  }
 }