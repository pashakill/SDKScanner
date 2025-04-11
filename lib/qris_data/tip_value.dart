class TipValue {
  final String? fixed;
  TipValue({this.fixed});

  factory TipValue.fromDecomposed(Map<String, String?> decomposedData) {
    return TipValue(
      fixed: decomposedData['56'],
    );
  }

  @override
  String toString() {
    return '{'
        '"fixed": "$fixed"'
        '}';
  }

  Map<String, dynamic> toJson() {
    return {
      'Fixed': fixed,
    };
  }
}
