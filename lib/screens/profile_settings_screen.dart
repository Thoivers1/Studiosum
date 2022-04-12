import 'package:flutter/material.dart';
import 'package:bachelor/constants.dart';
import 'package:bachelor/components/profileButton.dart';
import 'package:bachelor/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileSettingsScreen extends StatefulWidget {

  static const String id = 'profile_settings_screen';

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Text('Ola Nordmann', style: TextStyle(
                fontSize: 25.0,
              ),),
            ),
            SizedBox(height: 100.0,),
            profileButton(
              icon: Icons.person,
              text: 'Rediger profil',
              onTap: (){},
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Divider(color: Colors.black54,),
            ),
            profileButton(
              icon: Icons.info_rounded,
              text: 'Hjelp & kontakt',
              onTap: (){},
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

