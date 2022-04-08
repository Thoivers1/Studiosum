import 'package:flutter/material.dart';

class bottom_appBar extends StatelessWidget {
  const bottom_appBar({
    Key? key,
  }) : super(key: key);

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
              icon: Icon(Icons.search, color: Colors.blueGrey,),
              iconSize: 35.0,
              onPressed: (){

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

              },
            ),
          ),
        ],
      ),
    );
  }
}