import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'doc_scanner_sdk_method_channel.dart';
import 'models/scan_options.dart';
import 'models/scan_result.dart';

abstract class DocScannerSdkPlatform extends PlatformInterface {
  DocScannerSdkPlatform() : super(token: _token);

  static final Object _token = Object();
  static DocScannerSdkPlatform _instance = MethodChannelDocScannerSdk();
  static DocScannerSdkPlatform get instance => _instance;
  static set instance(DocScannerSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> requestCameraPermission() =>
      throw UnimplementedError('requestCameraPermission() not implemented.');
  Future<bool> hasCameraPermission() =>
      throw UnimplementedError('hasCameraPermission() not implemented.');
  Future<ScanResult> scanDocument(ScanOptions options) =>
      throw UnimplementedError('scanDocument() not implemented.');
  Future<String> getVersion() =>
      throw UnimplementedError('getVersion() not implemented.');
}
