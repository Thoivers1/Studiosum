import 'package:bachelor/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:bachelor/components/rounded_button.dart';
import 'package:bachelor/components/appBar.dart';
import 'package:bachelor/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {

  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(textWidget:Text('Studiosum'), height: 120.0, backArrow: true, logoSize: 40.0,),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 50.0,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text('Logg inn på din bruker', style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                    SizedBox(
                      height: 75.0,
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(hintText: 'E-post'),
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
                      decoration: kTextFieldDecoration.copyWith(hintText: 'Passord'),
                    ),
                    TextButton(
                        onPressed: (){
                          _auth.sendPasswordResetEmail(email: email);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Sendt passord-reset til: ' + email),
                                );
                              });
                        },
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Glemt passord?', style: TextStyle(color: Colors.blue)))
                    ),

                    RoundedButton(
                      widgetText: Text('Logg in', style: TextStyle(color: Colors.white)),
                      color: kColor,
                      width: 200,
                      height: 42,
                      onPressed: () async {
                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          if (user != null) {
                            Navigator.pushNamed(context, HomeScreen.id);
                          }
                        } catch(e){
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Ugyldig innlogging'),
                                );
                              });
                        }
                      },),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
