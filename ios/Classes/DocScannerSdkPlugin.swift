import Flutter
import UIKit
import AVFoundation

/// Flutter → iOS bridge. Uses embedded DocScannerSDK snapshot for crop UI.
public class DocScannerSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "doc_scanner_sdk", binaryMessenger: registrar.messenger())
    let instance = DocScannerSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  private var camera: DocScannerCamera?

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getVersion":
      result(DocScannerSDK.version)
    case "hasCameraPermission":
      result(AVCaptureDevice.authorizationStatus(for: .video) == .authorized)
    case "requestCameraPermission":
      AVCaptureDevice.requestAccess(for: .video) { granted in
        DispatchQueue.main.async { result(granted) }
      }
    case "scanDocument":
      // Present a simple full-screen host that uses DocScannerCamera.
      // Full UIViewController presentation is enough for v1.
      guard let root = UIApplication.shared.connectedScenes
        .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
        .first?.rootViewController else {
        result(FlutterError(code: "NO_VC", message: "No root view controller", details: nil))
        return
      }
      let args = call.arguments as? [String: Any] ?? [:]
      let host = DocScannerHostViewController(args: args) { scan in
        result(scan)
      }
      host.modalPresentationStyle = .fullScreen
      root.present(host, animated: true)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

final class DocScannerHostViewController: UIViewController {
  private let args: [String: Any]
  private let completion: ([String: Any?]) -> Void
  private let camera = DocScannerCamera()
  private let captureButton = UIButton(type: .system)

  init(args: [String: Any], completion: @escaping ([String: Any?]) -> Void) {
    self.args = args
    self.completion = completion
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { fatalError() }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    let options = DocScannerOptions(
      showCropOverlay: (args["showCropOverlay"] as? Bool) ?? true,
      scanBothSides: (args["scanBothSides"] as? Bool) ?? false,
      jpegQuality: CGFloat((args["jpegQuality"] as? Int) ?? 95) / 100.0
    )
    camera.configure(options)
    camera.previewView.frame = view.bounds
    camera.previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(camera.previewView)
    captureButton.setTitle("Capture", for: .normal)
    captureButton.backgroundColor = .white
    captureButton.setTitleColor(.black, for: .normal)
    captureButton.layer.cornerRadius = 28
    captureButton.frame = CGRect(x: (view.bounds.width - 72) / 2, y: view.bounds.height - 120, width: 72, height: 56)
    captureButton.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
    captureButton.addTarget(self, action: #selector(onCapture), for: .touchUpInside)
    view.addSubview(captureButton)
    try? camera.start()
  }

  @objc private func onCapture() {
    Task {
      do {
        let image = try await camera.capture()
        let path = try camera.saveJPEG(image)
        camera.stop()
        dismiss(animated: true) {
          self.completion([
            "isSuccess": true,
            "frontImagePath": path,
            "backImagePath": nil,
            "errorMessage": nil
          ])
        }
      } catch {
        camera.stop()
        dismiss(animated: true) {
          self.completion([
            "isSuccess": false,
            "frontImagePath": nil,
            "backImagePath": nil,
            "errorMessage": error.localizedDescription
          ])
        }
      }
    }
  }
}
