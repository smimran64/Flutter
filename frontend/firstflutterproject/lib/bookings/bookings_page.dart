import 'dart:convert';
import 'package:firstflutterproject/service/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  final _formKey = GlobalKey<FormState>();
  final BookingService bookingService = BookingService();

  // Controllers
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final hotelNameCtrl = TextEditingController();
  final hotelAddressCtrl = TextEditingController();
  final roomTypeCtrl = TextEditingController();
  final adultsCtrl = TextEditingController();
  final childrenCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final numRoomsCtrl = TextEditingController();
  final checkInCtrl = TextEditingController();
  final checkOutCtrl = TextEditingController();
  final contactPersonCtrl = TextEditingController();
  final contactPhoneCtrl = TextEditingController();
  final totalCtrl = TextEditingController();
  final advanceCtrl = TextEditingController();
  final dueAmountCtrl = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBookingData();

    numRoomsCtrl.addListener(_updateTotalAmount);
    priceCtrl.addListener(_updateTotalAmount);
    advanceCtrl.addListener(_validateAdvance);
  }

  void _updateTotalAmount() {
    double price = double.tryParse(priceCtrl.text) ?? 0;
    int numRooms = int.tryParse(numRoomsCtrl.text) ?? 1;
    double total = price * numRooms;
    totalCtrl.text = total.toStringAsFixed(2);
    _validateAdvance();
  }

  void _validateAdvance() {
    double total = double.tryParse(totalCtrl.text) ?? 0;
    double advance = double.tryParse(advanceCtrl.text) ?? 0;

    if (advance > total) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Advance cannot be more than total amount!")),
      );
      advanceCtrl.text = total.toStringAsFixed(2);
    }

    double due = total - advance;
    dueAmountCtrl.text = due.toStringAsFixed(2);
  }

  Future<void> _loadBookingData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    hotelNameCtrl.text = prefs.getString('selectedHotel') ?? '';
    hotelAddressCtrl.text = prefs.getString('selectedHotelAddress') ?? '';
    checkInCtrl.text = prefs.getString('checkIn') ?? '';
    checkOutCtrl.text = prefs.getString('checkOut') ?? '';
    roomTypeCtrl.text = prefs.getString('selectedRoomType') ?? '';
    adultsCtrl.text = prefs.getString('selectedAdults') ?? '';
    childrenCtrl.text = prefs.getString('selectedChildren') ?? '';
    priceCtrl.text = prefs.getString('selectedPrice') ?? '';

    nameCtrl.text = prefs.getString('customerName') ?? '';
    emailCtrl.text = prefs.getString('customerEmail') ?? '';
    phoneCtrl.text = prefs.getString('customerPhone') ?? '';
    addressCtrl.text = prefs.getString('customerAddress') ?? '';

    setState(() {});
  }

  Future<void> _createBooking() async {
    final prefs = await SharedPreferences.getInstance();

    final int roomId = prefs.getInt('roomId') ?? 0;
    final int hotelId = prefs.getInt('hotelId') ?? 0;
    final int customerId = prefs.getInt('customerId') ?? 0;

    if (!_formKey.currentState!.validate()) return;

    final contractPerson = contactPersonCtrl.text.trim();
    final contactPhone = contactPhoneCtrl.text.trim();

    if (contractPerson.isEmpty || contactPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    final bookingData = {
      "contractPersonName": contractPerson,
      "phone": contactPhone,
      "checkIn": checkInCtrl.text,
      "checkOut": checkOutCtrl.text,
      "numberOfRooms": int.tryParse(numRoomsCtrl.text) ?? 1,
      "discountRate": 0.0,
      "advanceAmount": double.tryParse(advanceCtrl.text) ?? 0.0,
      "totalAmount": double.tryParse(totalCtrl.text) ?? 0.0,
      "dueAmount": double.tryParse(dueAmountCtrl.text) ?? 0.0,
      "roomdto": {"id": roomId},
      "hoteldto": {"id": hotelId},
      "customerdto": {"id": customerId},
    };

    final pdfData = {
      ...bookingData,
      "hotelName": hotelNameCtrl.text,
      "hotelAddress": hotelAddressCtrl.text,
      "customerName": nameCtrl.text,
      "email": emailCtrl.text,
      "address": addressCtrl.text,
      "roomType": roomTypeCtrl.text,
      "adults": adultsCtrl.text,
      "children": childrenCtrl.text,
      "pricePerNight": priceCtrl.text,
      "numRooms": numRoomsCtrl.text,
      "contractPerson": contactPersonCtrl.text,
      "hotelPhone": contactPhoneCtrl.text,
      "advancePaid": double.tryParse(advanceCtrl.text) ?? 0.0,
    };

    try {
      final response = await bookingService.createBooking(bookingData);
      await _generateInvoicePdf(pdfData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Booking created & invoice generated!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _generateInvoicePdf(Map<String, dynamic> booking) async {
    final pdf = pw.Document();

    final hotelName = booking['hotelName'] ?? "Hotel";
    final invoiceDate = DateTime.now();
    final invoiceId = "INV-${invoiceDate.millisecondsSinceEpoch}";

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [

          // Header
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.deepPurple),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  height: 60,
                  width: 60,
                  color: PdfColors.grey300,
                  child: pw.Center(
                    child: pw.Text("Logo", style: pw.TextStyle(fontSize: 12, color: PdfColors.grey)),
                  ),
                ),
                pw.SizedBox(width: 12),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(hotelName, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                      pw.Text(booking['hotelAddress']),
                      pw.SizedBox(height: 6),
                      pw.Text("Invoice ID: $invoiceId"),
                      pw.Text("Date: ${invoiceDate.toLocal().toString().split(' ')[0]}"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 20),
          _infoSection("Customer Details", {
            "Name": booking['customerName'],
            "Email": booking['email'],
            "Phone": booking['phone'],
            "Address": booking['address'],
          }),

          _infoSection("Booking Details", {
            "Room Type": booking['roomType'],
            "Adults": booking['adults'],
            "Children": booking['children'],
            "Price/Night": "\$${booking['pricePerNight']}",
            "Number of Rooms": booking['numRooms'],
            "Check-in": booking['checkIn'],
            "Check-out": booking['checkOut'],
          }),

          _infoSection("Hotel Contact", {
            "Contact Person": booking['contractPerson'],
            "Phone": booking['hotelPhone'],
          }),

          _infoSection("Payment Summary", {
            "Total Amount": "\$${booking['totalAmount']}",
            "Advance Paid": "\$${booking['advancePaid']}",
            "Due Amount": "\$${(booking['totalAmount'] - booking['advancePaid']).toStringAsFixed(2)}",
          }),

          pw.SizedBox(height: 20),

          pw.Center(
            child: pw.Text(
              "Thank you for choosing $hotelName. We look forward to your stay!",
              style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 12, color: PdfColors.grey700),
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  pw.Widget _infoSection(String title, Map<String, String> data) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Table(
            columnWidths: {
              0: const pw.FractionColumnWidth(0.4),
              1: const pw.FractionColumnWidth(0.6),
            },
            children: data.entries.map((e) {
              return pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Text("${e.key}:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Text(e.value),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Booking"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _inputField("Contract Person", contactPersonCtrl),
                _inputField("Phone", contactPhoneCtrl),
                _inputField("Number of Rooms", numRoomsCtrl),
                _inputField("Advance Paid", advanceCtrl),
                const Divider(height: 24),
                _inputField("Customer Name", nameCtrl, readOnly: true),
                _inputField("Email", emailCtrl, readOnly: true),
                _inputField("Phone", phoneCtrl, readOnly: true),
                _inputField("Address", addressCtrl, readOnly: true),
                _inputField("Hotel Name", hotelNameCtrl, readOnly: true),
                _inputField("Hotel Address", hotelAddressCtrl, readOnly: true),
                _inputField("Room Type", roomTypeCtrl, readOnly: true),
                _inputField("Adults", adultsCtrl, readOnly: true),
                _inputField("Children", childrenCtrl, readOnly: true),
                _inputField("Price per Night", priceCtrl, readOnly: true),
                _inputField("Check-in", checkInCtrl, readOnly: true),
                _inputField("Check-out", checkOutCtrl, readOnly: true),
                _inputField("Total Amount", totalCtrl, readOnly: true),
                _inputField("Due Amount", dueAmountCtrl, readOnly: true),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: const Text("Confirm Booking"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  ),
                  onPressed: _createBooking,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController ctrl, {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: ctrl,
        readOnly: readOnly,
        keyboardType: (label.contains("Number") || label.contains("Amount") || label.contains("Adults") || label.contains("Children"))
            ? TextInputType.number
            : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => (value == null || value.isEmpty) ? "Required field" : null,
      ),
    );
  }
}
