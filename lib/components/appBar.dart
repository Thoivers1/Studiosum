import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bachelor/constants.dart';

class appBar extends StatelessWidget with PreferredSizeWidget {

  appBar({required this.textWidget, required this.height, required this.backArrow, required this.logoSize});

  final Widget textWidget;
  final double height;
  final bool backArrow;
  final double logoSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: backArrow,
      centerTitle: true,
      backgroundColor: kColor,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Hero(
            tag: 'logo',
            child: CircleAvatar(
              backgroundColor: kColor,
              foregroundImage: AssetImage('images/logo.png'),
              radius: logoSize,
            ),
          ),
          textWidget,
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
