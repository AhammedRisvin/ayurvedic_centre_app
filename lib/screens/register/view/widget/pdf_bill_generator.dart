import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfBillGenerator {
  static Future<Uint8List> generateBill({
    required String patientName,
    required String address,
    required String whatsappNumber,
    required String bookingDate,
    required String bookingTime,
    required String treatmentDate,
    required String treatmentTime,
    required List<TreatmentItem> treatments,
    required double totalAmount,
    required double discount,
    required double advance,
    required double balance,
    required String branchName,
    required String branchAddress,
    required String branchPhone,
    required String branchEmail,
    required String gstNumber,
  }) async {
    final pdf = pw.Document();

    // Load images
    final logoImage = await _loadImage('assets/images/logoPng.png');
    final signImage = await _loadImage('assets/images/signPng.png');
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(30),
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // Background Watermark
              pw.Positioned.fill(
                child: pw.Center(
                  child: pw.Opacity(
                    opacity: 0.1, // faint background logo
                    child: pw.Image(logoImage, width: 400, height: 400),
                  ),
                ),
              ),

              // Foreground Content
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildHeader(logoImage, branchName, branchAddress, branchPhone, branchEmail, gstNumber),
                  pw.SizedBox(height: 10),
                  _buildDivider(),
                  pw.SizedBox(height: 20),

                  _buildPatientDetails(
                    patientName,
                    address,
                    whatsappNumber,
                    bookingDate,
                    bookingTime,
                    treatmentDate,
                    treatmentTime,
                  ),
                  pw.SizedBox(height: 10),
                  _buildDottedDivider(),
                  pw.SizedBox(height: 20),

                  _buildSectionTitle('Treatment Details'),
                  pw.SizedBox(height: 10),
                  _buildTreatmentTable(treatments),
                  pw.SizedBox(height: 10),
                  _buildDottedDivider(),
                  pw.SizedBox(height: 20),

                  _buildPaymentSummary(totalAmount, discount, advance, balance),

                  pw.Spacer(),
                  _buildFooter(signImage),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static Future<pw.ImageProvider> _loadImage(String path) async {
    final data = await rootBundle.load(path);
    return pw.MemoryImage(data.buffer.asUint8List());
  }

  // Header
  static pw.Widget _buildHeader(
    pw.ImageProvider logo,
    String branchName,
    String address,
    String phone,
    String email,
    String gstNumber,
  ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(width: 80, height: 80, child: pw.Image(logo)),
        pw.SizedBox(width: 20),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(branchName.toUpperCase(), style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              pw.Text(address, style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
              pw.Text('e-mail: $email', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
              pw.Text('Mob: $phone', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
              pw.Text('GST No: $gstNumber', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  // Section Title (green)
  static pw.Widget _buildSectionTitle(String title) {
    return pw.Text(
      title,
      style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#00A64F")),
    );
  }

  // Patient Details
  static pw.Widget _buildPatientDetails(
    String name,
    String address,
    String whatsapp,
    String bookingDate,
    String bookingTime,
    String treatmentDate,
    String treatmentTime,
  ) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "Patient Details",
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#00A64F")),
          ),
          pw.SizedBox(height: 8),

          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Left column
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("Name", name),
                    pw.SizedBox(height: 10),
                    _buildDetailRow("Address", address),
                    pw.SizedBox(height: 10),
                    _buildDetailRow("WhatsApp Number", whatsapp),
                  ],
                ),
              ),
              pw.SizedBox(width: 10),
              // Right column
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("Booked On", "$bookingDate  |  $bookingTime"),
                    pw.SizedBox(height: 10),
                    _buildDetailRow("Treatment Date", treatmentDate),
                    pw.SizedBox(height: 10),
                    _buildDetailRow("Treatment Time", treatmentTime),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildDetailRow(String label, String value) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "$label: ",
          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.black),
        ),
        pw.Expanded(
          child: pw.Text(value, style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
        ),
      ],
    );
  }

  // Treatment Table
  static pw.Widget _buildTreatmentTable(List<TreatmentItem> treatments) {
    return pw.Table(
      border: null,
      columnWidths: {
        0: pw.FlexColumnWidth(3),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(2),
        3: pw.FlexColumnWidth(2),
        4: pw.FlexColumnWidth(2),
      },
      children: [
        pw.TableRow(
          children: [
            _buildTableHeader('Treatment'),
            _buildTableHeader('Price'),
            _buildTableHeader('Male'),
            _buildTableHeader('Female'),
            _buildTableHeader('Total'),
          ],
        ),
        ...treatments.map(
          (treatment) => pw.TableRow(
            children: [
              _buildTableCell(treatment.name),
              _buildTableCell('₹${treatment.price.toStringAsFixed(0)}'),
              _buildTableCell(treatment.maleCount.toString(), center: true),
              _buildTableCell(treatment.femaleCount.toString(), center: true),
              _buildTableCell('₹${treatment.total.toStringAsFixed(0)}', bold: true),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTableHeader(String text) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColor.fromHex("#00A64F")),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _buildTableCell(String text, {bool center = false, bool bold = false}) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 10, fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal),
        textAlign: center ? pw.TextAlign.center : pw.TextAlign.left,
      ),
    );
  }

  static pw.Widget _buildPaymentSummary(double totalAmount, double discount, double advance, double balance) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSummaryRow('Total Amount', '₹${totalAmount.toStringAsFixed(0)}'),
          _buildSummaryRow('Discount', '₹${discount.toStringAsFixed(0)}'),
          _buildSummaryRow('Advance', '₹${advance.toStringAsFixed(0)}'),
          // pw.SizedBox(height: 6),
          // _buildDottedDivider(),
          pw.SizedBox(height: 6),
          _buildSummaryRow('Balance', '₹${balance.toStringAsFixed(0)}', bold: true, big: true),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryRow(
    String label,
    String value, {
    bool bold = false,
    bool green = false,
    bool big = false,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: big ? 13 : 11,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: green ? PdfColor.fromHex("#00A64F") : PdfColors.black,
          ),
          textAlign: pw.TextAlign.start,
        ),
        pw.SizedBox(width: 10),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: big ? 13 : 12,
            fontWeight: pw.FontWeight.bold,
            color: green ? PdfColor.fromHex("#00A64F") : PdfColors.black,
          ),
          textAlign: pw.TextAlign.start,
        ),
      ],
    );
  }

  // Footer
  static pw.Widget _buildFooter(pw.ImageProvider signImage) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text('Thank you for choosing us', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Text('Your well-being is our commitment', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
          pw.Text('We are honored you trusted us', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),

          pw.SizedBox(height: 20),

          // Signature image
          pw.Container(height: 50, width: 120, child: pw.Image(signImage, fit: pw.BoxFit.contain)),

          pw.SizedBox(height: 5),
          pw.Text('Authorized Signature', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),

          pw.SizedBox(height: 25),
          pw.Text(
            '"Booking amount is non-refundable. Please arrive on time for your treatment"',
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Solid Divider
  static pw.Widget _buildDivider() {
    return pw.Container(height: 1, color: PdfColors.grey400);
  }

  // Dotted Divider
  static pw.Widget _buildDottedDivider() {
    return pw.LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints!.constrainWidth();
        const dashWidth = 3.0;
        const dashSpace = 3.0;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();

        return pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return pw.Container(width: dashWidth, height: 1, color: PdfColors.grey400);
          }),
        );
      },
    );
  }
}

class TreatmentItem {
  final String name;
  final double price;
  final int maleCount;
  final int femaleCount;
  final double total;

  TreatmentItem({
    required this.name,
    required this.price,
    required this.maleCount,
    required this.femaleCount,
    required this.total,
  });
}

class PdfService {
  static Future<void> generateAndSaveBill({
    required Map<String, dynamic> patientData,
    required List<Map<String, dynamic>> treatmentsList,
  }) async {
    try {
      List<TreatmentItem> treatments = treatmentsList.map((treatment) {
        return TreatmentItem(
          name: treatment['name'] ?? '',
          price: (treatment['price'] ?? 0).toDouble(),
          maleCount: treatment['male_count'] ?? 0,
          femaleCount: treatment['female_count'] ?? 0,
          total: (treatment['total'] ?? 0).toDouble(),
        );
      }).toList();

      final pdfBytes = await PdfBillGenerator.generateBill(
        patientName: patientData['name'] ?? '',
        address: patientData['address'] ?? '',
        whatsappNumber: patientData['phone'] ?? '',
        bookingDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
        bookingTime: DateFormat('hh:mm a').format(DateTime.now()),
        treatmentDate: patientData['treatment_date'] ?? '',
        treatmentTime: patientData['treatment_time'] ?? '',
        treatments: treatments,
        totalAmount: (patientData['total_amount'] ?? 0).toDouble(),
        discount: (patientData['discount_amount'] ?? 0).toDouble(),
        advance: (patientData['advance_amount'] ?? 0).toDouble(),
        balance: (patientData['balance_amount'] ?? 0).toDouble(),
        branchName: 'KUMARAKOM',
        branchAddress: 'Cheepunkal P.O. Kumarakom, Kottayam, Kerala - 686563',
        branchPhone: '+91 9876543210 | +91 9786543210',
        branchEmail: 'unknown@gmail.com',
        gstNumber: '32AABCU9603R1ZW',
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name: 'amritha_bill_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      print('Error generating PDF: $e');
      rethrow;
    }
  }
}
