import 'dart:async';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'src/doc_scanner_sdk_platform_interface.dart';
import 'src/models/scan_options.dart';
import 'src/models/scan_result.dart';

/// Web implementation — uses browser MediaDevices.
/// Overlay + crop are performed in the browser (Dart), matching the web SDK.
class DocScannerSdkWeb extends DocScannerSdkPlatform {
  static void registerWith(Registrar registrar) {
    DocScannerSdkPlatform.instance = DocScannerSdkWeb();
  }

  @override
  Future<bool> requestCameraPermission() async => true;

  @override
  Future<bool> hasCameraPermission() async => true;

  @override
  Future<ScanResult> scanDocument(ScanOptions options) async {
    return ScanResult.failure(
      'Web scanner UI: use the DocScannerSDK-Web package or embed a video+canvas crop. '
      'Full Flutter web capture UI lands in a follow-up.',
    );
  }

  @override
  Future<String> getVersion() async => '1.0.0-web';
}
