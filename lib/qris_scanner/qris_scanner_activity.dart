import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdk_scanner/qris_scanner_sdk.dart';

class QrisScannerActivity extends StatelessWidget {

  final MethodChannel _channel = const MethodChannel("qris_scanner_sdk/result");

  @override
  Widget build(BuildContext context) {
    return QrisScannerWidget(
      onScanCompleted: (barcode, messsage) {
        if (barcode != null) {
          _channel.invokeMethod("onScanCompleted", {
            "result": barcode.toString(),
            "messsage": messsage
          });
        }else{
          _channel.invokeMethod("onScanCompleted", {
            "result": null,
            "messsage": messsage
          });
        }
      },
    );
  }
}