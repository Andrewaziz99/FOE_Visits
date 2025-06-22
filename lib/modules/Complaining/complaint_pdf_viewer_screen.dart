import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:printing/printing.dart';

class ComplaintPdfViewerScreen extends StatelessWidget {
  final String filePath;
  const ComplaintPdfViewerScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عرض الشكوى'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () async {
              final file = File(filePath);
              final bytes = await file.readAsBytes();
              await Printing.layoutPdf(onLayout: (format) async => bytes);
            },
          ),
        ],
      ),
      body: SfPdfViewer.file(File(filePath)),
    );
  }
}

