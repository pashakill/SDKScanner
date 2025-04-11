import 'dart:convert';

class QrisValidator {
  final String qrData;
  bool _isValidated = false;
  Map<String, String> map = {};

  QrisValidator(this.qrData);

  Map<String, String>parsingAndCheck(){
    if(isQRISValid(qrData)){
     return decompose();
    }
    throw Exception("Invalid CRC: Payload CRC tidak valid");
  }

  /// Decompose QRIS payload into ID-Length-Value structure
  Map<String, String> decompose() {
    int start = 0;
    int end = qrData.length;

    while (end - start != 0) {
      int idDigit = 2;
      int lengthDigit = 2;

      String id = qrData.substring(start, start + idDigit);
      int dataLength =
      int.parse(qrData.substring(start + idDigit, start + idDigit + lengthDigit));
      String value = qrData.substring(
          start + idDigit + lengthDigit, start + idDigit + lengthDigit + dataLength);

      map[id] = value;

      start = start + idDigit + lengthDigit + dataLength;
    }

    return map;
  }

  /// Validate CRC checksum
  bool isQRISValid(String qrdata) {
    var isValid = false;
    // Pastikan panjang data lebih dari 4 (untuk CRC)
    if (qrdata.isNotEmpty && qrdata.length > 4) {
      // Pisahkan data QR tanpa CRC
      String qrDataNonCRC = qrdata.substring(0, qrdata.length - 4);
      // Ambil nilai CRC dari payload
      String qrCRC = qrdata.substring(qrdata.length - 4).toUpperCase();
      // Hitung CRC untuk payload tanpa CRC
      String checkCRC = computeCRC(utf8.encode(qrDataNonCRC)).toUpperCase();
      print("QR CRC: $qrCRC, System CRC: $checkCRC");
      // Validasi CRC dan periksa apakah payload dimulai dengan "00"
      if (qrDataNonCRC.startsWith("00") && qrCRC == checkCRC) {
        isValid = true;
        print("QR CRC: valid");
        return isValid;
      }else {
        print("QR CRC: invalid");
        isValid = false;
        return isValid;
      }
    }
    return isValid;
  }

  String computeCRC(List<int> bytes) {
    int crc = 0xFFFF; // Nilai awal CRC
    int polynomial = 0x1021; // Polinomial untuk CRC-16-CCITT
    for (var byte in bytes) {
      crc ^= (byte << 8); // XOR antara CRC dan byte
      for (int i = 0; i < 8; i++) {
        bool c15 = (crc & 0x8000) != 0; // Periksa bit ke-15
        crc <<= 1; // Geser CRC ke kiri 1 bit
        if (c15) {
          crc ^= polynomial; // XOR dengan polinomial jika bit ke-15 aktif
        }
      }
    }
    crc &= 0xFFFF; // Batasi CRC ke 16-bit
    return crc.toRadixString(16).padLeft(4, '0').toUpperCase(); // Konversi ke string hexadecimal
  }

  /// Get tag value from decomposed QRIS payload
  String? getTagValue(String idValue, String tagID) {
    try {
      Map<String, String> tagMap = {};
      int start = 0;
      int end = idValue.length;

      while (end - start != 0) {
        int idDigit = 2;
        int lengthDigit = 2;

        String id = idValue.substring(start, start + idDigit);
        int dataLength =
        int.parse(idValue.substring(start + idDigit, start + idDigit + lengthDigit));
        String value = idValue.substring(
            start + idDigit + lengthDigit, start + idDigit + lengthDigit + dataLength);

        tagMap[id] = value;

        start = start + idDigit + lengthDigit + dataLength;
      }

      return tagMap[tagID];
    } catch (e) {
      throw Exception("Invalid Tag");
    }
  }
}
