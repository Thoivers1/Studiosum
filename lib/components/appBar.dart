import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bachelor/constants.dart';

class appBar extends StatelessWidget with PreferredSizeWidget {

  appBar({required this.text, required this.height});

  final String text;
  final double height;

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
      toolbarHeight: height,

    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
