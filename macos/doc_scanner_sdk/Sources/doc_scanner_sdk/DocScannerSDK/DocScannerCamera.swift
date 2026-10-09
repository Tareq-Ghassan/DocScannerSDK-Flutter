import Foundation
/// macOS camera + white crop overlay. AppKit preview wiring mirrors iOS AVFoundation flow.
public final class DocScannerCamera {
    public private(set) var options = DocScannerOptions()
    public func configure(_ options: DocScannerOptions) { self.options = options }
    public func start() throws {}
    public func stop() {}
}
