import 'package:flutter/material.dart';
import 'package:bachelor/components/appBar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/rounded_button.dart';

class AdScreen extends StatelessWidget {

  static const String id = 'ad_screen';
  final Object? ads;

  const AdScreen({
    Key? key,
    required this.ads,
  }) : super (key: key);

  void _contact() async {
    //final url = 'thoive99@gmail.com';
    final Uri url = Uri(
        scheme: 'mailto',
        path: ads.toString().substring(ads.toString().indexOf('Bruker:') + 7, ads.toString().indexOf('}')));

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(textWidget:FittedBox(fit: BoxFit.contain ,child: Text(ads.toString().substring(ads.toString().indexOf('Tittel:') + 7, ads.toString().indexOf('Pris:')-2),)), height: 120.0, backArrow: true, logoSize: 0.0,),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              Image(
                image: AssetImage('images/book.png'),
                height: 200.0,
                width: 100.0,
              ),
              Text(ads.toString().substring(ads.toString().indexOf('Pris:') + 5, ads.toString().indexOf('Bruker:')-2) + 'kr',style: TextStyle(
                fontSize: 40.0,
              ),),
              SizedBox(
                height: 20.0,
              ),
              Text((ads.toString().substring(ads.toString().indexOf('Beskrivelse:') + 12, ads.toString().indexOf('Tittel:')-2))),
              SizedBox(height: 50.0,),
              Padding(
                padding: const EdgeInsets.only(left: 100.0, right: 100.0),
                child: RoundedButton(
                    widgetText: Text('Kontakt selger', style: TextStyle(color: Colors.white),),
                    color: Colors.green,
                    onPressed: (){
                      _contact();
                    },
                    width: 50.0,
                    height: 20.0
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
