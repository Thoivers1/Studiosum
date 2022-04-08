import 'package:flutter/material.dart';

class bottom_appBar extends StatefulWidget {

  @override
  State<bottom_appBar> createState() => _bottom_appBarState();
}

class _bottom_appBarState extends State<bottom_appBar> {
  bool homePressed = false;
  bool searchPressed = false;
  bool profilePressed = false;

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
              icon: Icon(Icons.search, color: searchPressed ? Colors.black : Colors.blueGrey),
              iconSize: 35.0,
              onPressed: (){
                setState(() {
                  searchPressed = !searchPressed;
                  homePressed = false;
                  profilePressed = false;
                });
              },
            ),
          ),
          SizedBox(width: 20.0,),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: IconButton(
              icon: Icon(Icons.home, color: homePressed ? Colors.black : Colors.blueGrey),
              iconSize: 35.0,
              onPressed: (){
                setState(() {
                  homePressed = !homePressed;
                  searchPressed = false;
                  profilePressed = false;
                });
              },
            ),
          ),
          SizedBox(width: 20.0,),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: IconButton(
              icon: Icon(Icons.person, color: profilePressed ? Colors.black : Colors.blueGrey),
              iconSize: 35.0,
              onPressed: (){
                setState(() {
                  profilePressed = !profilePressed;
                  searchPressed = false;
                  homePressed = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}