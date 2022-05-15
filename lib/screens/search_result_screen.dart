import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/appBar.dart';
import '../components/bottom_appBar.dart';
import 'package:bachelor/screens/search_screen.dart';
import 'create_screen.dart';

final bookRef = FirebaseFirestore.instance.collection('Books');

class SearchResultScreen extends StatefulWidget {

  static const String id = 'search_result_screen';

  final String? skoleDoc;
  final String? retningDoc;
  final String? semesterDoc;
  final String? fagDoc;
  final String? annonseDoc;

  const SearchResultScreen({
    Key? key,
    this.skoleDoc,
    this.retningDoc,
    this.semesterDoc,
    this.fagDoc,
    this.annonseDoc,
}) : super (key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

final _auth = FirebaseAuth.instance;

@override
void initState() {
  getCurrentUser();
}
void getCurrentUser() async{
  try {
    final user = await _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      print(loggedInUser.email);
    }
  } catch (e){
    print(e);
  }
}

class _SearchResultScreenState extends State<SearchResultScreen> {

  late int antallAnnonser;
  List<Object?> annonser = [];

  @override
  void initState(){
    getAnnonse();
  }

  getAnnonse() async{
      await FirebaseFirestore.instance.collection('Books')
          .doc(widget.skoleDoc)
          .collection('Skole')
          .doc(widget.retningDoc)
          .collection('Studieretning')
          .doc(widget.semesterDoc)
          .collection('Semester')
          .doc(widget.fagDoc)
          .collection('Fag')
          .doc(widget.annonseDoc)
          .collection('Annonse')
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((DocumentSnapshot doc) {
          //print(doc.data());
          setState(() {
            this.annonser.add(doc.data());
          });
        });
      });
  }

  /*
  getBooks(){
    bookRef.get().then((QuerySnapshot snapshot){
      snapshot.docs.forEach((DocumentSnapshot doc){
        print(doc.data());
      });
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(
        logoSize: 40.0,
        backArrow: false,
        textWidget: Text('Studiosum'),
        height: 120.0,),

      bottomNavigationBar: bottomAppBar(),
      body: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0, bottom: 30.0),
        child: ListView(
          children: <Widget>[
            Center(
              child: Text('Ditt søk fant (${annonser.length}) bøker til salgs:', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
              ),),
            ),
            for(var annonse in annonser) GestureDetector(
              onTap: (){
                print('test');
              },
              child: Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(10.0),
                width: double.infinity,
                height: 150.0,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(right: 5.0),
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Image(
                        image: AssetImage('images/book.png'),
                      )
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              //Tittel
                              annonse.toString().substring(annonse.toString().indexOf('Tittel:') + 7, annonse.toString().indexOf('Pris:')-2),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            //Pris
                            annonse.toString().substring(annonse.toString().indexOf('Pris:') + 6, annonse.toString().indexOf('Bruker')-2 ) + ' kr',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                              color: Colors.red,
                            ),
                          ),
                          Spacer(),
                          Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.lightBlue,
                                ),
                                FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    //Selger
                                    annonse.toString().substring(annonse.toString().indexOf('Bruker:') + 7, annonse.toString().indexOf('}')),
                                    style: TextStyle(
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
