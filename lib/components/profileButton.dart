import 'package:flutter/material.dart';

class profileButton extends StatelessWidget {
  profileButton({required this.icon, required this.text, required this.onTap});

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(icon, color: Colors.blue, size: 30.0,),
            Text(text, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
            Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 20.0,),
          ],
        ),
      ),
    );
  }
}