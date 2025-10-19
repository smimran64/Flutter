import 'package:firstflutterproject/bookings/bookingsfor_hotel_admin.dart';
import 'package:firstflutterproject/hotel/add_hotel_page.dart';
import 'package:firstflutterproject/hotel_admin/hotel_managed_by_hotel_admin.dart';
import 'package:firstflutterproject/hotel_amenities/add_hotel_amenities.dart';
import 'package:firstflutterproject/hotel_amenities/view_hotelamenititesfor_hotel_admin.dart';
import 'package:firstflutterproject/hotel_information/hotel_informationfor_hotel_admin.dart';
import 'package:firstflutterproject/hotel_information/hotel_informationfor_viewfor_hoteladmin.dart';
import 'package:firstflutterproject/hotel_photo_gallery/add_hotel_photo.dart';
import 'package:firstflutterproject/hotel_photo_gallery/view_galleryfor_hotel_admin.dart';
import 'package:firstflutterproject/page/loginpage.dart';
import 'package:firstflutterproject/rooms/add_room.dart';
import 'package:firstflutterproject/rooms/room_for_hotel_admin.dart';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // ✨ Import animation package
import 'dart:ui'; // For BackdropFilter

class HotelAdminProfile extends StatelessWidget {
  final Map<String, dynamic> profile;
  final AuthService _authService = AuthService();

  HotelAdminProfile({Key? key, required this.profile}) : super(key: key);

  // ✨ Helper widget for beautifully animated and styled drawer items
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: color ?? Colors.white.withOpacity(0.8), size: 22),
            const SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                color: color ?? Colors.white.withOpacity(0.9),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideX(begin: -0.2);
  }

  // ✨ Helper for creating titled dividers in the drawer
  Widget _buildDrawerDivider(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
          fontSize: 12,
        ),
      ),
    );
  }

  // ✨ Helper for building profile info rows
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF00796B), size: 22),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String baseUrl = "http://localhost:8082/images/hotelAdmin";
    final String? photoName = profile['image'];
    final String? photoUrl = (photoName != null && photoName.isNotEmpty) ? "$baseUrl/$photoName" : null;

    return Scaffold(
      // ✨ A beautiful gradient background for the whole screen
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.1),
        ),
        backgroundColor: Colors.transparent, // ✨ Transparent AppBar
        elevation: 0,
      ),
      drawer: Drawer(
        child: Container(
          // ✨ Stunning gradient background for the drawer
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // ✨ Custom, modern drawer header
              SizedBox(
                height: 240,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage("https://images.pexels.com/photos/2098427/pexels-photo-2098427.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken)
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: (photoUrl != null)
                            ? NetworkImage(photoUrl)
                            : const AssetImage('assets/default_user.png') as ImageProvider,
                      ).animate().scale(duration: 500.ms, curve: Curves.bounceOut),
                      const SizedBox(height: 12),
                      Text(
                        profile['name'] ?? 'Unknown User',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                      ).animate().fadeIn(delay: 200.ms),
                      const SizedBox(height: 4),
                      Text(
                        profile['user']?['email'] ?? 'N/A',
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                      ).animate().fadeIn(delay: 300.ms),
                    ],
                  ),
                ),
              ),
              // ✨ Organized and animated drawer menu items
              _buildDrawerDivider("Hotel Management"),
              _buildDrawerItem(icon: Icons.business_sharp, title: 'Manage My Hotels', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyHotelsPage()))),
              _buildDrawerItem(icon: Icons.add_business_outlined, title: 'Add New Hotel', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddHotelPage()))),

              _buildDrawerDivider("Room Management"),
              _buildDrawerItem(icon: Icons.king_bed_outlined, title: 'Add a Room', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddRoomPage()))),
              _buildDrawerItem(icon: Icons.meeting_room_outlined, title: 'View All Rooms', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HotelForHotelAdminPage()))),
              _buildDrawerItem(icon: Icons.meeting_room_outlined, title: 'View Bookings', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookingsByHotelPage()))),

              _buildDrawerDivider("Content & Media"),
              _buildDrawerItem(icon: Icons.info_outline, title: 'Save Hotel Information', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HotelInformationAddPage()))),
              _buildDrawerItem(icon: Icons.view_quilt_outlined, title: 'View Hotel Information', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HotelInformationViewPage()))),
              _buildDrawerItem(icon: Icons.deck_outlined, title: 'Add Hotel Amenities', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddHotelAmenitiesPage()))),
              _buildDrawerItem(icon: Icons.widgets_outlined, title: 'View Hotel Amenities', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAllAmenitiesByHotelPage()))),
              _buildDrawerItem(icon: Icons.add_photo_alternate_outlined, title: 'Add Hotel Photos', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddHotelPhotoPage()))),
              _buildDrawerItem(icon: Icons.photo_library_outlined, title: 'View Hotel Gallery', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewGalleryPage()))),

              _buildDrawerDivider("Account"),
              _buildDrawerItem(
                icon: Icons.logout,
                title: 'Logout',
                color: const Color(0xFFFF8A80),
                onTap: () async {
                  await _authService.logout();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loginpage()));
                },
              ),
            ],
          ),
        ),
      ),
      // ✨ Animated main body content
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFE0F2F1), Color(0xFFFAFAFA)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
            )
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ✨ A stylish header with profile picture
              SizedBox(
                height: 280,
                child: Stack(
                  children: [
                    Container(
                      height: 220,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF00796B), Color(0xFF004D40)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                      ),
                    ),
                    Positioned(
                      top: 150,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, spreadRadius: 5)],
                          ),
                          child: CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: (photoUrl != null)
                                ? NetworkImage(photoUrl)
                                : const AssetImage("assets/default_user.png") as ImageProvider,
                          ),
                        ).animate(onPlay: (c) => c.repeat())
                            .shimmer(delay: 2000.ms, duration: 1500.ms, color: Colors.teal.withOpacity(0.5)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // ✨ Animated Name and Email
              Text(
                profile['name'] ?? 'Unknown',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.5),
              const SizedBox(height: 5),
              Text(
                "Hotel Administrator",
                style: TextStyle(fontSize: 16, color: Colors.teal.shade700, fontWeight: FontWeight.w500),
              ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(begin: 0.5),

              // ✨ A modern card for detailed info
              Container(
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.email_outlined, "Email", profile['email'] ?? 'N/A'),
                    const Divider(height: 20),
                    _buildInfoRow(Icons.location_on_outlined, "Address", profile['address'] ?? 'N/A'),
                    const Divider(height: 20),
                    _buildInfoRow(Icons.person_outline, "Gender", profile['gender'] ?? 'N/A'),
                    const Divider(height: 20),
                    _buildInfoRow(Icons.calendar_today_outlined, "Date Of Birth", profile['dateOfBirth'] ?? 'N/A'),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 600.ms).moveY(begin: 50),

              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text("Edit Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: const Color(0xFFF57C00),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 8,
                  shadowColor: Colors.orange.withOpacity(0.5),
                ),
              ).animate(onPlay: (c) => c.repeat(period: 3000.ms))
                  .shake(hz: 1, duration: 400.ms, delay: 2000.ms, curve: Curves.easeInOut),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}