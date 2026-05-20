import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatelessWidget {
  ScannerPage({super.key});

  final MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner')),
      body: Center(
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
              const Text(
                "Clique no botão abaixo para escanear um QR Code.",
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: () async {
                  await scan(context);
                },
                child: const Text("Escanear"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> scan(BuildContext context) async {
    final String? code = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScannerView(controller: controller),
      ),
    );

    //TODO: VALIDATE QR CODE

    if (code != null && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('QR: $code')));
    }
  }
}

class ScannerView extends StatelessWidget {
  const ScannerView({super.key, required this.controller});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      onDetect: (capture) {
        final barcode = capture.barcodes.first;
        final String? code = barcode.rawValue;
        if (code != null) {
          print("Qr encontrado: $code");
          Navigator.pop(context, code);
        }
      },
    );
  }
}
