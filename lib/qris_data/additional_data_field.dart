import 'package:sdk_scanner/qris_scanner_sdk.dart';

class AdditionalDataField {
  final String? terminalLabel;
  final String? purposeOfTransaction;
  final String? merchantChannel;

  AdditionalDataField({
    this.terminalLabel,
    this.purposeOfTransaction,
    this.merchantChannel,
  });

  factory AdditionalDataField.fromDecomposed(String? payload) {
    if (payload == null) return AdditionalDataField();
    final decomposer = QrisValidator(payload);
    final data = decomposer.decompose();

    return AdditionalDataField(
      terminalLabel: data['07'],
      purposeOfTransaction: data['08'],
      merchantChannel: data['11'],
    );
  }

  @override
  String toString() {
    return '{'
        '"terminalLabel": "$terminalLabel", '
        '"purposeOfTransaction": "$purposeOfTransaction", '
        '"merchantChannel": "${merchantChannel}"'
        '}';
  }

  Map<String, dynamic> toJson() {
    return {
      'TerminalLabel': terminalLabel,
      'PurposeOfTransaction': purposeOfTransaction,
      'MerchantChannel': merchantChannel,
    };
  }
}
