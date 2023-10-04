import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:login/note/view.dart';

import '../components/custombutton.dart';
import '../components/customtextformfield.dart';

class EditNote extends StatefulWidget {
  final String notedocid;
  final String value;
  final String catogrydocid;
  const EditNote(
      {super.key,
      required this.notedocid,
      required this.catogrydocid,
      required this.value});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  bool isloading = false;

  editNote() async {
    CollectionReference collectionnote = FirebaseFirestore.instance
        .collection('categrois')
        .doc(widget.catogrydocid)
        .collection("note");

    if (formstate.currentState!.validate()) {
      try {
        isloading = true;
        setState(() {});
        await collectionnote.doc(widget.notedocid).update({
          "note": note.text,
        });
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ViewNote(categoryid: widget.catogrydocid)));
      } catch (e) {
        isloading = false;
        setState(() {});
        print("Error $e");
      }
    }
  }

  void initState() {
    super.initState();
    note.text = widget.value;
  }

  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit"),
        ),
        body: isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: formstate,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                    ),
                    CustomTextFormFieldAdd(
                        hinttext: 'Enter name',
                        myController: note,
                        validator: (val) {
                          if (val == "") {
                            return "can't be embty";
                          }
                        }),
                    CustomButton(
                      title: 'Save',
                      onPressed: () {
                        editNote();
                      },
                    )
                  ],
                ),
              ));
  }
}
