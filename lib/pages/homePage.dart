import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference ref =
      FirebaseFirestore.instance.collection("augersoft");

  TextEditingController namecont = new TextEditingController();
  TextEditingController descont = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD Operations"),
        centerTitle: true,
      ),

      body: ,

     





      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _fetch();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _fetch() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Enter Information"),
            children: [
              SimpleDialogOption(
                child: TextField(
                  controller: namecont,
                  decoration: InputDecoration(
                      labelText: "UserName", hintText: "Enter Name"),
                ),
              ),
              SimpleDialogOption(
                child: TextField(
                  controller: descont,
                  decoration: InputDecoration(
                      labelText: "Subtitle", hintText: "Enter Subtitle"),
                ),
              ),
              SimpleDialogOption(
                child: ElevatedButton(
                    onPressed: () {
                      ref.add({
                        'name': namecont.text,
                        'subtitile': descont.text,
                      });

                      namecont.clear();
                      descont.clear();
                      Navigator.pop(context);
                    },
                    child: Text("Enter")),
              )
            ],
          );
        });
  }
}
