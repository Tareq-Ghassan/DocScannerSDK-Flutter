import FlutterMacOS
import Foundation

public class DocScannerSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "doc_scanner_sdk", binaryMessenger: registrar.messenger)
    registrar.addMethodCallDelegate(DocScannerSdkPlugin(), channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getVersion": result(DocScannerSDK.version)
    case "hasCameraPermission", "requestCameraPermission": result(true)
    case "scanDocument":
      result([
        "isSuccess": false,
        "errorMessage": "macOS capture UI uses DocScannerCamera — wire AppKit host next",
        "frontImagePath": nil,
        "backImagePath": nil
      ])
    default: result(FlutterMethodNotImplemented)
    }
  }
}
