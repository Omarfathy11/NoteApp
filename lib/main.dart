import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:login/categrois/add.dart';
import 'package:login/homepage.dart';

import 'package:login/ui/login.dart';
import 'package:login/ui/signup.dart';
import 'package:firebase_core/firebase_core.dart';

import 'filter.dart';
import 'note/view.dart';
import 'text.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("=======Background");
  print(message.notification!.title);
  print(message.notification!.body);
  print(message.data);
  print("=======Background");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("text click");
    });

    // بتجبلي مسج اذا اكن اليوزر عامل تسجيل دخول او خروج
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('===========User is currently signed out!');
      } else {
        print('==============User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
      theme: ThemeData(
          cardTheme: const CardTheme(color: Colors.white),
          appBarTheme: AppBarTheme(
              iconTheme: const IconThemeData.fallback(),
              backgroundColor: Colors.grey[200],
              titleTextStyle: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ))),
      debugShowCheckedModeBanner: false,
      title: "login app",
      home: FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified
          ? HomePage()
          : Login(), // if user have an accodunt navigator to homepage else login else
      routes: {
        "signup": (context) => Signup(),
        "login": (context) => Login(),
        "HomePage": (context) => HomePage(),
        "addcategory": (context) => AddCategory(),
        "FilterUsers": (context) => FilterUsers(),
      },
    ));
  }
}
