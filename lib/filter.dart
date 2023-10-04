import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class FilterUsers extends StatefulWidget {
  const FilterUsers({super.key});

  @override
  State<FilterUsers> createState() => _FilterUsersState();
}

class _FilterUsersState extends State<FilterUsers> {
   File? file;
   String? url;
 Future<void> selectImageFromGallery()async{
  final ImagePicker picker = ImagePicker();

final XFile? imagecamera = await picker.pickImage(source: ImageSource.camera);
if (imagecamera != null){
file = File(imagecamera!.path);
  var imagename = basename(imagecamera!.path);
  var refstorage = FirebaseStorage.instance.ref("assets/$imagename");
  await refstorage.putFile(file!);
  url = await refstorage.getDownloadURL();
}
setState(() {
  
});
 }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("imagepicker"),),
      body: Container(
        
        child: Column(children: [
          MaterialButton(onPressed: ()async{
            await selectImageFromGallery();          },
            child: const Text("get image camira"),),
            if (file != null) Image.network(url!, width: 100, height: 100,)
        ],) ,
      ),
    );
  }
 // final Stream<QuerySnapshot> usersstream =
   //   FirebaseFirestore.instance.collection('users').snapshots();

 // @override
 // void initState() {
  //  super.initState();
  //}

 
}
/*
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter"),
      ),
      body: Container(
              padding: EdgeInsets.all(10),
              child: StreamBuilder(
                  stream: usersstream,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("loading...");
                    }
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          return InkWell(
                            onTap: () {
                              DocumentReference documentReference = FirebaseFirestore
                                  .instance
                                  .collection("users")
                                  .doc(snapshot
                                      .data!.docs[index].id); // للتحديد ال الدوكيمنت
                              FirebaseFirestore.instance
                                  .runTransaction((transaction) async {
                                DocumentSnapshot snapshot =
                                    await transaction.get(documentReference);
                                if (snapshot.exists) {
                                  // يعني لو الدوكيمنت موجود
                                  var snapshotData = snapshot.data();
                                  if (snapshotData is Map<String, dynamic>) {
                                    int money = snapshotData["money"] + 100;
                                    transaction
                                        .update(documentReference, {"money": money});
                                  }
                                }
                              });
                            },
                            child: Card(
                              child: ListTile(
                                title: Text("${snapshot.data!.docs[index]["name"]}"),
                                subtitle:
                                    Text("${snapshot.data!.docs[index]["age"]}"),
                                trailing:
                                    Text("${snapshot.data!.docs[index]["money"]}\$"),
                              ),
                            ),
                          );
                        }));
                  }),
            ));
  }
  */

  // DocumentReference documentReference = FirebaseFirestore.instance.collection("users").doc(data[i].id); // للتحديد ال الدوكيمنت
     //       FirebaseFirestore.instance.runTransaction((transaction) async{
       //           DocumentSnapshot snapshot = await transaction.get(documentReference);
         ////         if (snapshot.exists){ // يعني لو الدوكيمنت موجود
             //         var snapshotData = snapshot.data();
               //       if (snapshotData is Map<String,  dynamic>) {
                 //           int money = snapshotData["money"] + 100;
                   //         transaction.update(documentReference, {"money" : money});
                     // }
                 // }
            // }).then((value){
             // Navigator.of(context).pushNamedAndRemoveUntil("FilterUsers", (route) => false);
            // });
/*
          floatingActionButton: FloatingActionButton(onPressed: (){
          CollectionReference users = FirebaseFirestore.instance.collection("users");
          DocumentReference doc1 = FirebaseFirestore.instance.collection("users").doc("1");
          DocumentReference doc2 = FirebaseFirestore.instance.collection("users").doc("2");

          WriteBatch batch = FirebaseFirestore.instance.batch();

          batch.set(doc1, {
            "name" : "fathy",
            "age" : 33,
            "money" : 400
          });
             batch.set(doc2, {
            "name" : "sameh",
            "age" : 22,
            "money" : 200,
          });

          batch.commit();
      }),    
      */