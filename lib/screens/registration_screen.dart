import 'package:flutter/material.dart';
import 'package:bachelor/components/rounded_button.dart';
import 'package:bachelor/components/appBar.dart';
import 'package:bachelor/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bachelor/screens/home_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {

  static const String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(text:'studiosum', height: 120.0,),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  widgetText: Text('Logg in', style: TextStyle(color: Colors.white)),
                  color: kColor,
                  width: 200,
                  height: 42,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if(newUser != null){
                      Navigator.pushNamed(context, HomeScreen.id);
                    }

                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e){
                    print(e);
                    }
                }),
            ],
          ),
        ),
      ),
    );
  }
}
