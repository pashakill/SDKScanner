class QRISSegment {
  final String rootId;
  final String? field;
  final int length;
  dynamic data;

  QRISSegment({
    required this.rootId,
    this.field,
    required this.length,
    required this.data,
  });

  @override
  String toString() {
    return "ID[$rootId] FIELD[$field] LENGTH[$length] DATA[$data]";
  }
}
