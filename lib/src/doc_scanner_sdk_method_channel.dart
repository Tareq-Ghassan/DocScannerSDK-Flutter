import 'package:flutter/services.dart';

import 'doc_scanner_sdk_platform_interface.dart';
import 'models/scan_options.dart';
import 'models/scan_result.dart';

class MethodChannelDocScannerSdk extends DocScannerSdkPlatform {
  MethodChannelDocScannerSdk({
    MethodChannel? channel,
  }) : _channel = channel ?? const MethodChannel('doc_scanner_sdk');

  final MethodChannel _channel;

  @override
  Future<bool> requestCameraPermission() async {
    final ok = await _channel.invokeMethod<bool>('requestCameraPermission');
    return ok ?? false;
  }

  @override
  Future<bool> hasCameraPermission() async {
    final ok = await _channel.invokeMethod<bool>('hasCameraPermission');
    return ok ?? false;
  }

  @override
  Future<ScanResult> scanDocument(ScanOptions options) async {
    final map = await _channel.invokeMethod<Map<Object?, Object?>>(
      'scanDocument',
      options.toMap(),
    );
    if (map == null) {
      return ScanResult.failure('Native scanner returned null');
    }
    return ScanResult.fromMap(map);
  }

  @override
  Future<String> getVersion() async {
    return await _channel.invokeMethod<String>('getVersion') ?? '0.0.0';
  }
}
