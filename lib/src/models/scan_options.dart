/// Options forwarded to the native DocScanner SDK.
///
/// Overlay drawing happens natively — these values configure that UI.
class ScanOptions {
  const ScanOptions({
    this.previewEnabled = true,
    this.showCropOverlay = true,
    this.overlayBorderColor = 0xFFFFFFFF,
    this.overlayBorderWidthDp = 3,
    this.overlayCornerRadiusDp = 12,
    this.overlayMarginHorizontalDp = 32,
    this.overlayHeightDp = 220,
    this.scanBothSides = false,
    this.jpegQuality = 95,
    this.flashEnabled = false,
  });

  final bool previewEnabled;
  final bool showCropOverlay;
  final int overlayBorderColor;
  final double overlayBorderWidthDp;
  final double overlayCornerRadiusDp;
  final double overlayMarginHorizontalDp;
  final double overlayHeightDp;
  final bool scanBothSides;
  final int jpegQuality;
  final bool flashEnabled;

  Map<String, Object?> toMap() => {
        'previewEnabled': previewEnabled,
        'showCropOverlay': showCropOverlay,
        'overlayBorderColor': overlayBorderColor,
        'overlayBorderWidthDp': overlayBorderWidthDp,
        'overlayCornerRadiusDp': overlayCornerRadiusDp,
        'overlayMarginHorizontalDp': overlayMarginHorizontalDp,
        'overlayHeightDp': overlayHeightDp,
        'scanBothSides': scanBothSides,
        'jpegQuality': jpegQuality,
        'flashEnabled': flashEnabled,
      };
}
