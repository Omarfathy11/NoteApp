import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login/categrois/edit.dart';
import 'package:login/note/add.dart';
import 'package:login/note/edit.dart';
import 'package:login/ui/login.dart';

class ViewNote extends StatefulWidget {
  final String categoryid;
  const ViewNote({super.key, required this.categoryid});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  List<QueryDocumentSnapshot> data = [];
  bool isloading = true;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categrois")
        .doc(widget.categoryid)
        .collection("note")
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
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddNote(docid: widget.categoryid)));
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text("View page"),
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
        body: WillPopScope(
            child: isloading == true
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    itemCount: data.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, mainAxisExtent: 300),
                    itemBuilder: (context, i) {
                      return Container(
                        child: InkWell(
                          onLongPress: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              title: "Error",
                              desc: "Are you sure to delete ? ",
                              btnCancelOnPress: () async {},
                              btnOkOnPress: () async {
                                await FirebaseFirestore.instance
                                    .collection("categrois")
                                    .doc(widget.categoryid)
                                    .collection("note")
                                    .doc(data[i].id)
                                    .delete();
                                    if (data[i]["url"] != "none"){
                                      FirebaseStorage.instance.refFromURL( data[i]['url']).delete();
                                    }
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ViewNote(
                                        categoryid: widget.categoryid)));
                              },
                            ).show();
                          },
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditNote(
                                    notedocid: data[i].id,
                                    catogrydocid: widget.categoryid,
                                    value: data[i]["note"])));
                          },
                          child: Card(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Text(
                                    "${data[i]["note"]}",
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  if (data[i]["url"] != "none")
                                    Image.network(
                                      data[i]['url'],
                                      height: 130,
                                    )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            onWillPop: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("HomePage", (route) => false);
              return Future.value(false);
            }));
  }
}

