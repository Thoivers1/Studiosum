import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bachelor/components/appBar.dart';
import 'package:bachelor/components/bottom_appBar.dart';
import 'package:bachelor/constants.dart';
import 'package:bachelor/components/rounded_button.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CreateScreen extends StatefulWidget {

  static const String id = 'create_screen';

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {

  String studieStedDoc = 'cHCdFIAwoJjxYr6BqcWX';
  String studieRetningDoc = 'OmB0JvM4mDZxlvwcoqZn';

  String? bookId;
  String? skoleId;
  String? retningId;

  void changeStudiestedDoc(String newDoc) {
    setState(() {
      this.studieStedDoc = newDoc;
    });
  }
  void changeStudieretningDoc(String newDoc) {
    setState(() {
      this.studieRetningDoc = newDoc;
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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(text:'studiosum', height: 120.0),
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

              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Tittel'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {

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
                onPressed: (){},
                icon: Icon(Icons.camera_alt),
                label: Text('Last opp bilde'),
              ),
            ),
          ),

          //DropdownButtons
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              decoration: kTextFieldDecoration.copyWith(hintText: 'Velg semester'),
              items: <String> ['A', 'B', 'C'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_){},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              decoration: kTextFieldDecoration.copyWith(hintText: 'Velg fag'),
              items: <String> ['A', 'B', 'C'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_){},
            ),
          ),

          //SearchButton
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 150.0, right: 150.0),
            child: RoundedButton(
                widgetText: Text('Opprett', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                color: kColor,
                onPressed: (){},
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
