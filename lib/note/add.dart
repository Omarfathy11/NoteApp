import 'dart:io';
import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login/note/view.dart';

import '../components/custombutton.dart';
import '../components/customtextformfield.dart';

class AddNote extends StatefulWidget {
  final String docid;
  const AddNote({super.key, required this.docid});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();
  File? file;
   String? url;

  bool isloading = false;

  addNote(context) async {
    CollectionReference collectionnote = FirebaseFirestore.instance
        .collection('categrois')
        .doc(widget.docid)
        .collection("note");

    if (formstate.currentState!.validate()) {
      try {
        isloading = true;
        setState(() {});
        DocumentReference response =
            await collectionnote.add({"note": note.text, "url": url ?? "none"});
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ViewNote(categoryid: widget.docid)));
      } catch (e) {
        isloading = false;
        setState(() {});
        print("Error $e");
      }
    }
  }
    
 Future<void> selectImageFromGallery()async{
  final ImagePicker picker = ImagePicker();

final XFile? imagecamera = await picker.pickImage(source: ImageSource.camera);
if (imagecamera != null){
file = File(imagecamera!.path);
  var imagename = basename(imagecamera!.path);
  var refstorage = FirebaseStorage.instance.ref("assets").child(imagename);
  await refstorage.putFile(file!);
  url = await refstorage.getDownloadURL();
}
setState(() {
  
});
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
          title: const Text("Add Category"),
        ),
        body: isloading
            ? Center(
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
                            CustomButtonUpload(title: "upload image", isselected: url == null ? false : true, onPressed: ()async{
                   await  selectImageFromGallery();

                  },),
                    CustomButton(
                      title: 'Add',
                      onPressed: () {
                        addNote(context);
                      },
                    )
                  ],
                ),
              ));
  }
}
