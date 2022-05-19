import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bachelor/constants.dart';
import 'package:bachelor/components/profileButton.dart';
import 'package:bachelor/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bachelor/screens/contact_screen.dart';
import 'package:bachelor/screens/edit_profile_screen.dart';

late User loggedInUser;

class ProfileSettingsScreen extends StatefulWidget {

  static const String id = 'profile_settings_screen';

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {

  final _auth = FirebaseAuth.instance;
  String? username = '';
  List<Object?> users = [];

  @override
  void initState() {

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
        print(doc.data());
        setState(() {
          this.users.add(doc.data());
          username = users.toString().substring(users.toString().indexOf('FirstName:') + 10, users.toString().indexOf('LastName') - 2);
          print(username);
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
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 50.0,),
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
            profileButton(
              icon: Icons.person,
              text: 'Rediger profil',
              onTap: (){Navigator.pushNamed(context, EditProfileScreen.id);},
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Divider(color: Colors.black54,),
            ),
            profileButton(
              icon: Icons.info_rounded,
              text: 'Hjelp & kontakt',
              onTap: (){Navigator.pushNamed(context, ContactScreen.id);},
            ),
            Spacer(),
            RoundedButton(
                widgetText: Text('Logg ut', style: TextStyle(color: Colors.white)),
                color: kColor,
                width: 100.0,
                height: 42.0,
                onPressed: (){
                  _auth.signOut();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
            )
          ],
        ),
      ),
    );
  }
}

