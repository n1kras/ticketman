import 'package:flutter/material.dart';
import 'package:ticketman_scan/presentation/scanner_page.dart';
import 'package:ticketman_scan/themes/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticketman Scanner',
      theme: AppTheme.dark,
      home: ScannerPage(),
    );
  }
}