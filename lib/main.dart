import 'package:election_app/landingpage.dart';
import 'package:election_app/qrscannerpage.dart';
import 'package:election_app/votingpage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Election',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/landing',
      routes: {
        '/landing': (context) => const LandingPage(),
        '/qrcode': (context) => const QRScannerPage(),
        '/voting': (context) => const VotingPage(),
      },
    );
  }
}