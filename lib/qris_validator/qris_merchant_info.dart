class QRISMerchantInfo {
  String? globalId;
  String? mPAN;
  String? mId;
  String? mCriteria;

  @override
  String toString() {
    return """
    Global ID: $globalId
    PAN: $mPAN
    Merchant ID: $mId
    Criteria: $mCriteria
    """;
  }
}
