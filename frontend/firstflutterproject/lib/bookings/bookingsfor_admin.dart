import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:fl_chart/fl_chart.dart'; // ✅ Added for chart
import '../entity/booking_model.dart';
import '../service/booking_service.dart';
import '../service/hotel_service.dart';
import '../entity/hotel_model.dart';

class BookingsForAdminPage extends StatefulWidget {
  const BookingsForAdminPage({Key? key}) : super(key: key);

  @override
  State<BookingsForAdminPage> createState() => _BookingsByHotelPageState();
}

class _BookingsByHotelPageState extends State<BookingsForAdminPage> {
  final HotelService _hotelService = HotelService();
  final BookingService _bookingService = BookingService();

  List<Hotel> _hotels = [];
  List<Booking> _bookings = [];
  Hotel? _selectedHotel;

  bool _loading = false;
  String _searchQuery = "";
  DateTime? _startDate;
  DateTime? _endDate;

  final DateFormat _formatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _loadHotels();
  }

  Future<void> _loadHotels() async {
    try {
      final hotels = await _hotelService.getAllHotels();
      setState(() => _hotels = hotels);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to load hotels: $e")));
    }
  }

  Future<void> _loadBookings() async {
    if (_selectedHotel == null) return;
    setState(() => _loading = true);
    try {
      final bookings =
      await _bookingService.getBookingsByHotelId(_selectedHotel!.id!);
      setState(() => _bookings = bookings);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to load bookings: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select check-in/check-out range',
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  List<Booking> get _filteredBookings {
    List<Booking> filtered = _bookings;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((b) =>
      (b.customerdto?.name ?? '')
          .toLowerCase()
          .contains(_searchQuery.toLowerCase()) ||
          (b.contractPersonName)
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_startDate != null && _endDate != null) {
      filtered = filtered.where((b) {
        final checkIn = b.checkIn;
        final checkOut = b.checkOut;

        return (checkIn.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
            checkIn.isBefore(_endDate!.add(const Duration(days: 1)))) ||
            (checkOut
                .isAfter(_startDate!.subtract(const Duration(days: 1))) &&
                checkOut.isBefore(_endDate!.add(const Duration(days: 1))));
      }).toList();
    }

    return filtered;
  }

  /// 🧾 Generate PDF
  Future<void> _generatePdf() async {
    if (_filteredBookings.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No bookings to export")));
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Center(
            child: pw.Text(
              'Booking Report - ${_selectedHotel?.name ?? ''}',
              style:
              pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            headers: [
              'Customer',
              'Check-In',
              'Check-Out',
              'Total',
              'Advance',
              'Due'
            ],
            data: _filteredBookings.map((b) {
              return [
                b.customerdto?.name ?? b.contractPersonName,
                _formatter.format(b.checkIn),
                _formatter.format(b.checkOut),
                b.totalAmount.toStringAsFixed(2),
                b.advanceAmount.toStringAsFixed(2),
                b.dueAmount.toStringAsFixed(2),
              ];
            }).toList(),
            border: pw.TableBorder.all(),
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration:
            const pw.BoxDecoration(color: PdfColors.blueGrey),
            cellAlignment: pw.Alignment.centerLeft,
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Total Bookings: ${_filteredBookings.length}',
            style: pw.TextStyle(fontSize: 14),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  /// 📊 Prepare chart data (Count bookings per date)
  Map<String, int> _getBookingCountByDate() {
    final Map<String, int> data = {};
    for (var booking in _filteredBookings) {
      final dateKey = _formatter.format(booking.checkIn);
      data[dateKey] = (data[dateKey] ?? 0) + 1;
    }
    return data;
  }


  /// 🍩 Generate colorful Pie chart data
  List<PieChartSectionData> _generatePieSections() {
    double totalAmount = 0;
    double advance = 0;
    double due = 0;

    for (var b in _filteredBookings) {
      totalAmount += b.totalAmount;
      advance += b.advanceAmount;
      due += b.dueAmount;
    }

    if (totalAmount == 0) return [];

    final sections = [
      {
        'label': 'Total',
        'value': totalAmount,
        'color': Colors.blueAccent,
      },
      {
        'label': 'Advance',
        'value': advance,
        'color': Colors.greenAccent,
      },
      {
        'label': 'Due',
        'value': due,
        'color': Colors.orangeAccent,
      },
    ];

    return sections.map((item) {
      final percentage = ((item['value'] as double) / totalAmount * 100)
          .toStringAsFixed(1);

      return PieChartSectionData(
        color: item['color'] as Color,
        value: item['value'] as double,
        title: '$percentage%',
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        badgeWidget: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Text(
            item['label'] as String,
            style: const TextStyle(fontSize: 10),
          ),
        ),
      );
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    final chartData = _getBookingCountByDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings by Hotel'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export as PDF',
            onPressed: _filteredBookings.isEmpty ? null : _generatePdf,
          ),
        ],
      ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🏨 Hotel Dropdown
              DropdownButtonFormField<Hotel>(
                value: _selectedHotel,
                decoration: const InputDecoration(
                  labelText: 'Select Hotel',
                  border: OutlineInputBorder(),
                ),
                isExpanded: true,
                items: _hotels.map((hotel) {
                  return DropdownMenuItem(
                    value: hotel,
                    child: Text(hotel.name ?? 'Unnamed Hotel'),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedHotel = val;
                    _bookings.clear();
                  });
                  _loadBookings();
                },
              ),
              const SizedBox(height: 10),

              // 🔍 Search bar
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  labelText: 'Search by customer name',
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
              const SizedBox(height: 10),

              // 📅 Date range picker
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickDateRange,
                      icon: const Icon(Icons.date_range),
                      label: Text(
                        _startDate == null
                            ? 'Select Date Range'
                            : '${_formatter.format(_startDate!)} → ${_formatter.format(_endDate!)}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // 📊 Colorful + Animated Bar Chart Section
              if (chartData.isNotEmpty) ...[
                const Text(
                  '📊 Booking Trend (by Check-In Date)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 220,
                  child: BarChart(
                    BarChartData(
                      gridData: FlGridData(show: true, horizontalInterval: 1),
                      borderData: FlBorderData(show: false),
                      barGroups: chartData.entries.map((entry) {
                        final index = chartData.keys.toList().indexOf(entry.key);
                        final colors = [
                          Colors.blueAccent,
                          Colors.greenAccent,
                          Colors.orangeAccent,
                          Colors.purpleAccent,
                          Colors.pinkAccent,
                          Colors.tealAccent,
                          Colors.amberAccent,
                        ];
                        final color = colors[index % colors.length];
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.toDouble(),
                              gradient: LinearGradient(
                                colors: [
                                  color.withOpacity(0.9),
                                  color.withOpacity(0.5),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              width: 22,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ],
                        );
                      }).toList(),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            getTitlesWidget: (value, meta) => Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final keyIndex = value.toInt();
                              if (keyIndex >= 0 &&
                                  keyIndex < chartData.keys.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    chartData.keys.elementAt(keyIndex).substring(5),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                      ),
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 1200),
                    swapAnimationCurve: Curves.easeOutBack,
                  ),
                ),
                const SizedBox(height: 15),
              ],

              // 🥧 Pie Chart Section: Total vs Advance vs Due
              if (_filteredBookings.isNotEmpty) ...[
                const Text(
                  '💰 Payment Summary',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 220,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      startDegreeOffset: -90,
                      sections: _generatePieSections(),
                      borderData: FlBorderData(show: false),
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 1200),
                    swapAnimationCurve: Curves.easeOutExpo,
                  ),
                ),
                const SizedBox(height: 15),
              ],

              // 📋 Booking List
              Text(
                'Total Bookings: ${_filteredBookings.length}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),

              ),
              const SizedBox(height: 8),

              if (_filteredBookings.isEmpty)
                const Center(child: Text('No bookings found'))
              else
                ListView.builder(
                  itemCount: _filteredBookings.length,
                  physics: const NeverScrollableScrollPhysics(), // prevent nested scroll
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final booking = _filteredBookings[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 4),
                      child: ListTile(
                        leading: const Icon(Icons.person,
                            color: Colors.blueAccent),
                        title: Text(
                          booking.customerdto?.name ??
                              booking.contractPersonName,
                          style:
                          const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Check-In: ${_formatter.format(booking.checkIn)}\n'
                              'Check-Out: ${_formatter.format(booking.checkOut)}\n'
                              'Total: ${booking.totalAmount} | '
                              'Advance: ${booking.advanceAmount} | '
                              'Due: ${booking.dueAmount}',
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),

    );
  }
}
