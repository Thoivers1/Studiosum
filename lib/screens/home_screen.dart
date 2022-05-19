import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bachelor/components/appBar.dart';
import 'package:bachelor/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bachelor/constants.dart';
import 'package:bachelor/components/bottom_appBar.dart';
import 'package:bachelor/screens/create_screen.dart';
import 'package:flutter/services.dart';
import 'package:bachelor/screens/ad_screen.dart';

late  User loggedInUser;

class HomeScreen extends StatefulWidget {

  static const String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _auth = FirebaseAuth.instance;
  String? isbnVal;
  List<Object?> ads = [];
  int annonseId = 0;


  @override
  void initState() {
    super.initState();

    getCurrentUser().whenComplete((){
      setState(() {
        getCurrentUser();
        getAds();
      });
    });
  }

  getCurrentUser() async{
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e){
      print(e);
    }
  }

  getAds() async{
    await FirebaseFirestore.instance
        .collectionGroup('Annonse')
        .where('Bruker', isEqualTo: loggedInUser.email)
        .get()
        .then((QuerySnapshot snapshot){
          snapshot.docs.forEach((DocumentSnapshot doc){
            setState(() {
              this.ads.add(doc.data());
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(
        logoSize: 50.0,
        backArrow: false,
        textWidget:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              width: 300,
              child: TextField(
                textAlign: TextAlign.center,
                inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[<\>\&\%\!]')),],
                onChanged: (value) {
                  isbnVal = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Søk etter bok eller ISBN'),
              ),
            ),
            SizedBox(width: 10.0,),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20.0),
                child: MaterialButton(
                  onPressed: () async {
                    //ISBN forstå programmering med java - 9788215031286
                        await FirebaseFirestore.instance.collectionGroup('Books')
                        .where('ISBN', isEqualTo: isbnVal).get()
                            .then((QuerySnapshot snapshot){
                              snapshot.docs.forEach((DocumentSnapshot doc){
                                print(doc.data());
                          });
                        }) ;
                  },
                  minWidth: 50.0,
                  height: 50.0,
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        height: 200.0,),

      bottomNavigationBar: bottomAppBar(),
      body: Padding(
        padding: EdgeInsets.only(left: 60.0, right: 60.0, top: 30.0, bottom: 30.0),
        child: ListView(
          children: <Widget>[
            RoundedButton(
              color: kColor,
              height: 42.0,
              width: 100.0,
              widgetText: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  Icon(Icons.add_circle, color: Colors.white,),
                  SizedBox(width: 10.0,),
                  Text('Opprett ny annonse', style: TextStyle(color: Colors.white)),
                ],
              ),
              onPressed: () async{
                Navigator.pushNamed(context, CreateScreen.id);

                /*


               await FirebaseFirestore.instance.collection('Books').doc('cHCdFIAwoJjxYr6BqcWX').collection('Skole').doc('OmB0JvM4mDZxlvwcoqZn').collection('Studieretning').doc('3UWQwmKyX6hIAelNMeen').collection('Semester').doc('CYkjdjlQZjWnAXSX0pyf')
                   .collection('Fag').doc('XlwdtJ53hmPUF5yJX8E5').collection('Annonse').doc('a2c0db70-cec5-11ec-964b-6994aade6d22').delete();
               print('done');

                 */
              },
            ),

            SizedBox(height: 25.0),
            Center(child: Text(
              'Mine aktive annonser',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )),

            for(var annonse in ads)
              GestureDetector(
              onTap: (){
                for(int i = 0; i <= ads.length; i++){
                  if(ads[i].toString().substring(annonse.toString().indexOf('Tittel:') + 7, annonse.toString().indexOf('Pris:')-2) ==  annonse.toString().substring(annonse.toString().indexOf('Tittel:') + 7, annonse.toString().indexOf('Pris:')-2)){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            AdScreen(
                              ads: ads[i],
                            )
                    ));
                  }
                }
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
                            child: Row(
                              children: [
                                Text(
                                  //Tittel
                                  annonse.toString().substring(annonse.toString().indexOf('Tittel:') + 7, annonse.toString().indexOf('Pris:')-2),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
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
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.lightBlue,
                                ),
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      //Selger
                                      annonse.toString().substring(annonse.toString().indexOf('Bruker:') + 7, annonse.toString().indexOf('}')),
                                      style: TextStyle(
                                        color: Colors.lightBlue,
                                      ),
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

