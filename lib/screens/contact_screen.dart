import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bachelor/components/bottom_appBar.dart';
import 'package:bachelor/components/rounded_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

late User loggedInUser;

class ContactScreen extends StatefulWidget {

  static const String id = 'contact_screen';

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {

  final _auth = FirebaseAuth.instance;
  String? username = '';
  List<Object?> users = [];

  @override
  void initState() {

    setState(() {
      getCurrentUser();
      getUsername();
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

  getUsername() async{
    await FirebaseFirestore.instance
        .collectionGroup('Users')
        .where('Email', isEqualTo: loggedInUser.email)
        .get()
        .then((QuerySnapshot snapshot){
      snapshot.docs.forEach((DocumentSnapshot doc){
        print(doc.data());
        setState(() {
          this.users.add(doc.data());
          username = users.toString().substring(users.toString().indexOf('FirstName:') + 10, users.toString().indexOf('LastName') - 2);
          print(username);
        });
      });
    });
  }

  void _contact() async {
    //final url = 'thoive99@gmail.com';
    final Uri url = Uri(
        scheme: 'mailto',
        path: 'thoive99@gmail.com');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: kColor,
      ),
      bottomNavigationBar: bottomAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 25.0,),
            Image(
              image: AssetImage('images/profile.png'),
              height: 100.0,
              width: 100.0,
            ),
            Center(
              child: Text(username!, style: TextStyle(
                fontSize: 25.0,
              ),),
            ),
            SizedBox(height: 100.0,),
            Center(
              child: Text('Om du har noen spørsmål eller problemer med Studiosum, send en epost til oss så får du hjelp så snart som mulig!', style: TextStyle(
                  fontSize: 20.0, fontWeight: FontWeight.bold
              ),),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 100.0, right: 100.0),
              child: RoundedButton(
                  widgetText: Text('Send epost', style: TextStyle(color: Colors.white),),
                  color: Colors.lightBlue,
                  onPressed: (){
                    _contact();
                    },
                  width: 50.0,
                  height: 20.0
              ),
            ),
          ],
        ),
      ),
    );
  }
}

