

import 'package:firstflutterproject/service/booking_service.dart';

import 'package:flutter/material.dart';

import 'package:pdf/pdf.dart';

import 'package:printing/printing.dart';

import 'package:pdf/widgets.dart' as pw;

import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart'; // For modern fonts

import 'package:flutter_animate/flutter_animate.dart'; // For subtle UI animation

// --- Modern Color Palette for Booking Form ---

const Color kBookingPrimary = Color(0xFF00BFA5); // Teal

const Color kBookingAccent = Color(0xFFFF9800); // Orange

const Color kBookingBackground = Color(0xFFF0F8FF); // Light Blue/White

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

  @override
  void dispose() {
    numRoomsCtrl.removeListener(_updateTotalAmount);

    priceCtrl.removeListener(_updateTotalAmount);

    advanceCtrl.removeListener(_validateAdvance);

    // Dispose controllers to prevent memory leaks

    nameCtrl.dispose();

    emailCtrl.dispose();

    phoneCtrl.dispose();

    addressCtrl.dispose();

    hotelNameCtrl.dispose();

    hotelAddressCtrl.dispose();

    roomTypeCtrl.dispose();

    adultsCtrl.dispose();

    childrenCtrl.dispose();

    priceCtrl.dispose();

    numRoomsCtrl.dispose();

    checkInCtrl.dispose();

    checkOutCtrl.dispose();

    contactPersonCtrl.dispose();

    contactPhoneCtrl.dispose();

    totalCtrl.dispose();

    advanceCtrl.dispose();

    dueAmountCtrl.dispose();

    super.dispose();
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
        const SnackBar(
          content: Text("❌ Advance cannot be more than total amount!"),
        ),
      );

      // Temporarily remove listener to avoid infinite loop when correcting text

      advanceCtrl.removeListener(_validateAdvance);

      advanceCtrl.text = total.toStringAsFixed(2);

      // Re-add listener

      WidgetsBinding.instance.addPostFrameCallback((_) {
        advanceCtrl.addListener(_validateAdvance);
      });

      advance = total; // Use corrected advance for due calculation
    }

    double due = total - advance;

    dueAmountCtrl.text = due.toStringAsFixed(2);
  }

  Future<void> _loadBookingData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    hotelNameCtrl.text = prefs.getString('selectedHotel') ?? '';

    hotelAddressCtrl.text = prefs.getString('selectedHotelAddress') ?? '';

    checkInCtrl.text = prefs.getString('checkIn') ?? ''; // ex: "2025-10-20"

    checkOutCtrl.text = prefs.getString('checkOut') ?? '';

    roomTypeCtrl.text = prefs.getString('selectedRoomType') ?? '';

    adultsCtrl.text = prefs.getString('selectedAdults') ?? '';

    childrenCtrl.text = prefs.getString('selectedChildren') ?? '';

    priceCtrl.text = prefs.getString('selectedPrice') ?? '';

    nameCtrl.text = prefs.getString('customerName') ?? '';

    emailCtrl.text = prefs.getString('customerEmail') ?? '';

    phoneCtrl.text = prefs.getString('customerPhone') ?? '';

    addressCtrl.text = prefs.getString('customerAddress') ?? '';

    // Important: Call update after loading to set initial total/due

    _updateTotalAmount();

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  // --- PDF generation methods (ADJUSTED FOR SINGLE PAGE) ---

  Future<void> _generateInvoicePdf(Map<String, dynamic> booking) async {
    final pdf = pw.Document();

    final hotelName = booking['hotelName'] ?? "Hotel";

    final invoiceDate = DateTime.now();

    final invoiceId = "INV-${invoiceDate.millisecondsSinceEpoch}";

    final totalAmount =
        double.tryParse(booking['totalAmount'].toString()) ?? 0.0;

    final advancePaid =
        double.tryParse(booking['advancePaid'].toString()) ?? 0.0;

    final dueAmount = (totalAmount - advancePaid).toStringAsFixed(2);

    // --- Custom Colors for PDF ---

    const PdfColor primaryColor = PdfColor.fromInt(0xFF00BFA5); // Teal

    const PdfColor accentColor = PdfColor.fromInt(0xFFFF9800); // Orange

    // Changed to pw.Page for single-page generation

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,

        margin: const pw.EdgeInsets.all(30),

        build: (context) =>
            // Use a Column here as pw.Page.build requires a single widget
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,

              children: [
                // --- HEADER: Colorful and Modern ---
                pw.Container(
                  padding: const pw.EdgeInsets.all(15),

                  decoration: pw.BoxDecoration(
                    color: primaryColor,

                    borderRadius: pw.BorderRadius.circular(10),

                    boxShadow: [
                      pw.BoxShadow(color: PdfColors.grey500, blurRadius: 5),
                    ],
                  ),

                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,

                        children: [
                          pw.Text(
                            "HOTEL BOOKING INVOICE",
                            style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                            ),
                          ),

                          // Corrected withOpacity usage
                          pw.Text(
                            "Booking Confirmation & Payment Summary",

                            style: pw.TextStyle(
                              fontSize: 12,

                              color: PdfColor(
                                1,
                                1,
                                1,
                                0.8,
                              ), // white with 80% opacity
                            ),
                          ),
                        ],
                      ),

                      pw.Text(
                        "#$invoiceId",
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 25),

                // --- Section: Hotel & Date Info ---
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

                  crossAxisAlignment: pw.CrossAxisAlignment.start,

                  children: [
                    // Hotel Details
                    _buildAddressBlock(
                      "Billed By:",
                      hotelName,
                      booking['hotelAddress'],
                      primaryColor,
                    ),

                    // Invoice Details
                    _buildAddressBlock(
                      "Invoice Date:",
                      "Date: ${invoiceDate.toLocal().toString().split(' ')[0]}",
                      "Contact: ${booking['hotelPhone']}",
                      primaryColor,
                      alignRight: true,
                    ),
                  ],
                ),

                pw.SizedBox(height: 20),

                // --- Section: Customer Details (with colored bar) ---
                _infoSection("Customer & Contact Details", {
                  "Customer Name": booking['customerName'],

                  "Email": booking['email'],

                  "Phone": booking['phone'],

                  "Address": booking['address'],

                  "Booking Contact": booking['contractPerson'],

                  "Contact Phone": booking['hotelPhone'],
                }, primaryColor),

                // --- Section: Booking Details (with colored bar) ---
                _infoSection("Reservation Summary", {
                  "Hotel Name": hotelName,

                  "Room Type": booking['roomType'],

                  "Check-in Date": booking['checkIn'],

                  "Check-out Date": booking['checkOut'],

                  "Adults / Children":
                      "${booking['adults']} / ${booking['children']}",

                  "Number of Rooms": booking['numRooms'],

                  "Price per Night": "\$${booking['pricePerNight']}",
                }, accentColor),

                pw.SizedBox(height: 20),

                // --- Section: Payment Summary (Pricing Table) ---
                _paymentSummaryTable(
                  totalAmount: totalAmount,

                  advancePaid: advancePaid,

                  dueAmount: dueAmount,

                  primaryColor: primaryColor,

                  accentColor: accentColor,
                ),

                pw.SizedBox(height: 30),

                // --- Footer/Signature ---
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,

                      children: [
                        pw.Divider(
                          color: PdfColors.grey500,
                          thickness: 1,
                          height: 10,
                        ),

                        pw.Text(
                          "Customer Signature",
                          style: const pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ],
                    ),

                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,

                      children: [
                        pw.Divider(
                          color: primaryColor,
                          thickness: 1,
                          height: 10,
                        ),

                        pw.Text(
                          "Hotel Management Signature",
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                pw.SizedBox(height: 20),

                pw.Center(
                  child: pw.Text(
                    "Thank you for choosing $hotelName. We look forward to providing you with an excellent stay!",

                    style: pw.TextStyle(
                      fontStyle: pw.FontStyle.italic,
                      fontSize: 12,
                      color: PdfColors.grey700,
                    ),
                  ),
                ),
              ],
            ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  // --- PDF Helper: Info Section (UNCHANGED) ---

  pw.Widget _infoSection(
    String title,
    Map<String, String> data,
    PdfColor headerColor,
  ) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 15),

      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),

        borderRadius: pw.BorderRadius.circular(8),
      ),

      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,

        children: [
          // Header Bar
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),

            decoration: pw.BoxDecoration(
              color: headerColor,

              borderRadius: const pw.BorderRadius.only(
                topLeft: pw.Radius.circular(7),
                topRight: pw.Radius.circular(7),
              ),
            ),

            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
          ),

          // Data Table
          pw.Padding(
            padding: const pw.EdgeInsets.all(12),

            child: pw.Table(
              columnWidths: {
                0: const pw.FractionColumnWidth(0.35),

                1: const pw.FractionColumnWidth(0.65),
              },

              children: data.entries.map((e) {
                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),

                      child: pw.Text(
                        "${e.key}:",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ),

                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),

                      child: pw.Text(
                        e.value,
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // --- PDF Helper: Address Block (UNCHANGED) ---

  pw.Widget _buildAddressBlock(
    String title,
    String line1,
    String line2,
    PdfColor color, {
    bool alignRight = false,
  }) {
    return pw.Container(
      width: 200,

      child: pw.Column(
        crossAxisAlignment: alignRight
            ? pw.CrossAxisAlignment.end
            : pw.CrossAxisAlignment.start,

        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey700,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 5),

          // Use the non-nullable `color` parameter
          pw.Text(
            line1,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),

          pw.Text(
            line2,
            style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  // --- PDF Helper: Payment Summary Table (UNCHANGED) ---

  pw.Widget _paymentSummaryTable({
    required double totalAmount,

    required double advancePaid,

    required String dueAmount,

    required PdfColor primaryColor,

    required PdfColor accentColor,
  }) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),

        borderRadius: pw.BorderRadius.circular(8),
      ),

      child: pw.Column(
        children: [
          // Header Row
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 15, vertical: 8),

            decoration: pw.BoxDecoration(
              color: primaryColor,

              borderRadius: const pw.BorderRadius.only(
                topLeft: pw.Radius.circular(7),
                topRight: pw.Radius.circular(7),
              ),
            ),

            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

              children: [
                pw.Text(
                  "PAYMENT SUMMARY",
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ],
            ),
          ),

          // Data Rows
          _buildSummaryRow(
            "Total Booking Amount",
            "\$${totalAmount.toStringAsFixed(2)}",
            isTotal: false,
            color: primaryColor,
          ),

          _buildSummaryRow(
            "Advance Paid",
            "\$${advancePaid.toStringAsFixed(2)}",
            isTotal: false,
            color: accentColor,
          ),

          _buildSummaryRow(
            "BALANCE DUE",
            "\$$dueAmount",
            isTotal: true,
            color: accentColor,
          ),
        ],
      ),
    );
  }

  // --- PDF Helper: Summary Row (FINAL FIX for withOpacity error) ---

  pw.Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
    PdfColor? color,
  }) {
    // Determine background color safely

    final PdfColor rowBgColor = (isTotal && color != null)
        ? PdfColor(color.red / 255, color.green / 255, color.blue / 255, 0.1)
        : PdfColors.white;

    // Determine text color safely

    final PdfColor rowTextColor = (isTotal && color != null)
        ? color
        : PdfColors.black;

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 15, vertical: 10),

      decoration: pw.BoxDecoration(
        // Apply the calculated background color
        color: rowBgColor,

        border: pw.Border(
          bottom: const pw.BorderSide(color: PdfColors.grey200, width: 0.5),
        ),
      ),

      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

        children: [
          pw.Text(
            label,

            style: pw.TextStyle(
              fontSize: isTotal ? 14 : 12,

              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,

              color: rowTextColor, // Use the determined text color
            ),
          ),

          pw.Text(
            value,

            style: pw.TextStyle(
              fontSize: isTotal ? 14 : 12,

              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,

              color: rowTextColor, // Use the determined text color
            ),
          ),
        ],
      ),
    );
  }

  // --- END OF PDF HELPERS ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBookingBackground,

      appBar: AppBar(
        title: Text(
          "Confirm Your Booking",

          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        backgroundColor: kBookingPrimary,

        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),

        child: SingleChildScrollView(
          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                // --- Section 1: Contact Details (Required) ---
                _buildSectionTitle(
                  "Contact Person Details",
                  Icons.contact_mail_rounded,
                  kBookingPrimary,
                ),

                _inputField(
                  "Contract Person",
                  contactPersonCtrl,
                  required: true,
                ).animate().slideX(duration: 300.ms, begin: -0.1),

                _inputField(
                  "Phone",
                  contactPhoneCtrl,
                  required: true,
                ).animate().slideX(duration: 300.ms, begin: 0.1),

                const SizedBox(height: 15),

                // --- Section 2: Booking Summary & Final Inputs ---
                _buildSectionTitle(
                  "Booking Summary & Final Payment",
                  Icons.info_rounded,
                  kBookingAccent,
                ),

                _buildReadOnlySummary().animate().fadeIn(
                  duration: 500.ms,
                  delay: 300.ms,
                ),

                // Contains all remaining fields
                const SizedBox(height: 20),

                // --- Action Button ---
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            kBookingPrimary,
                          ),
                        ),
                      )
                    : ElevatedButton.icon(
                        icon: const Icon(
                          Icons.check_circle_outline_rounded,
                          color: Colors.white,
                        ),

                        label: Text(
                          "Confirm Booking & Generate Invoice",

                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: kBookingPrimary,

                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),

                          elevation: 5,
                        ),

                        onPressed: _createBooking,
                      ).animate().scale(
                        duration: 400.ms,
                        delay: 600.ms,
                        curve: Curves.easeOutBack,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widget: Section Title (UNCHANGED) ---

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 10),

      child: Row(
        children: [
          Icon(icon, color: color, size: 14),

          const SizedBox(width: 8),

          Text(
            title,

            style: GoogleFonts.poppins(
              fontSize: 18,

              fontWeight: FontWeight.bold,

              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget: Read-Only Summary Group (Field placement adjusted as requested) ---

  Widget _buildReadOnlySummary() {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(10),

        border: Border.all(color: kBookingAccent.withOpacity(0.5)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),

            blurRadius: 5,

            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        children: [
          // Customer Details (Read-Only)
          _inputField(
            "Customer Name",
            nameCtrl,
            readOnly: true,
            color: kBookingAccent,
          ),

          _inputField("Email", emailCtrl, readOnly: true),

          _inputField("Phone", phoneCtrl, readOnly: true),

          // Hotel Details (Read-Only)
          _inputField(
            "Hotel Name",
            hotelNameCtrl,
            readOnly: true,
            color: kBookingAccent,
          ),

          _inputField("Room Type", roomTypeCtrl, readOnly: true),

          _inputField("Adults", adultsCtrl, readOnly: true),

          _inputField("Children", childrenCtrl, readOnly: true),

          _inputField("Price/Night", priceCtrl, readOnly: true),

          _inputField("Check-in", checkInCtrl, readOnly: true),

          _inputField("Check-out", checkOutCtrl, readOnly: true),

          // --- MOVED EDITABLE FIELDS HERE (as requested) ---
          _inputField(
            "Number of Rooms",
            numRoomsCtrl,
            required: true,
            color: kBookingPrimary,
          ),

          _inputField(
            "Advance Paid (\$)",
            advanceCtrl,
            required: true,
            color: kBookingPrimary,
          ),

          // --- Final Calculated Amounts (Read-Only) ---
          _inputField(
            "Total Amount",
            totalCtrl,
            readOnly: true,
            color: kBookingAccent,
          ),

          _inputField(
            "Due Amount",
            dueAmountCtrl,
            readOnly: true,
            color: kBookingAccent,
          ),
        ],
      ),
    );
  }

  // --- The Input Field method (UNCHANGED) ---

  Widget _inputField(
    String label,
    TextEditingController ctrl, {
    bool readOnly = false,
    bool required = false,
    Color? color,
  }) {
    Color fieldColor = color ?? kBookingPrimary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      child: TextFormField(
        controller: ctrl,

        readOnly: readOnly,

        keyboardType:
            (label.contains("Number") ||
                label.contains("Amount") ||
                label.contains("Paid") ||
                label.contains("Price"))
            ? TextInputType.number
            : TextInputType.text,

        decoration: InputDecoration(
          labelText: label,

          labelStyle: GoogleFonts.poppins(color: fieldColor.withOpacity(0.7)),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),

            borderSide: BorderSide(color: fieldColor.withOpacity(0.5)),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),

            borderSide: BorderSide(color: fieldColor, width: 2),
          ),

          // Use a lighter fill color for read-only fields
          fillColor: readOnly ? fieldColor.withOpacity(0.05) : Colors.white,

          filled: true,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
        ),

        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return "This field is required";
          }

          return null;
        },

        style: GoogleFonts.poppins(
          fontWeight: readOnly ? FontWeight.w600 : FontWeight.w500,

          color: readOnly ? fieldColor : Colors.black87,
        ),
      ),
    );
  }
}
