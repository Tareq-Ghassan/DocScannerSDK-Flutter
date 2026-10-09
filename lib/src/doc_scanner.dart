import 'doc_scanner_sdk_platform_interface.dart';
import 'models/scan_options.dart';
import 'models/scan_result.dart';

/// Flutter facade over native DocScanner SDKs.
///
/// Does **not** draw the crop rectangle or run camera code itself.
/// Android uses JitPack `DocScannerSDK-Android`; iOS/macOS use embedded
/// native source snapshots.
class DocScanner {
  DocScanner();

  final DocScannerSdkPlatform _platform = DocScannerSdkPlatform.instance;

  /// Request camera permission via the native SDK / OS APIs.
  Future<bool> requestCameraPermission() => _platform.requestCameraPermission();

  /// Whether camera permission is already granted.
  Future<bool> hasCameraPermission() => _platform.hasCameraPermission();

  /// Open the native scanner UI (white crop rectangle) and return cropped paths.
  Future<ScanResult> scanDocument([ScanOptions options = const ScanOptions()]) {
    return _platform.scanDocument(options);
  }

  /// Convenience for front + back.
  Future<ScanResult> scanBothSides([ScanOptions options = const ScanOptions()]) {
    return _platform.scanDocument(options.copyWith(scanBothSides: true));
  }

  /// Native SDK version string.
  Future<String> getVersion() => _platform.getVersion();
}

extension on ScanOptions {
  ScanOptions copyWith({bool? scanBothSides}) => ScanOptions(
        previewEnabled: previewEnabled,
        showCropOverlay: showCropOverlay,
        overlayBorderColor: overlayBorderColor,
        overlayBorderWidthDp: overlayBorderWidthDp,
        overlayCornerRadiusDp: overlayCornerRadiusDp,
        overlayMarginHorizontalDp: overlayMarginHorizontalDp,
        overlayHeightDp: overlayHeightDp,
        scanBothSides: scanBothSides ?? this.scanBothSides,
        jpegQuality: jpegQuality,
        flashEnabled: flashEnabled,
      );
}
