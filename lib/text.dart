import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:login/homepage.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {

  getToken()async{
   String? mytoken =  await FirebaseMessaging.instance.getToken();
   print("============");
   print(mytoken);

  }

  myrequrestpermission()async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

NotificationSettings settings = await messaging.requestPermission(
  alert: true,
  announcement: false,
  badge: true,
  carPlay: false,
  criticalAlert: false,
  provisional: false,
  sound: true,
);

if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  print('User granted permission');
} else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  print('User granted provisional permission');
} else {
  print('User declined or has not accepted permission');
}
  }
  @override
  void initState() {
     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data["type"] == "chat"){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomePage()));
      }
      });
       FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      if(message.notification != null){
        print("==================");
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data);
        print("=================");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${message.notification!.body}")));
      }
      
    });
    myrequrestpermission();
    getToken();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications"),),
      body: Container(
        child: MaterialButton(onPressed: (){
          sendMessage("hi", "omar");
        },child: const Text("send message"),),
      ),
    );
  }
}

sendMessage(title, message)async{
 var headersList = {
 'Accept': '*/*',
 'Content-Type': 'application/json',
 'Authorization': 'key=AAAASjG0dZc:APA91bE_KAS0ivgqPe5YhJ_R2SIpyMt-V5lh16tW62iilAXuhW-WWiFbWTRNUARLYAMwTDhdjY3RA8ymTRScoygVpnd1OKMWsh-XCcZlRiS8CJzLAskk7sqTLI3JKunvo0RygeML1Hb8' 
};
var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

var body = {
  "to": "fYy4j1OtQgSfnR-kHsV6vu:APA91bFLgI_NCANaV5CUyPjCErXUjO7p6HisFklrbZg_--QhPNC5g6q50kJD_NtRZ8bOG27aELquNYanHd71q4vbUrO6DsUTtDet1HfY1BjtrrTW4tnBJIPoX4CI7FoKAG3Qu2Zt4jiE",
  "notification": {
    "title": title,
    "body": message,
  },
   "data":{
    "id": "12",
    "name" : "ali",
   }
};


var req = http.Request('POST', url);
req.headers.addAll(headersList);
req.body = json.encode(body);


var res = await req.send();
final resBody = await res.stream.bytesToString();

if (res.statusCode >= 200 && res.statusCode < 300) {
  print(resBody);
}
else {
  print(res.reasonPhrase);
}
}