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
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

// Converted to a StatefulWidget to manage scroll controller and keys
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Keys to identify each section for scrolling
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _goalsKey = GlobalKey();
  final GlobalKey _galleryKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _officeKey = GlobalKey();

  // Controller to manage scrolling
  late ScrollController _scrollController;
  bool _showScrollButton = false;



  Location? selectedLocation;
  DateTime? checkInDate;
  DateTime? checkOutDate;

  List<Location> locations = [];
  List<Hotel> hotels = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _loadLocations();

    _scrollController = ScrollController()
      ..addListener(() {
        // Show button when user scrolls down
        if (_scrollController.offset > 300) {
          if (!_showScrollButton) {
            setState(() {
              _showScrollButton = true;
            });
          }
        } else {
          if (_showScrollButton) {
            setState(() {
              _showScrollButton = false;
            });
          }
        }
      });
  }



  void _loadLocations() async {
    try {
      var fetchedLocations = await LocationService().getAllLocations();
      print("Fetched locations: $fetchedLocations");

      setState(() {
        locations = List<Location>.from(fetchedLocations); // cast safely
      });
    } catch (e) {
      print("Failed to load locations: $e");
    }
  }




  void _searchHotels() async {
    if (selectedLocation == null || checkInDate == null || checkOutDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select location and dates")),
      );
      return;
    }

    setState(() => isLoading = true);

    final df = DateFormat('yyyy-MM-dd'); // Convert DateTime to API-compatible string
    hotels = await HotelService().searchHotels(
      locationId: selectedLocation!.id,
      checkIn: df.format(checkInDate!),
      checkOut: df.format(checkOutDate!),
    );

    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Function to scroll to a specific section
  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  // // Helper function to launch URL
  // Future<void> _launchURL(String url) async {
  //   final Uri uri = Uri.parse(url);
  //   if (!await launchUrl(uri)) {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // We use a LayoutBuilder to make the design responsive.
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 800;
        return Scaffold(
          backgroundColor: const Color(0xffF5F5F5),
          // Added floating action buttons for scrolling
          floatingActionButton: _showScrollButton
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                  );
                },
                mini: true,
                tooltip: 'Scroll to Top',
                backgroundColor: Colors.blue.shade700,
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                onPressed: () {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                  );
                },
                mini: true,
                tooltip: 'Scroll to Bottom',
                backgroundColor: Colors.blue.shade700,
                child: const Icon(Icons.arrow_downward, color: Colors.white),
              ),
            ],
          )
              : null,
          body: SingleChildScrollView(
            controller: _scrollController, // Assigned controller
            child: Column(
              children: [
                // Part 1: Header and Hero Section combined in a Stack
                Stack(
                  key: _homeKey, // Key for Home section
                  children: [
                    // The stunning background image
                    _buildHeroBackground(),
                    // The content on top of the image
                    Column(
                      children: [
                        _buildAppBar(context, isDesktop),
                        _buildHeroContent(context),
                      ],
                    ),
                  ],
                ),
                // Part 2: Services Section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Column(
                    children: [
                      _buildSectionTitle("Hotel List"),
                      const SizedBox(height: 30),
                      _buildHotelList(),
                    ],
                  ),
                ),


                Padding(
                  key: _servicesKey,
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Column(
                    children: [
                      _buildSectionTitle("Our Services"),
                      const SizedBox(height: 30),
                      _buildServicesSection(),
                    ],
                  ),
                ),

                // Part 3: About Section
                Padding(
                  key: _aboutKey,
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Column(
                    children: [
                      _buildSectionTitle("About Us"),
                      const SizedBox(height: 30),
                      _buildAboutSection(context, isDesktop),
                    ],
                  ),
                ),

                // Part 4: Local Office Section
                Padding(
                  key: _officeKey,
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Column(
                    children: [
                      _buildSectionTitle("Our Local Office"),
                      const SizedBox(height: 30),
                      _buildOfficeSection(context, isDesktop),
                    ],
                  ),
                ),

                // Part 5: Goals Section
                Padding(
                  key: _goalsKey,
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Column(
                    children: [
                      _buildSectionTitle("Our Goals"),
                      const SizedBox(height: 30),
                      _buildGoalsSection(context, isDesktop),
                    ],
                  ),
                ),

                // Part 6: Photo Gallery
                Padding(
                  key: _galleryKey,
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Column(
                    children: [
                      _buildSectionTitle("Explore Our Gallery"),
                      const SizedBox(height: 30),
                      _buildGallerySection(),
                    ],
                  ),
                ),

                const SizedBox(height: 100),

                // Part 7: Footer
                _buildFooter(),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget for the background image of the hero section
  Widget _buildHeroBackground() {
    return Container(
      height: 700,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.2)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
        ),
      ),
    );
  }

  // Custom App Bar / Header
  Widget _buildAppBar(BuildContext context, bool isDesktop) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: const Text(
              'Hotel Booking Management System',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
          if (isDesktop)
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _HeaderLink('Home', onTap: () => _scrollToSection(_homeKey)),
                    _HeaderLink('Services', onTap: () => _scrollToSection(_servicesKey)),
                    _HeaderLink('About', onTap: () => _scrollToSection(_aboutKey)),
                    _HeaderLink('Local Office', onTap: () => _scrollToSection(_officeKey)),
                    _HeaderLink('Goals', onTap: () => _scrollToSection(_goalsKey)),
                    const SizedBox(width: 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Loginpage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue.shade800,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Sign In'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        AuthService().logout();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
          if (!isDesktop)
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 30),
              onPressed: () {
                // TODO: open drawer or bottom sheet menu
              },
            ),
        ],
      ),
    );
  }


  Widget _buildHeroContent(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // 👈 এটা যুক্ত করো
        children: [
          const FadeInUp(
            delay: 0.5,
            child: Text(
              'Find Your Next Stay',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 10, color: Colors.black54)],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const FadeInUp(
            delay: 0.8,
            child: Text(
              'Discover amazing deals on hotels, private homes, and more...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 50),
          FadeInUp(
            delay: 1.1,
            child: _buildSearchBar(context),
          ),
        ],
      ),
    );
  }


  Widget _buildSearchBar(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.75,
          constraints: const BoxConstraints(maxWidth: 900),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: [
              // 🔹 Location Dropdown
              Container(
                width: 200,
                child: DropdownButtonFormField<Location>(
                  value: selectedLocation,
                  hint: const Text('Select Location'),
                  items: locations.map((loc) {
                    return DropdownMenuItem(
                      value: loc,
                      child: Text(loc.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedLocation = value);
                  },
                ),
              ),

              // 🔹 Check-in Date Picker
              _buildDateField(
                label: 'Check-in',
                date: checkInDate,
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => checkInDate = picked);
                },
              ),

              // 🔹 Check-out Date Picker
              _buildDateField(
                label: 'Check-out',
                date: checkOutDate,
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: checkInDate ?? DateTime.now(),
                    firstDate: checkInDate ?? DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => checkOutDate = picked);
                },
              ),

              // 🔹 Search Button
              ElevatedButton.icon(
                onPressed: _searchHotels,
                icon: const Icon(Icons.search),
                label: const Text('Search'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 22),
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 180,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              date != null ? "${date.day}/${date.month}/${date.year}" : label,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSearchField(BuildContext context, IconData icon, String hintText) {
    return SizedBox(
      width: 200,
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade800),
          prefixIcon: Icon(icon, color: Colors.grey.shade800),
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        ),
      ),
    );
  }




  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }


  Widget _buildHotelList() {
    final String baseUrl = "http://localhost:8082/images/hotels";

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hotels.isEmpty) {
      return const Center(child: Text("No hotels found"));
    }

    return LayoutBuilder(
      builder: (context, constraints) {

        int crossAxis = 1;
        if (constraints.maxWidth > 1200) {
          crossAxis = 3;
        } else if (constraints.maxWidth > 800) {
          crossAxis = 2;
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxis,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 3 / 2, // image + text ratio
          ),
          itemCount: hotels.length,
          itemBuilder: (context, index) {
            final hotel = hotels[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              clipBehavior: Clip.hardEdge,
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Flexible Image Container
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            '$baseUrl/${Uri.encodeComponent(hotel.image)}',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hotel.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 23),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                        ),
                        const SizedBox(height: 4),
                        Text(
                          hotel.address,
                          style: const TextStyle(color: Colors.black, fontSize: 18),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          hotel.location.name,
                          style: const TextStyle(color: Colors.black, fontSize: 18),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(hotel.rating.toString(),
                                style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => HotelDetailsPage(hotelId: hotel.id))
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),


                              ),
                            ),
                            child: const Text("View Details"),

                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }



  Widget _buildServicesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Wrap(
        spacing: 30,
        runSpacing: 30,
        alignment: WrapAlignment.center,
        children: [
          _buildServiceCard(Icons.wifi, "Free Wi-Fi", "Stay connected with high-speed internet access."),
          _buildServiceCard(Icons.pool, "Swimming Pool", "Relax and rejuvenate in our sparkling clean pool."),
          _buildServiceCard(Icons.restaurant_menu, "Fine Dining", "Experience exquisite cuisine at our in-house restaurant."),
          _buildServiceCard(Icons.local_parking, "Free Parking", "Enjoy the convenience of complimentary parking."),
          _buildServiceCard(Icons.fitness_center, "Gym", "Stay fit and healthy at our state-of-the-art gym."),
          _buildServiceCard(Icons.room_service, "Room Service", "24/7 room service to cater to all your needs."),
          _buildServiceCard(Icons.medical_services_outlined, "Health Service", "Access to primary medical care for emergencies."),
          _buildServiceCard(Icons.local_laundry_service, "Laundry Service", "On-site laundry and dry cleaning services."),
          _buildServiceCard(Icons.child_friendly, "Playground", "A safe and fun play area for your children."),
          _buildServiceCard(Icons.accessible, "Accessibility", "Wheelchair accessible rooms and facilities."),
          _buildServiceCard(Icons.airport_shuttle, "Airport Shuttle", "Convenient shuttle service to and from the airport."),
        ],
      ),
    );
  }

  Widget _buildServiceCard(IconData icon, String title, String description) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.blue.shade600),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(description, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, bool isDesktop) {
    return _buildTwoColumnSection(
      context,
      isDesktop,
      imageUrl: 'https://images.pexels.com/photos/1268855/pexels-photo-1268855.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      title: "Welcome to HBMS Web Site",
      content: "Founded with a passion for hospitality, DaduVai Hotels offers a blend of modern luxury and timeless elegance. Our mission is to create a welcoming atmosphere where guests can relax, unwind, and create lasting memories. We believe in the power of exceptional service and strive to exceed your expectations at every turn. Come and experience the unique charm of DaduVai Hotels.",
      imageOnLeft: false,
    );
  }

  Widget _buildOfficeSection(BuildContext context, bool isDesktop) {
    final Widget textDetails = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Get In Touch", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildContactInfo(Icons.location_pin, "Address:", "123 Hotel Road, Gulshan Avenue, Dhaka-1212, Bangladesh"),
          _buildContactInfo(Icons.email, "Email:", "support@hbms.com"),
          _buildContactInfo(Icons.phone, "Phone:", "+880 123 456 7890"),
        ],
      ),
    );

    final Widget mapPlaceholder = Expanded(
      child: GestureDetector(
        onTap: () {
          // In a real app, you would launch the URL.
          // _launchURL('https://www.google.com/maps/place/Gulshan,+Dhaka,+Bangladesh');
        },
        child: Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: const DecorationImage(
              image: NetworkImage('https://images.pexels.com/photos/3746279/pexels-photo-3746279.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black.withOpacity(0.4),
            ),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map, color: Colors.white, size: 50),
                  SizedBox(height: 10),
                  Text("Open in Google Maps", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: isDesktop
            ? Row(
          children: [textDetails, const SizedBox(width: 40), mapPlaceholder],
        )
            : Column(
          children: [textDetails, const SizedBox(height: 30), mapPlaceholder],
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String title, String detail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade600),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(detail),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsSection(BuildContext context, bool isDesktop) {
    return _buildTwoColumnSection(
      context,
      isDesktop,
      imageUrl: 'https://images.pexels.com/photos/1457842/pexels-photo-1457842.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      title: "Your Comfort is Our Priority",
      content: "At Out Hotel Booking Management System, our goal is simple: to provide an unparalleled hospitality experience. We are committed to offering exceptional service, luxurious comfort, and memorable moments for every guest. From our meticulously designed rooms to our world-class amenities, every detail is crafted with your satisfaction in mind. We strive to be more than just a place to stay—we aim to be your home away from home.",
      imageOnLeft: true,
    );
  }

  // A generic widget for sections with an image and text
  Widget _buildTwoColumnSection(BuildContext context, bool isDesktop, {required String imageUrl, required String title, required String content, required bool imageOnLeft}) {
    final Widget image = ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        imageUrl,
        height: 350,
        width: isDesktop ? 400 : double.infinity,
        fit: BoxFit.cover,
      ),
    );

    final Widget textContent = SizedBox(
      width: isDesktop ? MediaQuery.of(context).size.width * 0.4 : double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
          ),
          const SizedBox(height: 20),
          Text(
            content,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600, height: 1.6),
          ),
        ],
      ),
    );

    final children = imageOnLeft ? [image, const SizedBox(width: 50), textContent] : [textContent, const SizedBox(width: 50), image];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: isDesktop
          ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      )
          : Column(
        children: [image, const SizedBox(height: 30), textContent],
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
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: images.map((url) => _buildGalleryImage(url)).toList(),
      ),
    );
  }

  Widget _buildGalleryImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        imageUrl,
        width: 300,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }


  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
      color: Colors.grey.shade900,
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isWide = constraints.maxWidth > 800;
              return isWide ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _footerContent(),
              ) : Column(
                children: _footerContent(isColumn: true),
              );
            },
          ),
          const SizedBox(height: 40),
          const Divider(color: Colors.grey),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("© 2024 Hotel Booking Management System. All Rights Reserved.", style: TextStyle(color: Colors.grey.shade400)),
              Row(
                children: [
                  _SocialIcon(Icons.facebook),
                  _SocialIcon(Icons.camera_alt),
                  _SocialIcon(Icons.label_important), // Placeholder for X/Twitter
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  List<Widget> _footerContent({bool isColumn = false}) {
    return [
      Expanded(
        flex: isColumn ? 0 : 2,
        child: Padding(
          padding: EdgeInsets.only(bottom: isColumn ? 30 : 0),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hotel Booking Management System", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 10),
              Text("Providing quality hospitality and memorable experiences since 2023.", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
      SizedBox(width: isColumn ? 0 : 30, height: isColumn ? 30 : 0),
      Expanded(
        flex: isColumn ? 0 : 2,
        child: _buildFooterLinks("Quick Links", ["Home", "Bookings", "Services", "About Us"]),
      ),
      SizedBox(width: isColumn ? 0 : 30, height: isColumn ? 30 : 0),
      Expanded(
        flex: isColumn ? 0 : 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Subscribe", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 15),
            const Text("Get the latest deals and updates from us.", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 15),
            Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Your email address',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Color(0xFF333333),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, child: const Text("Go"), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white)),
              ],
            )
          ],
        ),
      ),
    ];
  }


  Widget _buildFooterLinks(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 15),
        ...links.map((link) => _FooterLink(link)).toList(),
      ],
    );
  }
}

// Custom widget for header links with hover effect
class _HeaderLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap; // Added onTap callback
  const _HeaderLink(this.text, {required this.onTap, super.key});

  @override
  __HeaderLinkState createState() => __HeaderLinkState();
}

class __HeaderLinkState extends State<_HeaderLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector( // Wrapped with GestureDetector to make it clickable
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: _isHovered ? Colors.blue.shade200 : Colors.white,
              decoration: _isHovered ? TextDecoration.underline : TextDecoration.none,
              decorationColor: Colors.blue.shade200,
            ),
          ),
        ),
      ),
    );
  }
}

// Custom widget for footer links with hover effect
class _FooterLink extends StatefulWidget {
  final String text;
  const _FooterLink(this.text);

  @override
  __FooterLinkState createState() => __FooterLinkState();
}

class __FooterLinkState extends State<_FooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            widget.text,
            style: TextStyle(
              color: _isHovered ? Colors.blue.shade300 : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

// Custom widget for social icons with hover effect
class _SocialIcon extends StatefulWidget {
  final IconData icon;
  const _SocialIcon(this.icon);

  @override
  __SocialIconState createState() => __SocialIconState();
}

class __SocialIconState extends State<_SocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: IconButton(
        onPressed: () {},
        icon: Icon(
          widget.icon,
          color: _isHovered ? Colors.blue.shade300 : Colors.white,
        ),
      ),
    );
  }
}


// A simple Fade-in and slide-up animation widget
class FadeInUp extends StatefulWidget {
  final Widget child;
  final double delay;

  const FadeInUp({super.key, required this.child, this.delay = 0});

  @override
  _FadeInUpState createState() => _FadeInUpState();
}

class _FadeInUpState extends State<FadeInUp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _position;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _position = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(Duration(milliseconds: (widget.delay * 1000).round()), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _position,
        child: widget.child,
      ),
    );
  }
}

