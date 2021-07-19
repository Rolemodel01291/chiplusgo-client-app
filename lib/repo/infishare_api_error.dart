class InfiShareApiError implements Exception {
  final String errorCode;
  final String errorMsg;

  InfiShareApiError({this.errorCode, this.errorMsg});

  factory InfiShareApiError.fromJson(Map<String, dynamic> map) {
    return InfiShareApiError(errorCode: map['error'], errorMsg: map['message']);
  }

  String toString() => 'Error code: $errorCode error massage: $errorMsg';
}
