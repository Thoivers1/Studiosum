
import 'package:bachelor/screens/profile_settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bachelor/components/profileButton.dart';
import 'package:bachelor/components/bottom_appBar.dart';
import 'package:bachelor/screens/home_screen.dart';

import '../constants.dart';

late User loggedInUser;

class ProfileScreen extends StatefulWidget {

  static const String id = 'profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  String? username = '';
  List<Object?> users = [];

  @override
  void initState(){

      setState(() {
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
    await getCurrentUser();
    await FirebaseFirestore.instance
        .collectionGroup('Users')
        .where('Email', isEqualTo: loggedInUser.email)
        .get()
        .then((QuerySnapshot snapshot){
      snapshot.docs.forEach((DocumentSnapshot doc){
        setState(() {
          this.users.add(doc.data());
          username = users.toString().substring(users.toString().indexOf('FirstName:') + 10, users.toString().indexOf('LastName') - 2);
        });
      });
    });
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
        child: ListView(
          children: <Widget>[
            Image(
              image: AssetImage('images/profile.png'),
              height: 100.0,
              width: 100.0,
              ),
            Center(
              //child: Text(users.toString().substring(users.toString().indexOf('FirstName:') + 10, users.toString().indexOf('LastName') - 2), style: TextStyle(
              //                 fontSize: 25.0,
              child: Text(username!, style: TextStyle(
                fontSize: 25.0,
              ),),
            ),
            SizedBox(height: 50.0,),
            profileButton(
              icon: Icons.handshake,
              text: 'Mine kjøp',
              onTap: (){},
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Divider(color: Colors.black54,),
            ),
            profileButton(
                icon: Icons.handshake,
                text: 'Mine salg',
                onTap: (){},
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Divider(color: Colors.black54,),
            ),
            profileButton(
                icon: Icons.thumb_up,
                text: 'Mine vurderinger',
                onTap: (){}
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Divider(color: Colors.black54,),
            ),
            profileButton(
                icon: Icons.settings,
                text: 'Innstillinger',
                onTap: (){
                  Navigator.pushNamed(context, ProfileSettingsScreen.id);
                }
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Divider(color: Colors.black54,),
            ),
          ],
        ),
      ),
    );
  }
}

