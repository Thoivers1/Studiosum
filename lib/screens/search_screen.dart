import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bachelor/components/appBar.dart';
import 'package:bachelor/components/bottom_appBar.dart';
import 'package:bachelor/constants.dart';
import 'package:bachelor/components/rounded_button.dart';
import 'package:bachelor/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bachelor/screens/search_result_screen.dart';
import 'create_screen.dart';

class SearchScreen extends StatefulWidget {

  static const String id = 'searchScreen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

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
          bookId = newValueSelected;
        }break;
        case 'skole': {
          skoleId = newValueSelected;
        }break;
        case 'retning': {
          retningId = newValueSelected;
        }break;
        case 'semester': {
          semesterId = newValueSelected;
        }break;
        case 'fag': {
          fagId = newValueSelected;
        }
      }
    });
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
                                  setState(() {
                                    skoleId = null;
                                    retningId = null;
                                    semesterId = null;
                                    fagId = null;
                                  });
                                }
                                break;
                                case 'Trondheim': {
                                  changeDoc((snapshot.data! as QuerySnapshot).docs[1].reference.id.toString(), 'studie');
                                  setState(() {
                                    skoleId = null;
                                    retningId = null;
                                    semesterId = null;
                                    fagId = null;
                                  });
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
                                    changeDoc((snapshot.data! as QuerySnapshot).docs[0].reference.id.toString(), 'studieRetning');
                                    setState(() {
                                      retningId = null;
                                      semesterId = null;
                                      fagId = null;
                                    });
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
                                    setState(() {
                                      semesterId = null;
                                      fagId = null;
                                    });
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
                                        (snapshot.data! as QuerySnapshot).docs[2].reference.id.toString(), 'fag');
                                    setState(() {
                                      fagId = null;
                                    });
                                  }
                                  break;
                                case '2. Semester':
                                  {
                                    changeDoc(
                                        (snapshot.data! as QuerySnapshot).docs[1].reference.id.toString(), 'fag');
                                    setState(() {
                                      fagId = null;
                                    });
                                  }
                                  break;
                                case '3. Semester':
                                  {
                                    changeDoc(
                                        (snapshot.data! as QuerySnapshot).docs[0].reference.id.toString(), 'fag');
                                    setState(() {
                                      fagId = null;
                                    });
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
                      widgetText: Text('Søk', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                      color: kColor,
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SearchResultScreen(skoleDoc: studieStedDoc, retningDoc: studieRetningDoc, semesterDoc: semesterDoc, fagDoc: fagDoc, annonseDoc: annonseDoc)
                        ));
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
