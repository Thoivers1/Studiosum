import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bachelor/components/appBar.dart';
import 'package:bachelor/components/bottom_appBar.dart';
import 'package:bachelor/constants.dart';
import 'package:bachelor/components/rounded_button.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {

  static const String id = 'searchScreen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  String? studieStedDoc;
  String? studieRetningDoc;
  String? semesterDoc;
  String? fagDoc;

  String? bookId;
  String? skoleId;
  String? retningId;
  String? semesterId;
  String? fagId;

  void changeStudiestedDoc(String newDoc) {
    setState(() {
      this.studieStedDoc = newDoc;
    });
  }
  void changeSkoleDoc(String newDoc) {
    setState(() {
      this.semesterDoc = newDoc;
    });
  }
  void changeStudieretningDoc(String newDoc) {
    setState(() {
      this.studieRetningDoc = newDoc;
    });
  }
  void changeSemesterDoc(String newDoc) {
    setState(() {
      this.semesterDoc = newDoc;
    });
  }
  void changeFagDoc(String newDoc) {
    setState(() {
      this.fagDoc = newDoc;
    });
  }

  void _onStudiestedDropItemSelected(String newValueSelected) {
    setState(() {
      this.bookId = newValueSelected;
    });
  }
  void _onSkoleDropItemSelected(String newValueSelected) {
    setState(() {
      this.skoleId = newValueSelected;
    });
  }
  void _onRetningDropItemSelected(String newValueSelected) {
    setState(() {
      this.retningId = newValueSelected;
    });
  }
  void _onSemesterDropItemSelected(String newValueSelected) {
    setState(() {
      this.semesterId = newValueSelected;
    });
  }
  void _onFagDropItemSelected(String newValueSelected) {
    setState(() {
      this.fagId = newValueSelected;
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
                                  // _onSkoleDropItemSelected('Høgskulen ved Vestlandet');
                                  changeStudiestedDoc((snapshot.data! as QuerySnapshot).docs[0].reference.id.toString());
                                }
                                break;
                                case 'Trondheim': {
                                  // _onSkoleDropItemSelected('NTNU');
                                  changeStudiestedDoc((snapshot.data! as QuerySnapshot).docs[1].reference.id.toString());
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
                                    changeStudieretningDoc(
                                        (snapshot.data! as QuerySnapshot).docs[0].reference.id.toString());
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
                                    changeSemesterDoc(
                                        (snapshot.data! as QuerySnapshot).docs[0].reference.id.toString());
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
                                    changeFagDoc(
                                        (snapshot.data! as QuerySnapshot).docs[0].reference.id.toString());
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
