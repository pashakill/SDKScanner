import 'dart:convert';
import 'package:sdk_scanner/qris_scanner_sdk.dart';

class QrisReader {
  final Map<String, String> qrisField;
  final Map<String, String> qrisFieldAdditionalData;

  QrisReader(this.qrisField, this.qrisFieldAdditionalData);

  /// Parsing QRIS payload
  List<QRISSegment> parsing(String payload) {
    if (isQRISValid(payload)) {
      var segments = parsingRootId(payload, qrisField);
      parsingMerchantInfo(segments);
      parsingAdditionalData(segments);
      return segments;
    } else {
      return [];
    }
  }

  /// Validasi QRIS dengan CRC
  bool isQRISValid(String qrdata) {
    if (qrdata.length > 4) {
      String qrDataNonCRC = qrdata.substring(0, qrdata.length - 4);
      String qrCRC = qrdata.substring(qrdata.length - 4).toUpperCase();
      String checkCRC = computeCRC(qrDataNonCRC).toUpperCase();

      return qrCRC == checkCRC;
    }
    return false;
  }

  /// Menghitung CRC
  String computeCRC(String data) {
    int crc = 0xFFFF;
    int polynomial = 0x1021;

    for (int byte in utf8.encode(data)) {
      crc ^= (byte << 8);
      for (int i = 0; i < 8; i++) {
        if ((crc & 0x8000) != 0) {
          crc = (crc << 1) ^ polynomial;
        } else {
          crc <<= 1;
        }
      }
    }
    return crc.toRadixString(16).padLeft(4, '0').toUpperCase();
  }

  /// Parsing root ID
  List<QRISSegment> parsingRootId(String payload, Map<String, String> fieldMap) {
    List<QRISSegment> segments = [];

    for (int tag = 0; tag < 100; tag++) {
      String rootId = tag.toString().padLeft(2, '0');

      if (payload.startsWith(rootId)) {
        payload = payload.substring(2); // Hapus rootId
        int len = int.parse(payload.substring(0, 2));
        payload = payload.substring(2); // Hapus panjang data
        String data = payload.substring(0, len);
        payload = payload.substring(len); // Hapus data

        segments.add(QRISSegment(
          rootId: rootId,
          field: fieldMap[rootId],
          length: len,
          data: data,
        ));
      }
    }
    return segments;
  }

  /// Parsing informasi merchant
  void parsingMerchantInfo(List<QRISSegment> segments) {
    for (var seg in segments) {
      int rootId = int.parse(seg.rootId);

      if (rootId >= 2 && rootId <= 51) {
        String payload = seg.data;
        seg.data = parseMerchantInfo(payload);
      }
    }
  }

  QRISMerchantInfo parseMerchantInfo(String payload) {
    var mInfo = QRISMerchantInfo();
    for (int tag = 0; tag <= 3; tag++) {
      String rootId = tag.toString().padLeft(2, '0');

      if (payload.startsWith(rootId)) {
        payload = payload.substring(2); // Hapus rootId
        int len = int.parse(payload.substring(0, 2));
        payload = payload.substring(2); // Hapus panjang data
        String data = payload.substring(0, len);
        payload = payload.substring(len); // Hapus data

        if (tag == 0) mInfo.globalId = data;
        if (tag == 1) mInfo.mPAN = data;
        if (tag == 2) mInfo.mId = data;
        if (tag == 3) mInfo.mCriteria = data;
      }
    }
    return mInfo;
  }

  /// Parsing data tambahan
  void parsingAdditionalData(List<QRISSegment> segments) {
    for (var seg in segments) {
      if (seg.rootId == "62") {
        String payload = seg.data;
        seg.data = parsingRootId(payload, qrisFieldAdditionalData);
      }
    }
  }
}
