import 'dart:io' show File;
import 'dart:typed_data';
import 'package:firstflutterproject/service/location_service.dart';
import 'package:firstflutterproject/service/hotel_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firstflutterproject/entity/hotel_model.dart' as hotel;
import 'package:firstflutterproject/entity/location_model.dart' as loc;

class AddHotelPage extends StatefulWidget {
  const AddHotelPage({super.key});

  @override
  State<AddHotelPage> createState() => _AddHotelPageState();
}

class _AddHotelPageState extends State<AddHotelPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _hotelService = HotelService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  File? _selectedImage;
  Uint8List? _webImage; // for web
  bool _isLoading = false;
  List<loc.Location> locations = [];
  loc.Location? selectedLocation;

  // Animation controllers
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadLocations();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadLocations() async {
    try {
      var fetchedLocations = await LocationService().getAllLocations();
      setState(() {
        locations = List<loc.Location>.from(fetchedLocations);
      });
    } catch (e) {
      print('Failed to load locations: $e');
    }
  }

  // ✅ Cross-platform image picker (Web + Mobile)
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _webImage = Uint8List.fromList(bytes);
            _selectedImage = null;
          });
        } else {
          setState(() {
            _selectedImage = File(pickedFile.path);
            _webImage = null;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ Failed to load image: $e")),
        );
      }
    }
  }


  Future<void> _saveHotel() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedLocation == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Select a location')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      hotel.Hotel newHotel = hotel.Hotel(
        id: 0,
        name: _nameController.text,
        address: _addressController.text,
        rating: _ratingController.text,
        image: '',
        location: hotel.Location(
          id: selectedLocation!.id,
          name: selectedLocation!.name,
          image: selectedLocation!.image,
        ),
      );

      // Backend call (no change)
      var result = await _hotelService.saveHotel(newHotel,
          kIsWeb ? null : _selectedImage); // keep original behavior

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Hotel saved successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 1),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff4158D0), Color(0xffC850C0), Color(0xffFFCC70)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: 450,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        colors: [Color(0xffF9F9F9), Color(0xffE8EAF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Text(
                              "✨ Add New Hotel ✨",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff3E3E3E),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(_nameController, "Hotel Name"),
                            _buildTextField(_addressController, "Address"),
                            _buildTextField(_ratingController, "Rating"),

                            const SizedBox(height: 16),
                            DropdownButtonFormField<loc.Location>(
                              value: selectedLocation,
                              decoration: _inputDecoration("Select Location"),
                              items: locations
                                  .map((loc.Location l) => DropdownMenuItem(
                                value: l,
                                child: Text(l.name),
                              ))
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => selectedLocation = value),
                            ),
                            const SizedBox(height: 16),

                            // ✅ Fixed image preview widget
                            GestureDetector(
                              onTap: _pickImage,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.deepPurple, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.deepPurple.withOpacity(0.2),
                                      blurRadius: 8,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: _selectedImage == null && _webImage == null
                                    ? const Center(
                                  child: Text(
                                    '📸 Tap to select image',
                                    style: TextStyle(
                                        color: Colors.black54, fontWeight: FontWeight.bold),
                                  ),
                                )
                                    : ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: kIsWeb
                                      ? Image.memory(
                                    _webImage!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Text(
                                          '❌ Image not supported',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      );
                                    },
                                  )
                                      : Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),

                              ),
                            ),

                            const SizedBox(height: 24),
                            _isLoading
                                ? const CircularProgressIndicator()
                                : MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: AnimatedContainer(
                                duration:
                                const Duration(milliseconds: 200),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xff8E2DE2),
                                      Color(0xff4A00E0)
                                    ],
                                  ),
                                  borderRadius:
                                  BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: Offset(0, 3))
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(15)),
                                  ),
                                  onPressed: _saveHotel,
                                  child: const Text(
                                    "💾 Save Hotel",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.deepPurple),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: TextFormField(
        controller: controller,
        decoration: _inputDecoration(label),
        validator: (v) => v!.isEmpty ? 'Enter $label' : null,
      ),
    );
  }
}
