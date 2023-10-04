import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/ui/login.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../components/custombutton.dart';
import '../components/textformfield.dart';
import 'package:login/homepage.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<StatefulWidget> createState() {
    return SignupState();
  }
}

class SignupState extends State<Signup> {
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
    GlobalKey<FormState> formstate = GlobalKey<FormState>(); 

   
 @override
  void dispose() {
    email.dispose();
    password.dispose();
    username.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
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
                    "SigUp",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "SignUp to continue using the app",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
            
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("UserName",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    hinttext: 'Enter Your username',
                    myController: username,
                    validator:(val){
                        if(val == ""){
                          return "can't be empty";
                        }}
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
                    validator:(val){
                        if(val == ""){
                          return "can't be empty";
                        }}
                  ),
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
                    validator:(val){
                        if(val == ""){
                          return "can't be empty";
                        }}
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    alignment: Alignment.topRight,
                    child: const Text("Forgot  Password ? ",
                        textAlign: TextAlign.end,
                        style:
                            TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            CustomButton(
              title: "Signup",
              onPressed: () async {
                if (formstate.currentState!.validate()){
                try {
                  final credential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email.text,
                    password: password.text,
                  );
                  FirebaseAuth.instance.currentUser!.sendEmailVerification();
                  Navigator.of(context).pushReplacementNamed("login");
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                    AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              title: "Error",
                              desc:  "The password provided is too weak" , descTextStyle: TextStyle(fontSize: 18),
            ).show();
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                    AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              title: "Error",
                              desc:  "The account already exists for that email" , descTextStyle: TextStyle(fontSize: 18),
            ).show();
                  }
                } catch (e) {
                  print(e);
                }}
              },
            ),
            const SizedBox(
              height: 20,
            ),

            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed("login");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("have An Account ? "),
                  Text(
                    "Login",
                    style: TextStyle(color: Colors.orange),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ), // بيعمل تباعد بينهم
          ]),
        ));
  }
}
