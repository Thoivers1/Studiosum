import 'package:flutter/material.dart';
import 'package:bachelor/components/appBar.dart';
import 'package:bachelor/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bachelor/constants.dart';
import 'package:bachelor/components/bottom_appBar.dart';

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
      appBar: appBar(text: 'Home Screen'),
      bottomNavigationBar: bottom_appBar(),
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

