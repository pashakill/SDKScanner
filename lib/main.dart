import 'package:flutter/material.dart';
import 'qris_scanner/qris_scanner_activity.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => QrisScannerActivity(),
    },
  ));
}
