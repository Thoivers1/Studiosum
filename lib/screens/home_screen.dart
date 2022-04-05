import 'package:flutter/material.dart';
import 'package:bachelor/components/appBar.dart';
import 'package:bachelor/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bachelor/constants.dart';

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
      body: Column(
        children: <Widget>[
          Text('Welcome to ivers kosehule'),
          Spacer(),
          Center(
            child: RoundedButton(
              title: 'Log out',
              color: kColor,
              onPressed: (){
                _auth.signOut();
                Navigator.pop(context);
              }
            ),
          ),
        ],
      ),
    );
  }
}
