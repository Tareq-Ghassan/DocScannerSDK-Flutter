import UIKit

/// Options for the native iOS scanner. Overlay is drawn by [DocScannerPreviewView].
public struct DocScannerOptions: Sendable {
    public var showCropOverlay: Bool
    public var overlayBorderColor: UIColor
    public var overlayBorderWidth: CGFloat
    public var overlayCornerRadius: CGFloat
    public var overlayHorizontalInset: CGFloat
    public var overlayHeight: CGFloat
    public var scanBothSides: Bool
    public var jpegQuality: CGFloat

    public init(
        showCropOverlay: Bool = true,
        overlayBorderColor: UIColor = .white,
        overlayBorderWidth: CGFloat = 3,
        overlayCornerRadius: CGFloat = 12,
        overlayHorizontalInset: CGFloat = 32,
        overlayHeight: CGFloat = 220,
        scanBothSides: Bool = false,
        jpegQuality: CGFloat = 0.95
    ) {
        self.showCropOverlay = showCropOverlay
        self.overlayBorderColor = overlayBorderColor
        self.overlayBorderWidth = overlayBorderWidth
        self.overlayCornerRadius = overlayCornerRadius
        self.overlayHorizontalInset = overlayHorizontalInset
        self.overlayHeight = overlayHeight
        self.scanBothSides = scanBothSides
        self.jpegQuality = jpegQuality
    }
}
