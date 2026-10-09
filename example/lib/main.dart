import 'package:doc_scanner_sdk/doc_scanner_sdk.dart';
import 'package:flutter/material.dart';

void main() => runApp(const DocScannerExampleApp());

class DocScannerExampleApp extends StatelessWidget {
  const DocScannerExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ScanHomePage(),
    );
  }
}

class ScanHomePage extends StatefulWidget {
  const ScanHomePage({super.key});

  @override
  State<ScanHomePage> createState() => _ScanHomePageState();
}

class _ScanHomePageState extends State<ScanHomePage> {
  final _scanner = DocScanner();
  String _status = 'Ready — native SDK draws the white crop rectangle.';

  Future<void> _scan() async {
    final granted = await _scanner.requestCameraPermission();
    if (!granted) {
      setState(() => _status = 'Camera permission denied');
      return;
    }
    final result = await _scanner.scanDocument(
      const ScanOptions(showCropOverlay: true),
    );
    setState(() {
      _status = result.isSuccess
          ? 'Front: ${result.frontImagePath}\nBack: ${result.backImagePath}'
          : 'Failed: ${result.errorMessage}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DocScanner Example')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_status),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _scan,
              child: const Text('Scan document'),
            ),
          ],
        ),
      ),
    );
  }
}
