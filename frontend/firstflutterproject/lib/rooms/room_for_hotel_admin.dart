import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firstflutterproject/entity/hotel_model.dart';
import 'package:firstflutterproject/entity/room_model.dart';
import 'package:firstflutterproject/service/hotel_service.dart';
import 'package:firstflutterproject/service/room_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HotelForHotelAdminPage extends StatefulWidget {
  const HotelForHotelAdminPage({Key? key}) : super(key: key);

  @override
  State<HotelForHotelAdminPage> createState() => _HotelForHotelAdminPageState();
}

class _HotelForHotelAdminPageState extends State<HotelForHotelAdminPage> {
  final HotelService _hotelService = HotelService();
  final RoomService _roomService = RoomService();

  List<Hotel> _hotels = [];
  List<Room> _rooms = [];
  Hotel? _selectedHotel;
  bool _isLoading = true;
  bool _isRoomLoading = false;

  final String baseUrl = "http://localhost:8082/images/rooms"; // Backend base URL

  @override
  void initState() {
    super.initState();
    _loadHotels();
  }

  Future<void> _loadHotels() async {
    try {
      List<Hotel> hotels = await _hotelService.getMyHotels();
      setState(() {
        _hotels = hotels;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load hotels: $e')),
      );
    }
  }

  Future<void> _loadRoomsByHotel(int hotelId) async {
    setState(() {
      _isRoomLoading = true;
      _rooms = [];
    });
    try {
      List<Room> rooms = await _roomService.getRoomsByHotelId(hotelId);
      setState(() {
        _rooms = rooms;
        _isRoomLoading = false;
      });
    } catch (e) {
      setState(() => _isRoomLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load rooms: $e')),
      );
    }
  }

  Future<void> _showEditRoomDialog(Room room) async {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController roomTypeController = TextEditingController(text: room.roomType);
    final TextEditingController priceController = TextEditingController(text: room.price.toString());
    final TextEditingController adultsController = TextEditingController(text: room.adults.toString());
    final TextEditingController childrenController = TextEditingController(text: room.children.toString());
    final TextEditingController totalRoomsController = TextEditingController(text: room.totalRooms.toString());

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: const Text(
          "Edit Room",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(roomTypeController, "Room Type"),
                _buildTextField(priceController, "Price", isNumber: true),
                _buildTextField(adultsController, "Adults", isNumber: true),
                _buildTextField(childrenController, "Children", isNumber: true),
                _buildTextField(totalRoomsController, "Total Rooms", isNumber: true),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context);
                await _updateRoom(
                  room.id,
                  roomTypeController.text,
                  double.tryParse(priceController.text) ?? 0,
                  int.tryParse(adultsController.text) ?? 0,
                  int.tryParse(childrenController.text) ?? 0,
                  int.tryParse(totalRoomsController.text) ?? 0,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              backgroundColor: Colors.deepPurpleAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text("Save", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.purple.shade50,
        ),
        validator: (val) => val == null || val.isEmpty ? "Required" : null,
      ),
    );
  }

  Future<void> _updateRoom(
      int roomId,
      String roomType,
      double price,
      int adults,
      int children,
      int totalRooms,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    final url = Uri.parse('http://localhost:8082/api/room/update/$roomId');

    final body = {
      "roomType": roomType,
      "price": price,
      "adults": adults,
      "children": children,
      "totalRooms": totalRooms,
      "hotelDTO": {"id": _selectedHotel?.id},
    };

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Room updated successfully")),
        );
        if (_selectedHotel != null) {
          _loadRoomsByHotel(_selectedHotel!.id);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to update room. Status: ${response.statusCode} \n${response.body}",
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // ----------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "🏨 My Hotels & Rooms",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 8,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<Hotel>(
              value: _selectedHotel,
              hint: const Text("Select Hotel"),
              isExpanded: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.deepPurple.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              items: _hotels.map((hotel) {
                return DropdownMenuItem(
                  value: hotel,
                  child: Text(hotel.name),
                );
              }).toList(),
              onChanged: (Hotel? selected) {
                setState(() => _selectedHotel = selected);
                if (selected != null) {
                  _loadRoomsByHotel(selected.id);
                }
              },
            ),
            const SizedBox(height: 20),
            _isRoomLoading
                ? const CircularProgressIndicator()
                : Expanded(
              child: _rooms.isEmpty
                  ? const Center(
                child: Text(
                  "No rooms found",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )
                  : ListView.builder(
                itemCount: _rooms.length,
                itemBuilder: (context, index) {
                  final room = _rooms[index];
                  final imageUrl = room.image.startsWith('http')
                      ? room.image
                      : "$baseUrl/${room.image}";
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple.shade50, Colors.deepPurple.shade50],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.shade100,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                            child: Image.network(
                              imageUrl,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Container(
                                  height: 180,
                                  color: Colors.purple.shade100,
                                  child: const Center(child: CircularProgressIndicator()),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: 180,
                                    color: Colors.grey[300],
                                    child: const Center(
                                        child: Icon(Icons.broken_image, size: 60)),
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  room.roomType,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _infoRow("💰 Price", "\$${room.price}"),
                                _infoRow("👨 Adults", "${room.adults}"),
                                _infoRow("🧒 Children", "${room.children}"),
                                _infoRow("🏨 Available", "${room.availableRooms}/${room.totalRooms}"),
                                _infoRow("📦 Booked Rooms", "${room.bookedRooms}"),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _animatedButton(
                                      label: "Edit",
                                      icon: Icons.edit,
                                      color: Colors.deepPurpleAccent,
                                      onTap: () => _showEditRoomDialog(room),
                                    ),
                                    _animatedButton(
                                      label: "Delete",
                                      icon: Icons.delete,
                                      color: Colors.redAccent,
                                      onTap: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Delete button pressed"),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }

  Widget _animatedButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
