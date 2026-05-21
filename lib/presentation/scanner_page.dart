import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String? code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8.0,
              children: [
                if (code == null) ...[
                  const Text(
                    "Clique no botão abaixo para escanear um QR Code.",
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final scannedCode = await scan(context);

                      setState(() {
                        code = scannedCode;
                      });
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt_outlined),
                        SizedBox(width: 8.0),
                        Text("Escanear"),
                      ],
                    ),
                  ),
                ] else ...[
                  const Text("Código escaneado:", textAlign: TextAlign.center),
                  SelectableText(
                    code!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        code = null;
                      });
                    },
                    child: const Text("Escanear novamente"),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> scan(BuildContext context) async {
    final String? code = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScannerView()),
    );

    if (!context.mounted || code == null) {
      return null;
    }
    return code;
  }
}

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  late final MobileScannerController controller;
  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(formats: [BarcodeFormat.qrCode]);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      onDetect: (capture) {
        if (_hasScanned) {
          return;
        }

        final barcode = capture.barcodes.first;
        final String? code = barcode.rawValue;
        if (code != null) {
          _hasScanned = true;
          controller.stop();
          debugPrint("Qr encontrado: $code");
          Navigator.pop(context, code);
        }
      },
    );
  }
}
