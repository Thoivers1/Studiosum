import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bachelor/components/appBar.dart';
import 'package:bachelor/components/bottom_appBar.dart';
import 'package:bachelor/constants.dart';
import 'package:bachelor/components/rounded_button.dart';
import 'package:bachelor/storage_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:uuid/uuid.dart';

late  User loggedInUser;

class CreateScreen extends StatefulWidget {

  static const String id = 'create_screen';

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {

  late String tittel;
  late String beskrivelse;
  late String pris;
  bool isPressed = false;

  String? studieStedDoc;
  String? studieRetningDoc;
  String? semesterDoc;
  String? fagDoc;
  String? annonseDoc;

  String? bookId;
  String? skoleId;
  String? retningId;
  String? semesterId;
  String? fagId;

  final _auth = FirebaseAuth.instance;
  final Storage storage = Storage();

  @override
  void initState() {
    getCurrentUser();
    isPressed = false;
  }
  void getCurrentUser() async{
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e){
      print(e);
    }
  }

  void changeDoc(String newDoc, String id) {
    setState(() {
      switch(id){
        case 'studie': {
          this.studieStedDoc = newDoc;
        } break;
        case 'studieRetning': {
          this.studieRetningDoc = newDoc;
        }break;
        case 'semester': {
          this.semesterDoc = newDoc;
        } break;
        case 'fag': {
          this.fagDoc = newDoc;
        }break;
        case 'annonse': {
          this.annonseDoc = newDoc;
        }break;
      }
    });
  }

  void changeDropItemSelected(String? newValueSelected, String id){
    setState(() {
      switch(id){
        case 'book': {
          this.bookId = newValueSelected;
        }break;
        case 'skole': {
          this.skoleId = newValueSelected;
        }break;
        case 'retning': {
          this.retningId = newValueSelected;
        }break;
        case 'semester': {
          this.semesterId = newValueSelected;
        }break;
        case 'fag': {
          this.fagId = newValueSelected;
        }
      }
    });
  }

  Future addToFirebase ({required String tittel, required String beskrivelse, required String pris}) async {
    const uuid = Uuid();
    String id = uuid.v1();
    final docUser = FirebaseFirestore.instance.collection('Books')
        .doc(studieStedDoc)
        .collection('Skole')
        .doc(studieRetningDoc)
        .collection('Studieretning')
        .doc(semesterDoc)
        .collection('Semester')
        .doc(fagDoc)
        .collection('Fag')
        .doc(annonseDoc)
        .collection('Annonse')
        .doc(id);

    final data = {
      'Tittel': tittel,
      'Beskrivelse': beskrivelse,
      'Pris' : pris,
      'Bruker': loggedInUser.email,
    };

    await docUser.set(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(textWidget:Text('studiosum'), height: 120.0, backArrow: false, logoSize: 40.0,),
      bottomNavigationBar: bottomAppBar(),
      body: Column(
        children: <Widget>[
      Expanded(
      child: ListView(
        children: <Widget>[
          SizedBox(height: 50.0,),
          //Text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Fyll inn informasjonen under:', style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold
            ),),
          ),

          //Textfields
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                setState(() {
                  this.tittel = value;
                });
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Tittel'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                setState(() {
                  this.beskrivelse = value;
                });
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Beskrivelse'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 100.0,
                child: TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    setState(() {
                      this.pris = value;
                    });
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Pris'),
                ),
              ),
            ),
          ),

          //imageButton
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  primary: Colors.black,
                  elevation: 5.0,
                ),
                onPressed: () async{
                  final result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: ['png', 'jpg'],
                  );

                  if(result == null){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No File Selected'),),);
                    return;
                  }

                  final path = result.files.single.path!;
                  final fileName = result.files.single.name;

                  storage.uploadFile(path, fileName).then((value) => print('Done'));

                  setState(() {
                    isPressed = true;
                  });

                  /*
                  FutureBuilder(
                    future: storage.downloadURL('madelyn.jpg'),
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                        return Container(
                          width: 300,
                          height: 250,
                          child: Image.network(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          ));
                      }
                      if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData){
                        return CircularProgressIndicator();
                      }
                      return Container();
                    }); */
                },

                icon: (!isPressed) ? Icon(Icons.camera_alt) : Icon(Icons.check),
                label: (!isPressed) ? Text('Last opp bilde') : Text('Bilde lastet opp!'),
              ),
            ),
          ),

          //DropdownButtons
          //BY
          Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Books').snapshots(),
              builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CupertinoActivityIndicator(),
              );

            return Container(
              child: DropdownButtonFormField(
                decoration: kTextFieldDecoration.copyWith(hintText: ''),
                value: bookId,
                isDense: true,
                onChanged: (String? valueSelectedByUser) {
                  setState(() {
                    bookId = valueSelectedByUser ?? "";
                  });
                  switch (valueSelectedByUser){
                    case 'Bergen': {
                      changeDoc((snapshot.data! as QuerySnapshot).docs[0].reference.id.toString(), 'studie');
                    }
                    break;
                    case 'Trondheim': {
                      changeDoc((snapshot.data! as QuerySnapshot).docs[1].reference.id.toString(), 'studie');
                    }
                  }
                },
                hint: Text('Velg studiested'),
                items: (snapshot.data!).docs
                    .map((DocumentSnapshot document) {
                  return DropdownMenuItem<String>(
                    value: document['Studiested'],
                    child: Text(document['Studiested']),
                  );
                }).toList(),
              ),
            );
          }),
        ),
          //SKOLE
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Books')
                    .doc(studieStedDoc)
                    .collection('Skole')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );

                  return Container(
                    child: DropdownButtonFormField(
                      decoration: kTextFieldDecoration.copyWith(hintText: ''),
                      value: skoleId,
                      isDense: true,
                      onChanged: (String? valueSelectedByUser) {
                        setState(() {
                          skoleId = valueSelectedByUser ?? "";
                        });
                          switch (valueSelectedByUser){
                            case 'Høgskulen ved Vestlandet':
                              {
                                changeDoc(
                                    (snapshot.data! as QuerySnapshot).docs[0].reference.id.toString(), 'studieRetning');
                              }
                              break;
                          }
                      },
                      hint: Text('Velg Skole'),
                      items: (snapshot.data!).docs
                          .map((DocumentSnapshot document) {
                        return DropdownMenuItem<String>(
                          value: document['Skole'],
                          child: Text(document['Skole']),
                        );
                      }).toList(),
                    ),
                  );
                }),
          ),
          //STUDIERETNING
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Books')
                    .doc(studieStedDoc)
                    .collection('Skole')
                    .doc(studieRetningDoc)
                    .collection('Studieretning')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );

                  return Container(
                    child: DropdownButtonFormField(
                      decoration: kTextFieldDecoration.copyWith(hintText: ''),
                      value: retningId,
                      isDense: true,
                      onChanged: (String? valueSelectedByUser) {
                        setState(() {
                          retningId = valueSelectedByUser ?? "";
                        });
                        switch (valueSelectedByUser){
                          case 'Dataingeniør':
                            {
                              changeDoc(
                                  (snapshot.data! as QuerySnapshot).docs[0].reference.id.toString(), 'semester');
                            }
                            break;
                        }
                      },
                      hint: Text('Velg Studieretning'),
                      items: (snapshot.data!).docs
                          .map((DocumentSnapshot document) {
                        return DropdownMenuItem<String>(
                          value: document['Studieretning'],
                          child: Text(document['Studieretning']),
                        );
                      }).toList(),
                    ),
                  );
                }),
          ),
          //SEMESTER
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Books')
                    .doc(studieStedDoc)
                    .collection('Skole')
                    .doc(studieRetningDoc)
                    .collection('Studieretning')
                    .doc(semesterDoc)
                    .collection('Semester')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );

                  return Container(
                    child: DropdownButtonFormField(
                      decoration: kTextFieldDecoration.copyWith(hintText: ''),
                      value: semesterId,
                      isDense: true,
                      onChanged: (String? valueSelectedByUser) {
                        setState(() {
                          semesterId = valueSelectedByUser ?? "";
                        });
                        switch (valueSelectedByUser){
                          case '1. Semester':
                            {
                              changeDoc(
                                  (snapshot.data! as QuerySnapshot).docs[0].reference.id.toString(), 'fag');
                            }
                            break;
                        }
                      },
                      hint: Text('Velg Semester'),
                      items: (snapshot.data!).docs
                          .map((DocumentSnapshot document) {
                        return DropdownMenuItem<String>(
                          value: document['Semester'],
                          child: Text(document['Semester']),
                        );
                      }).toList(),
                    ),
                  );
                }),
          ),
          //FAG
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Books')
                    .doc(studieStedDoc)
                    .collection('Skole')
                    .doc(studieRetningDoc)
                    .collection('Studieretning')
                    .doc(semesterDoc)
                    .collection('Semester')
                    .doc(fagDoc)
                    .collection('Fag')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );

                  return Container(
                    child: DropdownButtonFormField(
                      decoration: kTextFieldDecoration.copyWith(hintText: ''),
                      value: fagId,
                      isDense: true,
                      onChanged: (String? valueSelectedByUser) {
                        setState(() {
                          fagId = valueSelectedByUser ?? "";
                        });
                        switch (valueSelectedByUser){
                          case 'Dat100 - Grunnleggende programmering':
                            {
                              changeDoc(
                                  (snapshot.data! as QuerySnapshot).docs[0].reference.id.toString(), 'annonse');
                            }
                            break;
                        }
                      },
                      hint: Text('Velg Fag'),
                      items: (snapshot.data!).docs
                          .map((DocumentSnapshot document) {
                        return DropdownMenuItem<String>(
                          value: document['Fag'],
                          child: Text(document['Fag']),
                        );
                      }).toList(),
                    ),
                  );
                }),
          ),

          //SearchButton
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 150.0, right: 150.0),
            child: RoundedButton(
                widgetText: Text('Opprett', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                color: kColor,
                onPressed: (){

                  addToFirebase(tittel: tittel, beskrivelse: beskrivelse, pris: pris);
                  Navigator.pop(context);
                },
                width: 100.0,
                height: 42.0
            ),
          ),
        ],
      ),
      ),
        ],
      ),
    );
  }
}
