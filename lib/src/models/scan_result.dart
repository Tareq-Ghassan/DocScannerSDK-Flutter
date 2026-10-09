/// Result returned by native crop-on-capture.
class ScanResult {
  const ScanResult({
    this.frontImagePath,
    this.backImagePath,
    this.isSuccess = false,
    this.errorMessage,
    DateTime? timestamp,
  }) : timestamp = timestamp;

  final String? frontImagePath;
  final String? backImagePath;
  final bool isSuccess;
  final String? errorMessage;
  final DateTime? timestamp;

  factory ScanResult.fromMap(Map<Object?, Object?> map) {
    return ScanResult(
      frontImagePath: map['frontImagePath'] as String?,
      backImagePath: map['backImagePath'] as String?,
      isSuccess: (map['isSuccess'] as bool?) ?? false,
      errorMessage: map['errorMessage'] as String?,
      timestamp: DateTime.now(),
    );
  }

  factory ScanResult.failure(String message) => ScanResult(
        isSuccess: false,
        errorMessage: message,
        timestamp: DateTime.now(),
      );
}
