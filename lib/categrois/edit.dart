import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../components/custombutton.dart';
import '../components/customtextformfield.dart';

class EditCategory extends StatefulWidget {
  final String docid;
  final String oldname;
  const EditCategory({super.key, required this.docid, required this.oldname});

  @override
  State<EditCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  bool isloading = false;

  CollectionReference categrois =
      FirebaseFirestore.instance.collection('categrois');



  editCategory() async {
    if (formstate.currentState!.validate()) {
      try {
        isloading = true;
        setState(() {
          
        });
         await categrois.doc(widget.docid).set({
          "name" : name.text
         }, SetOptions(merge: true)); // set = update and addwith id // merge is use to undelete any add
        Navigator.of(context).pushNamedAndRemoveUntil("HomePage", (route) => false);
      } catch (e) {
        isloading = false;
        setState(() {
          
        });
        print("Error $e");
      }
    }
  }
   @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  void initState() { // to show oldname
    name.text = widget.oldname; 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Category"),
        ),
        body: isloading ? Center(child: CircularProgressIndicator(),) : Form(
          key: formstate,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
              ),
              CustomTextFormFieldAdd(
                  hinttext: 'Enter name',
                  myController: name,
                  validator: (val) {
                    if (val == "") {
                      return "can't be embty";
                    }
                  }),
              CustomButton(
                title: 'save',
                onPressed: () {
                  editCategory();
                },
              )
            ],
          ),
        ));
  }
}
