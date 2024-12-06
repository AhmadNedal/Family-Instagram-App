import 'package:falmily/firebase_options.dart';
import 'package:falmily/provider/userprovider.dart';
import 'package:falmily/resposive/maobile.dart';
import 'package:falmily/resposive/resposive.dart';
import 'package:falmily/resposive/wep.dart';
import 'package:falmily/shaerd/snackbar.dart';
import 'package:falmily/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBRHFyPbRyDpPwJQZLFpTqTDdlfAzXIt5k",
            authDomain: "falmily-582da.firebaseapp.com",
            projectId: "falmily-582da",
            storageBucket: "falmily-582da.appspot.com",
            messagingSenderId: "366556236216",
            appId: "1:366556236216:web:051e371cca771c231e274d"));
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
       create: (context) {return UserProvider();},
      child: MaterialApp(
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            } else if (snapshot.hasError) {
              return showSnackBar(context, "Something went wrong");
            } else if (snapshot.hasData) {
              return resposive(mywep: const wep(), mymobile:  const mobile());
            } else {
              return const Login();
            }
          },
        ),
      ),
    );
  }
}
