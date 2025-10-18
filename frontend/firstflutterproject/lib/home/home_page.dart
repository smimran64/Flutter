import 'package:firstflutterproject/entity/hotel_model.dart' hide Location;
import 'package:firstflutterproject/hotel/hotel_details.dart';
import 'package:firstflutterproject/page/loginpage.dart';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:firstflutterproject/service/hotel_service.dart';
import 'package:firstflutterproject/service/location_service.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:firstflutterproject/entity/location_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const HotelBookingApp());
}

class HotelBookingApp extends StatelessWidget {
  const HotelBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Booking Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Location? selectedLocation;
  DateTime? checkInDate;
  DateTime? checkOutDate;
  List<Location> locations = [];
  List<Hotel> hotels = [];
  bool isLoading = false;
  final GlobalKey _galleryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  void _loadLocations() async {


    try {
      var fetchedLocations = await LocationService().getAllLocations();
      setState(() {
        locations = List<Location>.from(fetchedLocations);
      });
    } catch (e) {
      print('Failed to load locations: $e');
    }
  }

  void _searchHotels() async {
    if (selectedLocation == null || checkInDate == null || checkOutDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select location and dates')),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedLocation', selectedLocation!.name);
    prefs.setString('checkIn', checkInDate!.toIso8601String());
    prefs.setString('checkOut', checkOutDate!.toIso8601String());

    setState(() => isLoading = true);

    final df = DateFormat('yyyy-MM-dd');
    hotels = await HotelService().searchHotels(
      locationId: selectedLocation!.id,
      checkIn: df.format(checkInDate!),
      checkOut: df.format(checkOutDate!),
    );

    setState(() => isLoading = false);
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Loginpage()));
  }

  final List<String> carouselImages = [
    'https://images.pexels.com/photos/271639/pexels-photo-271639.jpeg',
    'https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg',
    'https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg',
    'https://images.pexels.com/photos/338504/pexels-photo-338504.jpeg',
    'https://images.pexels.com/photos/573552/pexels-photo-573552.jpeg',
  ];

  final List<String> destinations = [
    'Dhaka',
    'Cox\'s Bazar',
    'Sylhet',
    'Bandarban',
    'Chittagong'
  ];

  final List<String> destinationImages = [
    'https://images.pexels.com/photos/753626/pexels-photo-753626.jpeg',
    'https://images.pexels.com/photos/258154/pexels-photo-258154.jpeg',
    'https://images.pexels.com/photos/2104151/pexels-photo-2104151.jpeg',
    'https://images.pexels.com/photos/338504/pexels-photo-338504.jpeg',
    'https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg'
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
        title: const Text('Hotel Booking Management System', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Loginpage())),
            icon: const Icon(Icons.person, color: Colors.white),
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 🌅 Hero Section
              Stack(
                children: [
                  Container(
                    height: 260,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: 260,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 16,
                    right: 16,
                    child: Card(
                      elevation: 8,
                      color: Colors.white.withOpacity(0.95),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            DropdownButtonFormField<Location>(
                              value: selectedLocation,
                              hint: const Text('Select Location'),
                              items: locations.map((loc) => DropdownMenuItem(value: loc, child: Text(loc.name))).toList(),
                              onChanged: (value) => setState(() => selectedLocation = value),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDateField('Check-in', checkInDate, (picked) {
                                    setState(() => checkInDate = picked);
                                  }),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildDateField('Check-out', checkOutDate, (picked) {
                                    setState(() => checkOutDate = picked);
                                  }),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: _searchHotels,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                  ),
                                  child: const Text('Search'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🏨 Available Hotels
              _buildSectionTitle('🏨 Available Hotels'),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : hotels.isEmpty
                  ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No hotels found', style: TextStyle(color: Colors.grey)),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: hotels.length,
                itemBuilder: (context, index) => _buildHotelCard(hotels[index]),
              ),

              const SizedBox(height: 25),

              // 🔥 Hot Deals Carousel
              _buildSectionTitle('🔥 Hot Deals'),
              SizedBox(
                height: 190,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: carouselImages.length,
                  itemBuilder: (context, index) => _buildCarouselCard(carouselImages[index]),
                ),
              ),

              const SizedBox(height: 25),

              // 🌍 Popular Destinations
              _buildSectionTitle('🌍 Popular Destinations'),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: destinations.length,
                  itemBuilder: (context, index) => _buildDestinationCard(destinations[index], destinationImages[index]),
                ),
              ),

              const SizedBox(height: 25),

              //Part 6: Photo Gallery
                  Padding(
                       key: _galleryKey, padding: const EdgeInsets.symmetric(vertical: 50.0),
                       child: Column( children: [ _buildSectionTitle("Explore Our Gallery"),
                       const SizedBox(height: 30), _buildGallerySection(),
                    ]

                      ),
                                ),



              // 💬 Customer Reviews
              _buildSectionTitle('💬 Customer Reviews'),
              _buildReviewCard('Imran', 'Amazing hotel and staff service!', 5),
              _buildReviewCard('Sadiar', 'Clean rooms and great view.', 4),
              _buildReviewCard('Rafi', 'Loved the breakfast buffet!', 5),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildGallerySection() {
    final images = [
      'https://images.pexels.com/photos/164595/pexels-photo-164595.jpeg?auto=compress&cs=tinysrgb&w=600',
      'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?auto=compress&cs=tinysrgb&w=600',
      'https://images.pexels.com/photos/70441/pexels-photo-70441.jpeg?auto=compress&cs=tinysrgb&w=600',
      'https://images.pexels.com/photos/2598638/pexels-photo-2598638.jpeg?auto=compress&cs=tinysrgb&w=600',
      'https://images.pexels.com/photos/279746/pexels-photo-279746.jpeg?auto=compress&cs=tinysrgb&w=600',
      'https://images.pexels.com/photos/338504/pexels-photo-338504.jpeg?auto=compress&cs=tinysrgb&w=600',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: images.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200, // ⬅️ Max width per tile
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
        ),
        itemBuilder: (context, index) => _buildGalleryImage(images[index]),
      ),
    );
  }


  Widget _buildGalleryImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      ),
    );
  }


  Widget _buildDateField(String label, DateTime? date, Function(DateTime) onPick) {
    return InkWell(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
        if (picked != null) onPick(picked);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 16, color: Colors.teal),
            const SizedBox(width: 6),
            Text(date != null ? DateFormat('dd MMM').format(date) : label),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
    ),
  );

  Widget _buildHotelCard(Hotel hotel) => AnimatedContainer (
    duration: const Duration(milliseconds: 300),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: InkWell(
      onTap: () async {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('selectedHotel', hotel.name);
        prefs.setInt('selectedHotelId', hotel.id);
        Navigator.push(context, MaterialPageRoute(builder: (_) => HotelDetailsPage(hotelId: hotel.id)));
      },
      child: Card(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
              child: Image.network(
                'http://localhost:8082/images/hotels/${Uri.encodeComponent(hotel.image)}',
                width: 120,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hotel.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(hotel.address, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(hotel.rating.toString()),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );

  Widget _buildCarouselCard(String imageUrl) => AnimatedContainer(
    duration: const Duration(milliseconds: 400),
    margin: const EdgeInsets.only(right: 12),
    width: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          child: Image.network(imageUrl, height: 110, width: double.infinity, fit: BoxFit.cover),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Special Offer Hotel', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('Starting from \$99/night', style: TextStyle(color: Colors.grey)),
        )
      ],
    ),
  );

  Widget _buildDestinationCard(String name, String imageUrl) => Container(
    width: 140,
    margin: const EdgeInsets.only(right: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(imageUrl, height: 100, width: 140, fit: BoxFit.cover),
        ),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );


  Widget _buildReviewCard(String name, String review, int rating) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.teal,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(review),
            const SizedBox(height: 4),
            Row(
              children: List.generate(
                rating,
                    (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
