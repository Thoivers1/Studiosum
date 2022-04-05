import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bachelor/constants.dart';

class appBar extends StatelessWidget with PreferredSizeWidget {

  appBar({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: kColor,
      title: Column(
        children: <Widget>[
          Hero(
            tag: 'logo',
            child: CircleAvatar(
              backgroundColor: kColor,
              foregroundImage: AssetImage('images/logo.png'),
              radius: 40.0,
            ),
          ),
          Text(text),
        ],

      ),

      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(50.0)),
      ),
      toolbarHeight: 120.0,

    );
  }

  @override
  Size get preferredSize => Size.fromHeight(120.0);
}
