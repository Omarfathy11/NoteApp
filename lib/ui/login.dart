import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/homepage.dart';
import 'package:login/ui/signup.dart';
import '../components/custombutton.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../components/textformfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  bool isloading = false;

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return; // ========
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushReplacementNamed("HomePage");
  }
   @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: isloading ? Center(child: CircularProgressIndicator(),) : Container(
          padding: const EdgeInsets.all(20),
          child: ListView(children: [
            Form(
              key: formstate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(color: Colors.white),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(10),
                      child: Image.asset('assets/notebook_3426650.png'),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Login to continue using the app",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Email",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                      hinttext: 'Enter Your Email',
                      myController: email,
                      validator: (val) {
                        if (val == "") {
                          return "can't be empty";
                        }
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Password",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                  const SizedBox(
                    height: 10,
                  ), // بيعمل تباعد بينهم
                  CustomTextFormField(
                    hinttext: 'Enter Your password',
                    myController: password,
                    validator: (val) {
                      if (val == "") {
                        return "can't be empty";
                      }
                    },
                  ),
                  InkWell(
                    onTap: () async {
                      if (email.text == "") {
                                   AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              title: "Error",
                              desc: "Please write your email address and then press Forget Password " , descTextStyle: TextStyle(fontSize: 18),
            ).show();
                        return;
                      }
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email.text);
                         AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              title: "Error",
                              desc:  "A link to reset your password has been sent to your email. Please go to it and click on the link" , descTextStyle: TextStyle(fontSize: 18),
            ).show();
                    },
                    
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      alignment: Alignment.topRight,
                      child: const Text("Forgot Password ? ",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            CustomButton(
              title: "login",
              onPressed: () async {
                if (formstate.currentState!.validate()) {
                  try {
                    isloading = true;
                    setState(() {
                      
                    });
                    final credential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                  
                    );
                        isloading = false;
                    setState(() {
                      
                    });
                    if (credential.user!.emailVerified) {
                      Navigator.of(context).pushReplacementNamed("HomePage");
                    } else {
                      FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();
                      AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              title: "Error",
                              desc: "please go to your email and check your verity ", descTextStyle: TextStyle(fontSize: 18),
            ).show();}
                  } on FirebaseAuthException catch (e) {
                       isloading = false;
                    setState(() {
                     AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              title: "Error",
                              desc: "wrong email or password", descTextStyle: TextStyle(fontSize: 18),
            ).show();
                    });
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                       AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              title: "Error",
                              desc: "'No user found for that email", descTextStyle: TextStyle(fontSize: 18),
            ).show();
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                      AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              title: "Error",
                              desc: "Wrong password provided for that user", descTextStyle: TextStyle(fontSize: 18),
            ).show();
                    }
                  }
                 
                } else {
                  print("not valid");
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              height: 40,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: Colors.red,
              onPressed: () {
                signInWithGoogle();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Login with google "),
                  Image.asset(
                    "assets/m011t0447_b_social_sign_18sep22.jpg",
                    width: 30,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed("signup");
              },
              child: const Center(
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: "Don't have account ? "),
                  TextSpan(
                    text: "Register",
                    style: TextStyle(color: Colors.orange),
                  ),
                ])),
              ),
            ),

            const SizedBox(
              height: 10,
            ), // بيعمل تباعد بينهم
          ]),
        ));
  }
}

 
