import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bachelor/components/rounded_button.dart';
import 'package:bachelor/components/appBar.dart';
import 'package:bachelor/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bachelor/screens/home_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:uuid/uuid.dart';

class RegistrationScreen extends StatefulWidget {

  static const String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String email;
  late String firstName;
  late String lastName;
  late String password;
  late String password2;

  Future addUser ({required String firstName, required String lastName, required String email}) async {
    const uuid = Uuid();
    String id = uuid.v1();
    final docUser = FirebaseFirestore.instance.collection('Users')
        .doc(id);

    final data = {
      'Email': email,
      'FirstName': firstName,
      'LastName' : lastName,
    };

    await docUser.set(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(textWidget:Text('studiosum'), height: 120.0, backArrow: true, logoSize: 40.0,),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 50,),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  firstName = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'First name:'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  lastName = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Last name:'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'E-post adresse:'),
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
                decoration: kTextFieldDecoration.copyWith(hintText: 'Passord:'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password2 = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Repeter passord'),
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
                    if(password == password2){
                      final newUser = await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                      addUser(firstName: firstName, lastName: lastName, email: email);
                      if(newUser != null){
                        Navigator.pushNamed(context, HomeScreen.id);
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Passord ikke like'),
                            );
                          });
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
