import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference ref =
      FirebaseFirestore.instance.collection("augersoft");
  TextEditingController namecont = new TextEditingController();
  TextEditingController descont = new TextEditingController();

  late String docId;
  late String name, sub;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD Operations"),
      ),
      body: StreamBuilder(
          stream: ref.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return !snapshot.hasData
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot docRef = snapshot.data!.docs[index];

                      return Column(children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                                snapshot.data!.docs[index]['name']
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: TextStyle(color: Colors.white)),
                          ),
                          title: Text(
                            snapshot.data!.docs[index]['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle:
                              Text(snapshot.data!.docs[index]['subtitle']),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  name = snapshot.data!.docs[index]['name'];
                                  sub = snapshot.data!.docs[index]['subtitle'];

                                  docId = docRef.id;
                                  _fetch(docId);
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                )),
                            IconButton(
                              onPressed: () {
                                docId = docRef.id;
                                print(docId);
                                _delete(docId);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.blue,
                              ),
                            )
                          ],
                        ),
                      ]);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      endIndent: 20.0,
                      height: 20.0,
                      indent: 20.0,
                      color: Colors.blue,
                    ),
                  );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          docId = "";
          _fetch(docId);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _fetch(String docId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (docId == "") {
            namecont.text = "";
            descont.text = "";
          } else {
            namecont.text = name;
            descont.text = sub;
          }

          return SimpleDialog(
            title: Text("Enter Information"),
            children: [
              SimpleDialogOption(
                child: TextField(
                  controller: namecont,
                  decoration: InputDecoration(
                    labelText: "UserName",
                    hintText: "Enter Name",
                  ),
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
                      docId == "" ? _addData() : _updateData(docId);

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

  Future<void> _delete(String docId) async {
    await ref.doc(docId).delete();
  }

  Future<void> _addData() async {
    await ref.add({
      'name': namecont.text,
      'subtitle': descont.text,
    });
  }

  Future<void> _updateData(String docId) async {
    await ref.doc(docId).set({
      'name': namecont.text,
      'subtitle': descont.text,
    });
  }
}
