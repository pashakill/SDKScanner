import 'package:sdk_scanner/qris_scanner_sdk.dart';

class QRISData {
  final String? payloadFormatIndicator;
  final String? pointOfInitiationMethod;
  final MerchantAccountInformation? merchantAccountInformation;
  final String? merchantCategoryCode;
  final String? transactionCurrency;
  final TipValue? tipValue;
  final String? countryCode;
  final String? merchantName;
  final String? merchantCity;
  final String? amount;
  final String? postalCode;
  final AdditionalDataField? additionalDataField;
  final String? crc;

  QRISData({
    this.payloadFormatIndicator,
    this.pointOfInitiationMethod,
    this.merchantAccountInformation,
    this.merchantCategoryCode,
    this.transactionCurrency,
    this.tipValue,
    this.amount,
    this.countryCode,
    this.merchantName,
    this.merchantCity,
    this.postalCode,
    this.additionalDataField,
    this.crc,
  });

  /// Mapping hasil decompose ke QRISData
  factory QRISData.fromDecomposed(Map<String, String> decomposedData) {
    return QRISData(
      payloadFormatIndicator: decomposedData['00'],
      pointOfInitiationMethod: decomposedData['01'],
      merchantAccountInformation: MerchantAccountInformation.fromDecomposed(
        {
          '26': decomposedData['26'],
          '51': decomposedData['51'],
        },
      ),
      merchantCategoryCode: decomposedData['52'],
      transactionCurrency: decomposedData['53'],
      amount: decomposedData['54'],
      tipValue: TipValue.fromDecomposed({'56': decomposedData['56']}),
      countryCode: decomposedData['58'],
      merchantName: decomposedData['59'],
      merchantCity: decomposedData['60'],
      postalCode: decomposedData['61'],
      additionalDataField:
      AdditionalDataField.fromDecomposed(decomposedData['62']),
      crc: decomposedData['63'],
    );
  }

  @override
  String toString() {
    return '{"QRISData" : {'
        '"payloadFormatIndicator": "$payloadFormatIndicator", '
        '"pointOfInitiationMethod": "$pointOfInitiationMethod", '
        '"merchantAccountInformation": ${merchantAccountInformation.toString()}, '
        '"merchantCategoryCode": "$merchantCategoryCode", '
        '"transactionCurrency": "$transactionCurrency", '
        '"amount": "$amount", '
        '"tipValue": ${tipValue.toString()}, '
        '"countryCode": "$countryCode", '
        '"merchantName": "$merchantName", '
        '"merchantCity": "$merchantCity", '
        '"postalCode": "$postalCode", '
        '"additionalDataField": ${additionalDataField.toString()}, '
        '"crc": "$crc"'
        '}}';
  }

  Map<String, dynamic> toJson() {
    return {
      'payloadFormatIndicator': payloadFormatIndicator,
      'pointOfInitiationMethod': pointOfInitiationMethod,
      'merchantAccountInformation': merchantAccountInformation?.toJson(),
      'merchantCategoryCode': merchantCategoryCode,
      'transactionCurrency': transactionCurrency,
      'amount': amount,
      'tipValue': tipValue?.toJson(),
      'countryCode': countryCode,
      'merchantName': merchantName,
      'merchantCity': merchantCity,
      'postalCode': postalCode,
      'additionalDataField': additionalDataField?.toJson(),
      'crc': crc,
    };
  }
}
