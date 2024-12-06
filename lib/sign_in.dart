import 'package:falmily/firebase_services/auth.dart';
import 'package:falmily/register.dart';
import 'package:falmily/shaerd/color.dart';
import 'package:falmily/shaerd/contants.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isVisable = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String na = " Erorr";

  // signIn() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: emailController.text, password: passwordController.text);
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context, "ERROR :  ${e.code} ");
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
    String erro = "";

  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: webBackgroundColor,
            title: const Text("Sign in"),
          ),
          backgroundColor: mobileBackgroundColor,
          body: Center(
              child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: widthScreen > 600 ? widthScreen * .25 : 33,
                vertical: widthScreen > 600 ? 10 : 10),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 64,
                    ),
                    TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        decoration: decorationTextfield.copyWith(
                            hintText: "Enter Your Email : ",
                            suffixIcon: const Icon(Icons.email))),
                    const SizedBox(
                      height: 33,
                    ),
                    TextField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: isVisable ? false : true,
                        decoration: decorationTextfield.copyWith(
                            hintText: "Enter Your Password : ",
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisable = !isVisable;
                                  });
                                },
                                icon: isVisable
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off)))),
                
                
                    const SizedBox(
                      height: 33,
                    ),
                    Text(erro , style: TextStyle(color: Colors.white),),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await AuthMethods().siginn(
                          context: context,
                            password: passwordController.text,
                            emailAddress: emailController.text);
                        // if (!mounted) return;
                        // showSnackBar(context, "Done ... ");

                        setState(() {
                          isLoading = false;
                          erro = "Error Try Agin";
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(webBackgroundColor),
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(12)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Sign in",
                              style: TextStyle(fontSize: 19),
                            ),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Do not have an account?",
                            style: TextStyle(fontSize: 18)),
                        Builder(builder: (context) {
                          return TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Register()),
                                );
                              },
                              child: const Text('sign up',
                                  style: TextStyle(
                                      fontSize: 18,
                                      decoration: TextDecoration.underline)));
                        }),
                      ],
                    ),
                  ]),
            ),
          ))),
    );
  }
}
