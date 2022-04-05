import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bachelor/components/rounded_button.dart';
import 'package:bachelor/screens/login_screen.dart';
import 'package:bachelor/screens/registration_screen.dart';
import 'package:bachelor/components/appBar.dart';
import 'package:bachelor/constants.dart';

class WelcomeScreen extends StatefulWidget {

  static const String id = 'screens';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(text:'studiosum'),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              Text('Finn alle bøkene du trenger for ditt studie!', textAlign: TextAlign.center, style: TextStyle(
                fontSize: 30.0,
              )),
              SizedBox(
                height: 100.0,
              ),
              RoundedButton(
                  title: 'Log in',
                  color: kColor,
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },),
              RoundedButton(
                  title: 'Register',
                  color: kColor,
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  }),
            ],
          ),
        ),
      ),
      );
  }
}
