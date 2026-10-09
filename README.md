# doc_scanner_sdk

Flutter **wrapper** for the DocScanner native SDKs.

> Camera preview, the **white crop rectangle**, and crop-on-capture live in
> native code. This package only bridges those APIs.

| Platform | Native SDK | Wiring |
|----------|------------|--------|
| Android | [DocScannerSDK-Android](https://github.com/Tareq-Ghassan/DocScannerSDK-Android) | JitPack dependency |
| iOS | [DocScannerSDK-iOS](https://github.com/Tareq-Ghassan/DocScannerSDK-iOS) | Source snapshot under `ios/` |
| macOS | [DocScannerSDK-macOS](https://github.com/Tareq-Ghassan/DocScannerSDK-macOS) | Source snapshot under `macos/` |
| Web | MediaDevices + canvas | Dart (`doc_scanner_sdk_web.dart`) |

## Install

```yaml
dependencies:
  doc_scanner_sdk: ^1.0.0
```

## Usage

```dart
import 'package:doc_scanner_sdk/doc_scanner_sdk.dart';

final scanner = DocScanner();
if (await scanner.requestCameraPermission()) {
  final result = await scanner.scanDocument(
    const ScanOptions(showCropOverlay: true),
  );
  print(result.frontImagePath);
}
```

## Architecture rule

Do **not** reimplement crop UI in Dart for mobile. Change Android/iOS SDKs,
then bump the JitPack pin or refresh the iOS/macOS source snapshot.

## Pana

```bash
cd flutter
../check-pana-score.sh
```

CI enforces a 160 score before pub.dev publish.

## License

MIT
