import 'package:flutter/material.dart';
import 'package:firstflutterproject/entity/hotel_Aminities_model.dart';
import 'package:firstflutterproject/entity/hotel_model.dart';
import 'package:firstflutterproject/service/hotel_aminities_service.dart';
import 'package:firstflutterproject/service/hotel_service.dart';

class AddHotelAmenitiesPage extends StatefulWidget {
  @override
  _AddHotelAmenitiesPageState createState() => _AddHotelAmenitiesPageState();
}

class _AddHotelAmenitiesPageState extends State<AddHotelAmenitiesPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final service = HotelAminitiesService();
  final hotelService = HotelService();

  List<Hotel> hotels = [];
  Hotel? selectedHotel;
  bool isLoading = true;

  // Amenities switches
  bool freeWifi = false;
  bool freeParking = false;
  bool swimmingPool = false;
  bool gym = false;
  bool restaurant = false;
  bool roomService = false;
  bool airConditioning = false;
  bool laundryService = false;
  bool wheelchairAccessible = false;
  bool healthServices = false;
  bool playGround = false;
  bool airportSuttle = false;
  bool breakFast = false;

  @override
  void initState() {
    super.initState();
    loadUserHotels();
  }

  Future<void> loadUserHotels() async {
    try {
      List<Hotel> fetchedHotels = await hotelService.getMyHotels();
      setState(() {
        hotels = fetchedHotels;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading hotels: $e");
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load your hotels.")),
      );
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && selectedHotel != null) {
      Amenities newAmenities = Amenities(
        id: 0,
        freeWifi: freeWifi,
        freeParking: freeParking,
        swimmingPool: swimmingPool,
        gym: gym,
        restaurant: restaurant,
        roomService: roomService,
        airConditioning: airConditioning,
        laundryService: laundryService,
        wheelchairAccessible: wheelchairAccessible,
        healthServices: healthServices,
        playGround: playGround,
        airportSuttle: airportSuttle,
        breakFast: breakFast,
        hotelId: selectedHotel!.id,
        hotelName: selectedHotel!.name,
      );

      Amenities? response = await service.saveAmenities(newAmenities);

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Amenities saved successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save amenities.')),
        );
      }
    }
  }

  Widget _buildSwitch(String title, bool value, Function(bool) onChanged) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: Card(
        key: ValueKey(value),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SwitchListTile(
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          value: value,
          activeColor: Colors.deepPurple,
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Hotel Amenities"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.purple.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<Hotel>(
                  decoration: InputDecoration(
                    labelText: "Select Hotel",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  value: selectedHotel,
                  items: hotels.map((hotel) {
                    return DropdownMenuItem<Hotel>(
                      value: hotel,
                      child: Text(hotel.name),
                    );
                  }).toList(),
                  onChanged: (Hotel? value) {
                    setState(() {
                      selectedHotel = value;
                    });
                  },
                  validator: (value) =>
                  value == null ? "Please select a hotel" : null,
                ),

                SizedBox(height: 20),
                _buildSwitch("Free Wifi", freeWifi, (val) => setState(() => freeWifi = val)),
                _buildSwitch("Free Parking", freeParking, (val) => setState(() => freeParking = val)),
                _buildSwitch("Swimming Pool", swimmingPool, (val) => setState(() => swimmingPool = val)),
                _buildSwitch("Gym", gym, (val) => setState(() => gym = val)),
                _buildSwitch("Restaurant", restaurant, (val) => setState(() => restaurant = val)),
                _buildSwitch("Room Service", roomService, (val) => setState(() => roomService = val)),
                _buildSwitch("Air Conditioning", airConditioning, (val) => setState(() => airConditioning = val)),
                _buildSwitch("Laundry Service", laundryService, (val) => setState(() => laundryService = val)),
                _buildSwitch("Wheelchair Accessible", wheelchairAccessible, (val) => setState(() => wheelchairAccessible = val)),
                _buildSwitch("Health Services", healthServices, (val) => setState(() => healthServices = val)),
                _buildSwitch("Play Ground", playGround, (val) => setState(() => playGround = val)),
                _buildSwitch("Airport Shuttle", airportSuttle, (val) => setState(() => airportSuttle = val)),
                _buildSwitch("Breakfast", breakFast, (val) => setState(() => breakFast = val)),

                SizedBox(height: 30),
                Center(
                  child: GestureDetector(
                    onTap: _submitForm,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.deepPurple, Colors.purpleAccent],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.4),
                            offset: Offset(0, 6),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Text(
                        "Save Amenities",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
