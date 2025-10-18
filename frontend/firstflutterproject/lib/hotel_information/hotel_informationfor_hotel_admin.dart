import 'package:flutter/material.dart';
import 'package:firstflutterproject/entity/hotel_information_model.dart';
import 'package:firstflutterproject/entity/hotel_model.dart';
import 'package:firstflutterproject/service/hotel_service.dart';
import 'package:firstflutterproject/service/hotel_information_service.dart';

class HotelInformationAddPage extends StatefulWidget {
  const HotelInformationAddPage({Key? key}) : super(key: key);

  @override
  State<HotelInformationAddPage> createState() => _HotelInformationAddPageState();
}

class _HotelInformationAddPageState extends State<HotelInformationAddPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _ownerController = TextEditingController();
  final _descController = TextEditingController();
  final _policyController = TextEditingController();

  final HotelService _hotelService = HotelService();
  final HotelInformationService _infoService = HotelInformationService();

  List<Hotel> _hotels = [];
  Hotel? _selectedHotel;
  bool _isSaving = false;
  bool _loadingHotels = true;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation =
        Tween<double>(begin: 0.95, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
    _loadHotels();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadHotels() async {
    try {
      final hotels = await _hotelService.getMyHotels();
      setState(() {
        _hotels = hotels;
        _loadingHotels = false;
      });
    } catch (e) {
      setState(() => _loadingHotels = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load hotels: $e')));
    }
  }

  Future<void> _saveInfo() async {
    if (!_formKey.currentState!.validate() || _selectedHotel == null) return;

    final info = HotelInformation(
      id: 0,
      ownerSpeach: _ownerController.text,
      description: _descController.text,
      hotelPolicy: _policyController.text,
      hotelId: _selectedHotel!.id,
      hotelName: _selectedHotel!.name,
    );

    setState(() => _isSaving = true);

    try {
      await _infoService.saveHotelInformation(info);
      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Hotel Information Saved Successfully!")),
      );

      _ownerController.clear();
      _descController.clear();
      _policyController.clear();
      setState(() => _selectedHotel = null);
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('❌ Save failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("✨ Add Hotel Information",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _loadingHotels
          ? const Center(child: CircularProgressIndicator())
          : AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: 500,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                        border: Border.all(
                            color: Colors.white.withOpacity(0.3), width: 1),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "🏨 Hotel Info Form",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),

                            DropdownButtonFormField<Hotel>(
                              value: _selectedHotel,
                              hint: const Text("Select Hotel"),
                              dropdownColor: Colors.deepPurple[100],
                              style: const TextStyle(color: Colors.black),
                              isExpanded: true,
                              decoration: _inputDecoration("Select Hotel"),
                              items: _hotels.map((hotel) {
                                return DropdownMenuItem(
                                  value: hotel,
                                  child: Text(hotel.name),
                                );
                              }).toList(),
                              onChanged: (hotel) {
                                setState(() => _selectedHotel = hotel);
                              },
                              validator: (value) =>
                              value == null ? 'Please select a hotel' : null,
                            ),
                            const SizedBox(height: 16),

                            _buildAnimatedTextField(
                                controller: _ownerController,
                                label: "Owner Speech",
                                icon: Icons.person),
                            const SizedBox(height: 16),

                            _buildAnimatedTextField(
                                controller: _descController,
                                label: "Description",
                                icon: Icons.description,
                                maxLines: 3),
                            const SizedBox(height: 16),

                            _buildAnimatedTextField(
                                controller: _policyController,
                                label: "Hotel Policy",
                                icon: Icons.policy,
                                maxLines: 3),
                            const SizedBox(height: 25),

                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: _isSaving
                                        ? [Colors.grey, Colors.grey]
                                        : [Colors.purpleAccent, Colors.blueAccent],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    minimumSize: const Size.fromHeight(50),
                                  ),
                                  onPressed: _isSaving ? null : _saveInfo,
                                  child: _isSaving
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : const Text(
                                    "💾 Save Information",
                                    style: TextStyle(
                                        fontSize: 16,
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
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) => value!.isEmpty ? 'Enter $label' : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.2),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
