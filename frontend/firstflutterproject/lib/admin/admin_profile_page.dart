import 'package:firstflutterproject/bookings/bookingsfor_admin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:firstflutterproject/hotel/view_all_hotel.dart';
import 'package:firstflutterproject/hotel_amenities/view_all_amenities.dart';
import 'package:firstflutterproject/hotel_information/view_hotel_information.dart';
import 'package:firstflutterproject/hotel_photo_gallery/view_photo_by_id.dart';
import 'package:firstflutterproject/location/view_location_page.dart';
import 'package:firstflutterproject/page/loginpage.dart';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:firstflutterproject/service/hotel_aminities_service.dart';
import 'package:firstflutterproject/service/hotel_information_service.dart';
import 'package:firstflutterproject/service/hotel_photo_service.dart';
import 'package:firstflutterproject/service/hotel_service.dart';
import 'package:firstflutterproject/service/location_service.dart';

// --- Color Palette for Premium Admin Look ---
const Color kPrimary = Color(0xFF0D47A1); // Deep Navy Blue
const Color kAccent = Color(0xFFFFCC80); // Light Gold/Amber
const Color kSecondary = Color(0xFF00BFA5); // Teal
const Color kGradientStart = Color(0xFF1565C0); // Lighter Blue
const Color kGradientEnd = Color(0xFF0D47A1); // Deep Navy

class AdminProfilePage extends StatelessWidget {
  final Map<String, dynamic> profile;

  final AuthService _authService = AuthService();
  final HotelService _hotelService = HotelService();

  AdminProfilePage({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocationService locationService = LocationService();
    HotelService hotelService = HotelService();
    HotelAminitiesService hotelAminitiesService = HotelAminitiesService();
    HotelInformationService hotelInformationService = HotelInformationService();
    HotelPhotoService hotelPhotoService = HotelPhotoService();

    // NOTE: Using a static path is generally risky; this assumes the API is running locally.
    const String baseUrl = "http://localhost:8082/images/Admins";
    final String? photoName = profile['image'];
    final String? photoUrl = (photoName != null && photoName.isNotEmpty)
        ? "$baseUrl/$photoName"
        : null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Admin Dashboard',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: _buildDrawer(
        context,
        profile,
        locationService,
        hotelService,
        hotelAminitiesService,
        hotelInformationService,
        hotelPhotoService,
      ),
      body: Container(
        decoration: const BoxDecoration(
          // Updated Gradient for Professional Look
          gradient: LinearGradient(
            colors: [kGradientStart, kGradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            // Adjusted padding to look better with the gradient background
            padding: const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfileImage(photoUrl)
                    .animate().fadeIn(duration: 800.ms).slideY(begin: -0.5),

                const SizedBox(height: 30),

                Text(
                  profile['name'] ?? 'Hotel Admin',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 4),

                Text(
                  'System Administrator',
                  style: GoogleFonts.poppins(
                    color: kAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 30),

                // Animated Profile Fields
                Column(
                  children: [
                    _buildProfileField(0, "Email", profile['email'] ?? 'N/A', Icons.email),
                    _buildProfileField(1, "Phone", profile['phone'] ?? 'N/A', Icons.phone),
                    _buildProfileField(0, "Address", profile['address'] ?? 'N/A', FontAwesomeIcons.mapMarkerAlt),
                    _buildProfileField(1, "Gender", profile['gender'] ?? 'N/A', FontAwesomeIcons.venusMars),
                    _buildProfileField(0, "Date of Birth", profile['dateOfBirth'] ?? 'N/A', FontAwesomeIcons.calendarDay),
                  ].animate(interval: 100.ms).fadeIn(duration: 500.ms).slideX(begin: 0.1),
                ),

                const SizedBox(height: 40),

                // Edit Profile Button with enhanced style
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Add edit functionality or navigation
                  },
                  icon: const Icon(Icons.edit_rounded, size: 20),
                  label: Text(
                    "Update Profile",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccent,
                    foregroundColor: kPrimary,
                    elevation: 10,
                    shadowColor: kPrimary.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                ).animate().scale(delay: 1000.ms, duration: 400.ms, curve: Curves.easeOutBack),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Profile Image Builder (Enhanced) ---
  Widget _buildProfileImage(String? photoUrl) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      // Larger circle with a distinct border color
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
        border: Border.all(
          color: kAccent, // Gold border for premium look
          width: 5,
        ),
      ),
      child: CircleAvatar(
        radius: 80, // Slightly larger
        backgroundImage: (photoUrl != null)
            ? NetworkImage(photoUrl)
            : const AssetImage("assets/default_user.png") as ImageProvider,
        backgroundColor: Colors.white, // White background behind image
      ),
    );
  }

  // --- Profile Field Builder (Enhanced) ---
  Widget _buildProfileField(int index, String label, String value, IconData icon) {
    // Alternating colors using the professional palette
    final Color bgColor = (index % 2 == 0)
        ? Colors.white.withOpacity(0.18)
        : Colors.white.withOpacity(0.1);
    final Color iconBgColor = (index % 2 == 0)
        ? kAccent.withOpacity(0.7)
        : kSecondary.withOpacity(0.7);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15), // Softer corners
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10), // Squared icon background
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: kPrimary, size: 20), // Navy icon color
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- NEW: Drawer Section Header Widget ---
  Widget _buildDrawerHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: kPrimary.withOpacity(0.7),
        ),
      ),
    );
  }


  // --- Drawer Builder (Enhanced) ---
  Drawer _buildDrawer(
      BuildContext context,
      Map<String, dynamic> profile,
      LocationService locationService,
      HotelService hotelService,
      HotelAminitiesService hotelAminitiesService,
      HotelInformationService hotelInformationService,
      HotelPhotoService hotelPhotoService,
      ) {
    const String baseUrl = "http://localhost:8082/images/Admins";
    final String? photoName = profile['image'];
    final String? photoUrl = (photoName != null && photoName.isNotEmpty)
        ? "$baseUrl/$photoName"
        : null;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Enhanced Drawer Header
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [kPrimary, kGradientStart], // Premium Blue Gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(
              profile['name'] ?? 'Hotel Partner',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            accountEmail: Text(
              profile['email'] ?? 'N/A',
              style: GoogleFonts.poppins(fontSize: 14, color: kAccent), // Gold email
            ),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kAccent, width: 3), // Accent ring
              ),
              child: CircleAvatar(
                backgroundImage: (photoUrl != null)
                    ? NetworkImage(photoUrl)
                    : const AssetImage('assets/default_user.png') as ImageProvider,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // --- SECTION 1: Profile & Account ---
                _buildDrawerHeader('Account & Profile'),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.solidUserCircle,
                  title: 'My Profile',
                  onTap: () {
                    Navigator.pop(context);
                  },
                  iconColor: kPrimary,
                  hoverColor: kPrimary.withOpacity(0.1),
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.userEdit,
                  title: 'Edit Profile',
                  onTap: () {
                    Navigator.pop(context);
                  },
                  iconColor: kPrimary,
                  hoverColor: kPrimary.withOpacity(0.1),
                ),
                const Divider(color: Colors.grey, height: 20, thickness: 0.5, indent: 20, endIndent: 20),


                // --- SECTION 2: Hotel & Resources Management ---
                _buildDrawerHeader('Resource Management'),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.mapMarkerAlt,
                  title: 'Locations Management',
                  onTap: () async {
                    final location = await locationService.getAllLocations();
                    if (location != null) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => LocationPage()));
                    }
                  },
                  iconColor: kSecondary, // Teal
                  hoverColor: kSecondary.withOpacity(0.1),
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.hotel,
                  title: 'Hotel Management',
                  onTap: () async {
                    final hotel = await hotelService.getAllHotels();
                    if (hotel != null) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ViewAllHotel()));
                    }
                  },
                  iconColor: kSecondary,
                  hoverColor: kSecondary.withOpacity(0.1),
                ),

                _buildDrawerItem(
                  icon: FontAwesomeIcons.hotel,
                  title: 'View All Bookings',
                  onTap: () async {
                    final hotel = await hotelService.getAllHotels();
                    if (hotel != null) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => BookingsForAdminPage()));
                    }
                  },
                  iconColor: kSecondary,
                  hoverColor: kSecondary.withOpacity(0.1),
                ),

                _buildDrawerItem(
                  icon: FontAwesomeIcons.clipboardList,
                  title: 'Amenities Catalogue',
                  onTap: () async {
                    final amenities = await hotelAminitiesService.getAllAmenities();
                    if (amenities != null) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ViewAllAmenities()));
                    }
                  },
                  iconColor: kSecondary,
                  hoverColor: kSecondary.withOpacity(0.1),
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.infoCircle,
                  title: 'Hotel Info & Details',
                  onTap: () async {
                    final info = await hotelInformationService.getAllHotelInformation();
                    if (info != null) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ViewAllHotelInfoPage()));
                    }
                  },
                  iconColor: kSecondary,
                  hoverColor: kSecondary.withOpacity(0.1),
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.images,
                  title: 'Photo Gallery',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => HotelPhotoGalleryPage()));
                  },
                  iconColor: kSecondary,
                  hoverColor: kSecondary.withOpacity(0.1),
                ),
                const Divider(color: Colors.grey, height: 20, thickness: 0.5, indent: 20, endIndent: 20),

                // --- SECTION 3: Tools & Logout ---
                _buildDrawerHeader('System Tools'),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.cog,
                  title: 'Settings & Configurations',
                  onTap: () {
                    Navigator.pop(context);
                  },
                  iconColor: kPrimary,
                  hoverColor: kPrimary.withOpacity(0.1),
                ),

                // Logout button is prominent and red
                _buildDrawerItem(
                  icon: FontAwesomeIcons.signOutAlt,
                  title: 'Logout',
                  onTap: () async {
                    await _authService.logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => Loginpage()),
                    );
                  },
                  textColor: Colors.red.shade700,
                  iconColor: Colors.red.shade700,
                  hoverColor: Colors.red.withOpacity(0.1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Drawer Item Builder (Unchanged Signature) ---
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
    Color? hoverColor,
  }) {
    textColor ??= kPrimary;
    iconColor ??= kPrimary;
    hoverColor ??= kPrimary.withOpacity(0.08);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: _DrawerItemAnimated(
        icon: icon,
        title: title,
        onTap: onTap,
        textColor: textColor,
        iconColor: iconColor,
        hoverColor: hoverColor,
      ),
    );
  }
}

/// A custom widget for a drawer item that animates hover background (Enhanced)
class _DrawerItemAnimated extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color iconColor;
  final Color textColor;
  final Color hoverColor;

  const _DrawerItemAnimated({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor = kPrimary,
    this.textColor = Colors.black,
    this.hoverColor = const Color(0xFFE0E0E0),
  }) : super(key: key);

  @override
  _DrawerItemAnimatedState createState() => _DrawerItemAnimatedState();
}


class _DrawerItemAnimatedState extends State<_DrawerItemAnimated> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        // Added a subtle shadow and border for a floating effect on hover
        margin: _hovering ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: _hovering ? widget.hoverColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: _hovering
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ]
              : null,
        ),
        child: ListTile(
          leading: FaIcon(widget.icon, color: widget.iconColor),
          title: Text(
            widget.title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: widget.textColor,
              fontWeight: _hovering ? FontWeight.w700 : FontWeight.w500, // Thicker font on hover
            ),
          ),
          trailing: const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
          onTap: widget.onTap,
        ),
      ),
    );
  }

  void _setHover(bool hover) {
    setState(() {
      _hovering = hover;
    });
  }
}