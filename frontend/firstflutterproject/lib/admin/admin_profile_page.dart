import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

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

    final String baseUrl = "http://localhost:8082/images/Admins";
    final String? photoName = profile['image'];
    final String? photoUrl = (photoName != null && photoName.isNotEmpty)
        ? "$baseUrl/$photoName"
        : null;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Admin Profile',
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
          gradient: LinearGradient(
            colors: [Color(0xFF6D0EB5), Color(0xFF4059F1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfileImage(photoUrl),
                const SizedBox(height: 20),
                // Here we pass an index or alternate boolean to pick colors
                _buildProfileField(0, "Name", profile['name'] ?? 'Unknown', Icons.person),
                _buildProfileField(1, "Email", profile['email'] ?? 'N/A', Icons.email),
                _buildProfileField(0, "Address", profile['address'] ?? 'N/A', FontAwesomeIcons.mapMarkerAlt),
                _buildProfileField(1, "Gender", profile['gender'] ?? 'N/A', FontAwesomeIcons.venusMars),
                _buildProfileField(0, "Date of Birth", profile['dateOfBirth'] ?? 'N/A', FontAwesomeIcons.calendarDay),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Add edit functionality or navigation
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Profile"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF6D0EB5),
                    elevation: 8,
                    shadowColor: Colors.black45,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    textStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(String? photoUrl) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
      ),
      child: CircleAvatar(
        radius: 70,
        backgroundImage: (photoUrl != null)
            ? NetworkImage(photoUrl)
            : const AssetImage("assets/default_user.png") as ImageProvider,
        backgroundColor: Colors.grey[200],
      ),
    );
  }


  Widget _buildProfileField(int index, String label, String value, IconData icon) {
    // Two colors to alternate
    final Color bgColor = (index % 2 == 0)
        ? Colors.white.withOpacity(0.25)
        : Colors.white.withOpacity(0.15);
    final Color iconBgColor = (index % 2 == 0)
        ? Colors.white.withOpacity(0.35)
        : Colors.white.withOpacity(0.2);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
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

  Drawer _buildDrawer(
      BuildContext context,
      Map<String, dynamic> profile,
      LocationService locationService,
      HotelService hotelService,
      HotelAminitiesService hotelAminitiesService,
      HotelInformationService hotelInformationService,
      HotelPhotoService hotelPhotoService,
      ) {
    final String baseUrl = "http://localhost:8082/images/Admins";
    final String? photoName = profile['image'];
    final String? photoUrl = (photoName != null && photoName.isNotEmpty)
        ? "$baseUrl/$photoName"
        : null;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6D0EB5), Color(0xFF4059F1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(
              profile['name'] ?? 'Unknown User',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            accountEmail: Text(
              profile['email'] ?? 'N/A',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: (photoUrl != null)
                  ? NetworkImage(photoUrl)
                  : const AssetImage('assets/default_user.png') as ImageProvider,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: FontAwesomeIcons.user,
                  title: 'My Profile',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.userEdit,
                  title: 'Edit Profile',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.mapMarkedAlt,
                  title: 'Location History',
                  onTap: () async {
                    final location = await locationService.getAllLocations();
                    if (location != null) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => LocationPage()));
                    }
                  },
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.hotel,
                  title: 'All Hotels',
                  onTap: () async {
                    final hotel = await hotelService.getAllHotels();
                    if (hotel != null) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ViewAllHotel()));
                    }
                  },
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.clipboardList,
                  title: 'All Hotels Amenities',
                  onTap: () async {
                    final amenities = await hotelAminitiesService.getAllAmenities();
                    if (amenities != null) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ViewAllAmenities()));
                    }
                  },
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.infoCircle,
                  title: 'All Hotels Information',
                  onTap: () async {
                    final info = await hotelInformationService.getAllHotelInformation();
                    if (info != null) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ViewAllHotelInfoPage()));
                    }
                  },
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.images,
                  title: 'Photo Gallery',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => HotelPhotoGalleryPage()));
                  },
                ),
                _buildDrawerItem(
                  icon: FontAwesomeIcons.cog,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
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
                  textColor: Colors.red,
                  iconColor: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
    Color? hoverColor, // 👈 NEW
  }) {
    textColor ??= Colors.black87;
    iconColor ??= Colors.deepPurple;
    hoverColor ??= Colors.deepPurple.withOpacity(0.08); // 👈 default hover

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: _DrawerItemAnimated(
        icon: icon,
        title: title,
        onTap: onTap,
        textColor: textColor,
        iconColor: iconColor,
        hoverColor: hoverColor, // 👈 pass it in
      ),
    );
  }

}

/// A custom widget for a drawer item that animates hover background
class _DrawerItemAnimated extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color iconColor;
  final Color textColor;
  final Color hoverColor; // 👈 NEW

  const _DrawerItemAnimated({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor = Colors.deepPurple,
    this.textColor = Colors.black,
    this.hoverColor = const Color(0xFFE0E0E0), // 👈 fallback
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
        color: _hovering ? Colors.deepPurple.withOpacity(0.1) : Colors.transparent,
        child: ListTile(
          leading: FaIcon(widget.icon, color: widget.iconColor),
          title: Text(
            widget.title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: widget.textColor,
              fontWeight: _hovering ? FontWeight.w600 : FontWeight.w500,
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


