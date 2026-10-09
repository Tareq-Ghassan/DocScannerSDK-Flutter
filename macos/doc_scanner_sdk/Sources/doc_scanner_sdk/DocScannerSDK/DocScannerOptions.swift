import Foundation
public struct DocScannerOptions: Sendable {
    public var showCropOverlay: Bool
    public init(showCropOverlay: Bool = true) { self.showCropOverlay = showCropOverlay }
}
