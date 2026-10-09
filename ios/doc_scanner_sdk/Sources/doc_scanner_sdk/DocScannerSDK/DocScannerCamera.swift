import AVFoundation
import UIKit

/// Native camera session that captures and crops to the white overlay rectangle.
public final class DocScannerCamera: NSObject {
    public let previewView = DocScannerPreviewView()
    public private(set) var options = DocScannerOptions()

    private let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private var continuation: CheckedContinuation<UIImage, Error>?

    public func configure(_ options: DocScannerOptions) {
        self.options = options
        previewView.options = options
    }

    public func start() throws {
        session.beginConfiguration()
        session.sessionPreset = .photo
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            throw DocScannerError.cameraUnavailable
        }
        session.inputs.forEach { session.removeInput($0) }
        session.addInput(input)
        if session.canAddOutput(photoOutput) {
            session.outputs.forEach { session.removeOutput($0) }
            session.addOutput(photoOutput)
        }
        previewView.previewLayer.session = session
        session.commitConfiguration()
        DispatchQueue.global(qos: .userInitiated).async { [session] in
            session.startRunning()
        }
    }

    public func stop() {
        session.stopRunning()
    }

    /// Capture a photo and crop it to [DocScannerPreviewView.cropRect].
    public func capture() async throws -> UIImage {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<UIImage, Error>) in
            self.continuation = cont
            let settings = AVCapturePhotoSettings()
            self.photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }

    public func saveJPEG(_ image: UIImage) throws -> String {
        guard let data = image.jpegData(compressionQuality: options.jpegQuality) else {
            throw DocScannerError.encodeFailed
        }
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("DOC_\(UUID().uuidString).jpg")
        try data.write(to: url)
        return url.path
    }
}

extension DocScannerCamera: AVCapturePhotoCaptureDelegate {
    public func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        if let error {
            continuation?.resume(throwing: error)
            continuation = nil
            return
        }
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            continuation?.resume(throwing: DocScannerError.encodeFailed)
            continuation = nil
            return
        }
        let cropped = crop(image, to: previewView.cropRect, in: previewView.bounds)
        continuation?.resume(returning: cropped)
        continuation = nil
    }

    private func crop(_ image: UIImage, to overlay: CGRect, in viewBounds: CGRect) -> UIImage {
        guard viewBounds.width > 0, viewBounds.height > 0,
              let cg = image.cgImage else { return image }
        let scaleX = CGFloat(cg.width) / viewBounds.width
        let scaleY = CGFloat(cg.height) / viewBounds.height
        var crop = CGRect(
            x: overlay.origin.x * scaleX,
            y: overlay.origin.y * scaleY,
            width: overlay.size.width * scaleX,
            height: overlay.size.height * scaleY
        )
        crop = crop.intersection(CGRect(x: 0, y: 0, width: cg.width, height: cg.height))
        guard let cut = cg.cropping(to: crop) else { return image }
        return UIImage(cgImage: cut, scale: image.scale, orientation: image.imageOrientation)
    }
}

public enum DocScannerError: Error {
    case cameraUnavailable
    case encodeFailed
}
