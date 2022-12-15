import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

class NormalPrintController extends GetxController {
  generatePdf() async {
    const title = 'eclectify Demo';
    await Printing.layoutPdf(onLayout: (format) => _generatePdf(format, title));
  }

  
  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    print("works!");
    List<int> abc = [1,2,3,4,5];


    pdf.addPage(
      pw.Page(
        pageFormat: format,
        margin: EdgeInsets.all(20.0),
        build: (context) {
          return pw.Column(
            children: [
              pw.Container(
                width: double.infinity,
                height: 500,
                child: pw.Column(
                  children: [
                    pw.Text(
                      "Makanan Kesukaan",
                    ),
                    pw.SizedBox(height: 40),
                    for ( var i in abc ) pw.Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        pw.Text("Makanan $i"),
                        pw.Text("Rp. 20.000"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
