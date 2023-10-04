import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login/categrois/edit.dart';
import 'package:login/ui/login.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'note/view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<QueryDocumentSnapshot> data = [];
  bool isloading = true;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categrois")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    isloading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed("addcategory");
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text("HomePage"),
          actions: [
            IconButton(
                onPressed: () async {
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  googleSignIn.disconnect();
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamed("login");
                },
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ))
          ],
        ),
        body: isloading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: 200),
                itemBuilder: (context, i) {
                  return Container(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ViewNote(categoryid: data[i].id)));
                      },
                      onLongPress: () {
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.rightSlide,
                            title: "Error",
                            desc: "Choose what you want ?",
                            descTextStyle: TextStyle(fontSize: 18),
                            btnCancelText: "delete",
                            btnOkText: "modification",
                            btnCancelOnPress: () {
                              FirebaseFirestore.instance
                                  .collection("categrois")
                                  .doc(data[i].id)
                                  .delete();
                              Navigator.of(context).pushNamed("HomePage");
                            },
                            btnOkOnPress: () async {
                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => EditCategory(
                                          docid: data[i].id,
                                          oldname: data[i]["name"])));
                              ;
                            }).show();
                      },
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  "assets/download-icon-folder-24.jpg",
                                  height: 130,
                                ),
                              ),
                              Text(
                                "${data[i]["name"]}",
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ));
  }
}
