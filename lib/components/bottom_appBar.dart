import 'package:flutter/material.dart';
import 'package:bachelor/screens/profile_screen.dart';
import 'package:bachelor/screens/home_screen.dart';
import 'package:bachelor/screens/search_screen.dart';

class bottomAppBar extends StatefulWidget {

  @override
  State<bottomAppBar> createState() => _bottomAppBarState();
}

class _bottomAppBarState extends State<bottomAppBar> {

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: AutomaticNotchedShape(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        StadiumBorder(),
      ),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: IconButton(
              icon: Icon(Icons.search, color: Colors.blueGrey),
              iconSize: 35.0,
              onPressed: (){
                  if(ModalRoute.of(context)?.settings.name != SearchScreen.id) {
                    Navigator.pushNamed(context, SearchScreen.id);
                  }
              },
            ),
          ),
          SizedBox(width: 20.0,),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: IconButton(
              icon: Icon(Icons.home, color: Colors.blueGrey),
              iconSize: 35.0,
              onPressed: (){
                if(ModalRoute.of(context)?.settings.name != HomeScreen.id) {
                  Navigator.pushNamed(context, HomeScreen.id);
                }
              },
            ),
          ),
          SizedBox(width: 20.0,),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: IconButton(
              icon: Icon(Icons.person, color: Colors.blueGrey),
              iconSize: 35.0,
              onPressed: (){
                  if(ModalRoute.of(context)?.settings.name != ProfileScreen.id) {
                    Navigator.pushNamed(context, ProfileScreen.id);
                  }
              },
            ),
          ),
        ],
      ),
    );
  }
}