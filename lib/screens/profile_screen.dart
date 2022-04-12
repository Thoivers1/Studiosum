import 'package:bachelor/screens/profile_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:bachelor/components/profileButton.dart';
import 'package:bachelor/components/bottom_appBar.dart';

class ProfileScreen extends StatelessWidget {

  static const String id = 'profile_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 20.0),
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

