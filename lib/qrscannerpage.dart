import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _MyQRScannerPage();
}

class _MyQRScannerPage extends State<QRScannerPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Scan the QE"),
      ),
      body: Center(
        child: MobileScanner(
          allowDuplicates: true,
          onDetect: (barcode, args) {
            Navigator.popAndPushNamed(context, '/voting', arguments: barcode.rawValue.toString());
          },
        )
      ),
    );
  }
}
