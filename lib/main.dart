import 'dart:async';

import 'package:dronelink_desktop/pages/pairing_page.dart';
import 'package:flutter/material.dart';
import 'package:dart_vlc/dart_vlc.dart';

void main() {
  DartVLC.initialize();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DroneLink Desktop',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        primaryColor: const Color.fromRGBO(19, 125, 197, 1.0),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const PairingPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            margin: const EdgeInsets.all(30.0),
            child: const Image(
                image: AssetImage("assets/logo_color_white_font_noBG.png")),
          )
        ]),
      ),
    );
  }
}
