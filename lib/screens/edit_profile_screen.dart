
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bachelor/components/bottom_appBar.dart';
import 'package:bachelor/constants.dart';
import 'package:bachelor/components/rounded_button.dart';
import 'package:flutter/services.dart';

late User loggedInUser;

class EditProfileScreen extends StatefulWidget {

  static const String id = 'edit_profile_screen';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final _auth = FirebaseAuth.instance;
  String? username = '';
  List<Object?> users = [];

  String? email;
  String? firstName;
  String? lastName;

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
          print(loggedInUser.uid);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomAppBar(),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: kColor,
      ),
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
              child: Text(username!, style: TextStyle(
                fontSize: 25.0,
              ),),
            ),
            SizedBox(height: 50.0,),

            TextField(
              textAlign: TextAlign.center,
              inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[<\>\&\%\!]')),],
              onChanged: (value) {
                firstName = value;
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Fornavn:'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[<\>\&\%\!]')),],
              onChanged: (value) {
                lastName = value;
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Etternavn:'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[<\>\&\%\!]')),],
              textAlign: TextAlign.center,
              onChanged: (value) {
                email = value;
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'E-post adresse:'),
            ),
            SizedBox(
              height: 8.0,
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
                widgetText: Text('Lagre endringer', style: TextStyle(color: Colors.white)),
                color: kColor,
                width: 200,
                height: 42,
                onPressed: () async {

                  if(firstName != null) {
                    await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(loggedInUser.uid)
                        .update({
                      'FirstName': firstName,
                    });
                  }
                  if(lastName != null){
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(loggedInUser.uid)
                      .update({
                  'LastName' : lastName,
                    });
                  }
                  if(email != null) {
                    await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(loggedInUser.uid)
                        .update({
                      'Email': email,
                    });
                    loggedInUser.updateEmail(email!);
                  }
                  /*
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(loggedInUser.uid)
                      .update({
                        'FirstName' : firstName,
                        'lastName' : lastName,
                        'Email' : email,
                    });

                   */
                  int count = 0;
                  Navigator.popUntil(context, (route) {
                    return count++ == 3;
                  });

                  }),
          ],
        ),
      ),
    );
  }
}

