import 'package:flutter/material.dart';
import 'package:bachelor/components/appBar.dart';
import 'package:bachelor/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bachelor/constants.dart';
import 'package:bachelor/components/bottom_appBar.dart';
import 'package:bachelor/screens/create_screen.dart';

late User loggedInUser;

class HomeScreen extends StatefulWidget {

  static const String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
                onChanged: (value) {

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
                  onPressed: (){

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
              onPressed: (){
                Navigator.pushNamed(context, CreateScreen.id);
              },
            ),

            SizedBox(height: 25.0),
            Center(child: Text(
              'Mine aktive annonser',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )),
          ],
        ),
      ),
    );
  }
}

