import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firstflutterproject/entity/booking_model.dart';
import 'package:firstflutterproject/service/booking_service.dart';

class BookingHistoryPage extends StatefulWidget {
  final int customerId;

  const BookingHistoryPage({Key? key, required this.customerId}) : super(key: key);

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  late Future<List<Booking>> _futureBookings;
  final BookingService _bookingService = BookingService();

  @override
  void initState() {
    super.initState();
    _futureBookings = _bookingService.getBookingByCustomerId(widget.customerId);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    const String baseRoomImageUrl = "http://localhost:8082/images/rooms";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Booking History",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.cyan,
        centerTitle: true,
        elevation: 4,
      ),

      body: FutureBuilder<List<Booking>>(
        future: _futureBookings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.cyan));
          }
          else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No bookings found",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final bookings = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final room = booking.roomdto;
              final hotel = booking.hoteldto;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      "$baseRoomImageUrl/${room?.image ?? 'default_room.jpg'}",
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  title: Text(
                    hotel?.name ?? "Unknown Hotel",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Room Type: ${room?.roomType ?? 'N/A'}"),
                        Text("Check-in: ${dateFormat.format(booking.checkIn)}"),
                        Text("Check-out: ${dateFormat.format(booking.checkOut)}"),
                        Text("Total: ৳${booking.totalAmount.toStringAsFixed(2)}"),
                        Text("Advance: ৳${booking.advanceAmount.toStringAsFixed(2)}"),
                        Text("Due: ৳${booking.dueAmount.toStringAsFixed(2)}"),
                      ],
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${booking.numberOfRooms} Room(s)",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const Icon(Icons.hotel, color: Colors.blueAccent),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
