import 'package:flutter/material.dart';
import 'package:firstflutterproject/entity/hotel_information_model.dart';
import 'package:firstflutterproject/entity/hotel_model.dart';
import 'package:firstflutterproject/service/hotel_service.dart';
import 'package:firstflutterproject/service/hotel_information_service.dart';

class HotelInformationViewPage extends StatefulWidget {
  const HotelInformationViewPage({Key? key}) : super(key: key);

  @override
  State<HotelInformationViewPage> createState() =>
      _HotelInformationViewPageState();
}

class _HotelInformationViewPageState extends State<HotelInformationViewPage>
    with SingleTickerProviderStateMixin {
  final HotelService _hotelService = HotelService();
  final HotelInformationService _infoService = HotelInformationService();

  List<Hotel> _hotels = [];
  Hotel? _selectedHotel;
  HotelInformation? _hotelInfo;
  bool _loading = false;
  bool _loadingHotels = true;

  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _loadHotels();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed to load hotels: $e")),
      );
    }
  }

  Future<void> _fetchInfo() async {
    if (_selectedHotel == null) return;

    setState(() {
      _loading = true;
      _hotelInfo = null;
    });

    try {
      final info =
      await _infoService.getHotelInformationByHotelId(_selectedHotel!.id);
      setState(() {
        _hotelInfo = info;
        _loading = false;
      });
      _controller.forward(from: 0);
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ No information found for this hotel")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      appBar: AppBar(
        title: const Text(
          "🏨 View Hotel Information",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A148C),
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: _loadingHotels
          ? const Center(child: CircularProgressIndicator())
          : Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D83F2), Color(0xFFB065E9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownButtonFormField<Hotel>(
                  value: _selectedHotel,
                  hint: const Text(
                    "Select a Hotel",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  dropdownColor: Colors.deepPurple[100],
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
                    _fetchInfo();
                  },
                ),
                const SizedBox(height: 30),
                if (_loading)
                  const CircularProgressIndicator(color: Colors.white)
                else if (_hotelInfo != null)
                  FadeTransition(
                    opacity: _fade,
                    child: _buildInfoCard(),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Text(
                      "No hotel information available",
                      style:
                      TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🏨 ${_hotelInfo!.hotelName}",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          const Divider(color: Colors.white54, thickness: 1.2),
          const SizedBox(height: 8),
          Text("🗣️ Owner Speech:", style: _labelStyle()),
          Text(_hotelInfo!.ownerSpeach, style: _valueStyle()),
          const SizedBox(height: 12),
          Text("📜 Description:", style: _labelStyle()),
          Text(_hotelInfo!.description, style: _valueStyle()),
          const SizedBox(height: 12),
          Text("📘 Policy:", style: _labelStyle()),
          Text(_hotelInfo!.hotelPolicy, style: _valueStyle()),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate to edit page
                },
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text("Edit"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[600],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: delete logic here
                },
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text("Delete"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  TextStyle _labelStyle() => const TextStyle(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, height: 1.4);

  TextStyle _valueStyle() => const TextStyle(
      color: Colors.white70, fontSize: 15, fontWeight: FontWeight.normal, height: 1.4);

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(14),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.6),
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.12),
    );
  }
}
