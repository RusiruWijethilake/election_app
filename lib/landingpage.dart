import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _MyLandingPage();
}

class _MyLandingPage extends State<LandingPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Election"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Scan QR"),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/qrcode');
          },
        )
      ),
    );
  }
}
