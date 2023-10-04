import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../components/custombutton.dart';
import '../components/customtextformfield.dart';

class AddCategory extends StatefulWidget {
  
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  bool isloading = false;

  CollectionReference categrois =
      FirebaseFirestore.instance.collection('categrois');


  addCategory(context) async {
    if (formstate.currentState!.validate()) {
      try {
        isloading = true;
        setState(() {
          
        });
        DocumentReference response = await categrois.add({
          "name": name.text, "id" : FirebaseAuth.instance.currentUser!.uid
        });
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
                title: 'Add',
                onPressed: () {
                  addCategory(context);
                },
              )
            ],
          ),
        ));
  }
}
