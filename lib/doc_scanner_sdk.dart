/// DocScanner Flutter wrapper.
///
/// Camera preview, white crop rectangle, and crop-on-capture are implemented
/// in the native SDKs. This package only exposes a Dart API over platform channels.
library doc_scanner_sdk;

export 'src/doc_scanner.dart';
export 'src/models/scan_options.dart';
export 'src/models/scan_result.dart';
