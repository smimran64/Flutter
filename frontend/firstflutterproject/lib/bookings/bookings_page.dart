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
  final phoneCtrl = TextEditingController(); // Customer phone
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
  final contactPhoneCtrl = TextEditingController(); // Hotel contact
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
    final checkIn = checkInCtrl.text.trim();
    final checkOut = checkOutCtrl.text.trim();

    if (contractPerson.isEmpty || contactPhone.isEmpty || checkIn.isEmpty || checkOut.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    final bookingData = {
      "contractPersonName": contractPerson,
      "phone": contactPhone,
      "checkIn": checkIn,
      "checkOut": checkOut,
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
        const SnackBar(content: Text("Booking created & invoice generated!")),
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

    pw.Widget section(String title, PdfColor bgColor, List<pw.Widget> children) {
      return pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 10),
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          color: bgColor,
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            ...children,
          ],
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              gradient: pw.LinearGradient(colors: [PdfColors.blue, PdfColors.purpleAccent]),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Center(
              child: pw.Column(
                children: [
                  pw.Text("🏨 ${booking['hotelName']}", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                  pw.SizedBox(height: 4),
                  pw.Text(booking['hotelAddress'], style: pw.TextStyle(color: PdfColors.white)),
                  pw.Text("Thank you for booking with us!", style: pw.TextStyle(color: PdfColors.white)),
                ],
              ),
            ),
          ),
          pw.SizedBox(height: 15),
          section("Customer Information", PdfColors.lightBlue100, [
            pw.Text("Name: ${booking['customerName']}"),
            pw.Text("Email: ${booking['email']}"),
            pw.Text("Phone: ${booking['phone']}"),
            pw.Text("Address: ${booking['address']}"),
          ]),
          section("Hotel Information", PdfColors.orange100, [
            pw.Text("Name: ${booking['hotelName']}"),
            pw.Text("Address: ${booking['hotelAddress']}"),
          ]),
          section("Room Information", PdfColors.green100, [
            pw.Text("Room Type: ${booking['roomType']}"),
            pw.Text("Adults: ${booking['adults']}"),
            pw.Text("Children: ${booking['children']}"),
            pw.Text("Price per Night: \$${booking['pricePerNight']}"),
            pw.Text("Number of Rooms: ${booking['numRooms']}"),
            pw.Text("Check-in: ${booking['checkIn']}"),
            pw.Text("Check-out: ${booking['checkOut']}"),
            pw.Text("Contract Person: ${booking['contractPerson']}"),
            pw.Text("Phone: ${booking['hotelPhone']}"),
          ]),
          section("Payment Details", PdfColors.pink100, [
            pw.Text("Total Amount: \$${booking['totalAmount']}"),
            pw.Text("Advance Paid: \$${booking['advancePaid']}"),
            pw.Text("Due Amount: \$${(booking['totalAmount'] - booking['advancePaid']).toStringAsFixed(2)}"),
          ]),
          pw.SizedBox(height: 20),
          pw.Center(
            child: pw.Text(
              "We look forward to hosting you. Safe travels!",
              style: pw.TextStyle(fontStyle: pw.FontStyle.italic, color: PdfColors.grey700),
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
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
                _inputField("Check-in (YYYY-MM-DD)", checkInCtrl, readOnly: true),
                _inputField("Check-out (YYYY-MM-DD)", checkOutCtrl, readOnly: true),
                _inputField("Total Amount", totalCtrl, readOnly: true),
                _inputField("Due Amount", dueAmountCtrl, readOnly: true),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                  icon: const Icon(Icons.add_circle, color: Colors.white),
                  label: const Text("Create Booking"),
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
