import AVFoundation
import UIKit

/// Native preview + white crop rectangle. Flutter hosts this via PlatformView.
public final class DocScannerPreviewView: UIView {
    public let previewLayer = AVCaptureVideoPreviewLayer()
    private let dimView = UIView()
    private let holeLayer = CAShapeLayer()
    private let borderLayer = CAShapeLayer()

    public var options = DocScannerOptions() {
        didSet { setNeedsLayout() }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .black
        previewLayer.videoGravity = .resizeAspectFill
        layer.insertSublayer(previewLayer, at: 0)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        dimView.isUserInteractionEnabled = false
        addSubview(dimView)
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.lineWidth = 3
        layer.addSublayer(borderLayer)
    }

    /// Crop rectangle in this view's coordinates.
    public var cropRect: CGRect {
        let inset = options.overlayHorizontalInset
        let height = options.overlayHeight
        let width = bounds.width - inset * 2
        let x = inset
        let y = (bounds.height - height) / 2
        return CGRect(x: x, y: y, width: width, height: height)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds
        dimView.frame = bounds
        let rect = cropRect
        let path = UIBezierPath(rect: bounds)
        let hole = UIBezierPath(roundedRect: rect, cornerRadius: options.overlayCornerRadius)
        path.append(hole)
        path.usesEvenOddFillRule = true
        holeLayer.path = path.cgPath
        holeLayer.fillRule = .evenOdd
        dimView.layer.mask = holeLayer
        dimView.isHidden = !options.showCropOverlay
        borderLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: options.overlayCornerRadius).cgPath
        borderLayer.strokeColor = options.overlayBorderColor.cgColor
        borderLayer.lineWidth = options.overlayBorderWidth
        borderLayer.isHidden = !options.showCropOverlay
    }
}
