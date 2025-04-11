import 'package:sdk_scanner/qris_scanner_sdk.dart';

class MerchantAccountInformation {
  final AccountInfo? info26;
  final AccountInfo? info51;

  MerchantAccountInformation({this.info26, this.info51});

  factory MerchantAccountInformation.fromDecomposed(
      Map<String, String?> decomposedData) {
    return MerchantAccountInformation(
      info26: decomposedData['26'] != null
          ? AccountInfo.fromDecomposed(decomposedData['26']!)
          : null,
      info51: decomposedData['51'] != null
          ? AccountInfo.fromDecomposed(decomposedData['51']!)
          : null,
    );
  }

  @override
  String toString() {
    return '{'
        '"26": ${info26}, '
        '"51": ${info51}'
        '}';
  }


  Map<String, dynamic> toJson() {
    return {
      '26': info26?.toJson(),
      '51': info51?.toJson(),
    };
  }
}

class AccountInfo {
  final String? globallyUniqueIdentifier;
  final String? panUrl;
  final String? merchantId;
  final String? criteria;

  AccountInfo({
    this.globallyUniqueIdentifier,
    this.panUrl,
    this.merchantId,
    this.criteria,
  });

  factory AccountInfo.fromDecomposed(String payload) {
    final decomposer = QrisValidator(payload);
    final data = decomposer.decompose();

    return AccountInfo(
      globallyUniqueIdentifier: data['00'],
      panUrl: data['01'],
      merchantId: data['02'],
      criteria: data['03'],
    );
  }

  @override
  String toString() {
    return '{'
        '"globallyuniqueIdentifier": "$globallyUniqueIdentifier", '
        '"pan": "${panUrl}", '
        '"merchantID": "${merchantId}", '
        '"criteria": "${criteria}"'
        '}';
  }

  Map<String, dynamic> toJson() {
    return {
      'globallyuniqueIdentifier': globallyUniqueIdentifier,
      'pan': panUrl,
      'merchantID': merchantId,
      'criteria': criteria,
    };
  }
}
