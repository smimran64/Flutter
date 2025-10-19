import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firstflutterproject/entity/hotel_model.dart';
import 'package:firstflutterproject/entity/room_model.dart';
import 'package:firstflutterproject/service/hotel_service.dart';
import 'package:firstflutterproject/service/room_service.dart';

class AddRoomPage extends StatefulWidget {
  const AddRoomPage({Key? key}) : super(key: key);

  @override
  State<AddRoomPage> createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roomTypeController = TextEditingController();
  final TextEditingController _totalRoomsController = TextEditingController();
  final TextEditingController _adultsController = TextEditingController();
  final TextEditingController _childrenController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? _imageFile;
  Uint8List? _imageBytes;
  Hotel? _selectedHotel;
  List<Hotel> _hotels = [];

  bool _isImagePressed = false;

  @override
  void initState() {
    super.initState();
    _loadHotels();
  }

  Future<void> _loadHotels() async {
    try {
      var hotels = await HotelService().getMyHotels();
      setState(() {
        _hotels = hotels;
      });
    } catch (e) {
      print("❌ Error loading hotels: $e");
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageFile = null;
        });
      } else {
        setState(() {
          _imageFile = File(picked.path);
          _imageBytes = null;
        });
      }
    }
  }

  Future<void> _saveRoom() async {
    if (_formKey.currentState!.validate() && _selectedHotel != null) {
      var room = Room(
        id: 0,
        roomType: _roomTypeController.text,
        image: "",
        totalRooms: int.parse(_totalRoomsController.text),
        adults: int.parse(_adultsController.text),
        children: int.parse(_childrenController.text),
        price: double.parse(_priceController.text),
        availableRooms: int.parse(_totalRoomsController.text),
        bookedRooms: 0,
        hotel: _selectedHotel!,
      );

      try {
        await RoomService().saveRoom(
          room,
          imageFile: _imageFile,
          imageBytes: _imageBytes,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Room added successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Failed to add room: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D47A1);
    const accentColor = Color(0xFFFFC107);
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade400),
    );

    InputDecoration buildInputDecoration(String label, IconData icon) {
      return InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryColor),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a New Room", style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.grey.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // ✅ FIXED HERE: The animation is now applied directly to the list of children.
              // The extra `...[` and `]` have been removed.
              children: [
                DropdownButtonFormField<Hotel>(
                  decoration: buildInputDecoration("Select Hotel", Icons.hotel),
                  items: _hotels
                      .map((hotel) => DropdownMenuItem(
                    value: hotel,
                    child: Text(hotel.name),
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedHotel = value),
                  validator: (value) =>
                  value == null ? 'Please select a hotel' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _roomTypeController,
                  decoration: buildInputDecoration("Room Type", Icons.king_bed),
                  validator: (v) => v!.isEmpty ? 'Enter room type' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _totalRoomsController,
                  decoration: buildInputDecoration("Total Rooms", Icons.room_service),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _adultsController,
                        decoration: buildInputDecoration("Adults", Icons.person),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _childrenController,
                        decoration: buildInputDecoration("Children", Icons.child_friendly),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: buildInputDecoration("Price per Night", Icons.attach_money),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: _pickImage,
                  onTapDown: (_) => setState(() => _isImagePressed = true),
                  onTapUp: (_) => setState(() => _isImagePressed = false),
                  onTapCancel: () => setState(() => _isImagePressed = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: _isImagePressed ? (Matrix4.identity()..scale(0.98)) : Matrix4.identity(),
                    child: DottedBorder(
                      color: primaryColor.withOpacity(0.7),
                      strokeWidth: 2,
                      dashPattern: const [8, 4],
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(12),
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: (_imageFile != null || _imageBytes != null)
                              ? (_imageFile != null
                              ? Image.file(_imageFile!, fit: BoxFit.cover)
                              : Image.memory(_imageBytes!, fit: BoxFit.cover))
                              : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo_outlined, size: 40, color: primaryColor),
                                SizedBox(height: 8),
                                Text(
                                  "Tap to select an image",
                                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [primaryColor, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _saveRoom,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Save Room",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ].animate(interval: 80.ms).fadeIn(duration: 400.ms).slide(
                begin: const Offset(0, 0.2),
                curve: Curves.easeOut,
              ),
            ),
          ),
        ),
      ),
    );
  }
}