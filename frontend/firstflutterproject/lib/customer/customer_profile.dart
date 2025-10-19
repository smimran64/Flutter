import 'package:firstflutterproject/customer/Bookings_history.dart';
import 'package:firstflutterproject/entity/customer_model.dart';
import 'package:firstflutterproject/home/home_page.dart';
import 'package:firstflutterproject/page/loginpage.dart';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For modern icons

// --- Customer Color Palette (Vibrant and Friendly) ---
const Color kCustomerPrimary = Color(0xFF00ACC1); // Cyan/Teal
const Color kCustomerAccent = Color(0xFFFF9800); // Orange/Amber
const Color kCustomerGradientStart = Color(0xFF4DD0E1); // Light Cyan
const Color kCustomerGradientEnd = Color(0xFF0097A7); // Darker Cyan
const Color kCustomerBackground = Color(0xFFF0F8FF); // Very Light Blue/White

class CustomerProfile extends StatelessWidget {
  final CustomerModel profile;
  final AuthService _authService = AuthService();

  CustomerProfile({Key? key, required this.profile}) : super(key: key);

  // --- Helper for Profile Fields ---
  Widget _buildProfileField(IconData icon, String label, String value, int index) {
    // Alternating background for visual appeal
    final Color bgColor = (index % 2 == 0)
        ? kCustomerPrimary.withOpacity(0.1)
        : kCustomerPrimary.withOpacity(0.05);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kCustomerPrimary.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: kCustomerPrimary, size: 24),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: kCustomerPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.1, delay: (index * 100).ms);
  }

  // --- Drawer Item Builder (Wrapper) ---
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
    Color? hoverColor,
  }) {
    textColor ??= Colors.black87;
    iconColor ??= kCustomerPrimary;
    hoverColor ??= kCustomerPrimary.withOpacity(0.1);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: _DrawerItemAnimatedCustomer(
        icon: icon,
        title: title,
        onTap: onTap,
        textColor: textColor,
        iconColor: iconColor,
        hoverColor: hoverColor,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    const String baseUrl = "http://localhost:8082/images/customer";
    final String? photoName = profile.image;
    final String? photoUrl =
    (photoName != null && photoName.isNotEmpty) ? "$baseUrl/$photoName" : null;

    final String dob = profile.dateOfBirth != null
        ? profile.dateOfBirth!.toIso8601String().split('T')[0]
        : 'N/A';

    // --- List of Profile Data for Iteration ---
    final List<Map<String, dynamic>> profileData = [
      {'icon': Icons.email_rounded, 'label': 'Email', 'value': profile.email ?? 'N/A'},
      {'icon': Icons.phone_android_rounded, 'label': 'Phone', 'value': profile.phone ?? 'N/A'},
      {'icon': FontAwesomeIcons.mapMarkerAlt, 'label': 'Address', 'value': profile.address ?? 'N/A'},
      {'icon': FontAwesomeIcons.venusMars, 'label': 'Gender', 'value': profile.gender ?? 'N/A'},
      {'icon': Icons.calendar_today_rounded, 'label': 'Date Of Birth', 'value': dob},
    ];

    return Scaffold(
      backgroundColor: kCustomerBackground,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: kCustomerPrimary,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // --- CUSTOM DRAWER ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Custom Drawer Header with Gradient
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [kCustomerGradientStart, kCustomerGradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: Text(
                profile.name ?? 'Unknown User',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
              ),
              accountEmail: Text(
                profile.email ?? 'N/A',
                style: GoogleFonts.poppins(fontSize: 14, color: kCustomerAccent),
              ),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kCustomerAccent, width: 3),
                ),
                child: CircleAvatar(
                  backgroundImage: (photoUrl != null)
                      ? NetworkImage(photoUrl)
                      : const AssetImage('assets/default_user.png') as ImageProvider,
                  backgroundColor: Colors.white,
                ),
              ),
            ),

            // --- Drawer Menu Items with Animation ---
            _buildDrawerItem(
              icon: Icons.person_rounded,
              title: 'View My Profile',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.edit_note_rounded,
              title: 'Edit Account Details',
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.home,
              title: 'Home Page',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage())
                );
              },
            ),
            const Divider(height: 20, thickness: 1, indent: 15, endIndent: 15),

            _buildDrawerItem(
              icon: Icons.history_toggle_off_rounded,
              title: 'Booking History',
              onTap: () {
                if (profile.id != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingHistoryPage(customerId: profile.id!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Customer ID not found")),
                  );
                }
              },
              iconColor: kCustomerAccent,
            ),
            _buildDrawerItem(
              icon: Icons.favorite_border_rounded,
              title: 'Saved Hotels/Wishlist',
              onTap: () => Navigator.pop(context),
              iconColor: kCustomerAccent,
            ),
            const Divider(height: 20, thickness: 1, indent: 15, endIndent: 15),

            _buildDrawerItem(
              icon: Icons.settings_rounded,
              title: 'Settings',
              onTap: () => Navigator.pop(context),
            ),

            // Logout Button (Red and Prominent)
            _buildDrawerItem(
              icon: Icons.logout_rounded,
              title: 'Logout',
              onTap: () async {
                await _authService.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Loginpage()),
                );
              },
              textColor: Colors.red.shade700,
              iconColor: Colors.red.shade700,
              hoverColor: Colors.red.withOpacity(0.1),
            ),
          ],
        ),
      ),

      // --- BODY CONTENT ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image with Animation
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  )
                ],
                border: Border.all(
                  color: kCustomerAccent, // Orange border
                  width: 4,
                ),
              ),
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white,
                backgroundImage: (photoUrl != null)
                    ? NetworkImage(photoUrl)
                    : const AssetImage("assets/default_user.png") as ImageProvider,
              ),
            ).animate().fadeIn(duration: 600.ms).scale(curve: Curves.easeOutBack, duration: 400.ms),

            const SizedBox(height: 25),

            // Name
            Text(
              profile.name ?? 'Guest User',
              style: GoogleFonts.montserrat(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: kCustomerPrimary,
              ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 5),

            // Status/Welcome
            Text(
              "Your personalized hotel assistant.",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ).animate().fadeIn(delay: 300.ms),

            const SizedBox(height: 30),

            // Profile Information Cards (Dynamically built with animation)
            ...profileData.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> data = entry.value;
              return _buildProfileField(
                  data['icon'], data['label'], data['value'], index);
            }).toList(),

            const SizedBox(height: 40),

            // Edit Profile Button
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Add edit functionality or navigation
              },
              icon: const Icon(Icons.edit_rounded, size: 20),
              label: Text(
                "Update My Details",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kCustomerAccent,
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor: kCustomerAccent.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
            ).animate().scale(delay: 800.ms, duration: 400.ms, curve: Curves.easeOutBack),
          ],
        ),
      ),
    );
  }
}


// --- CUSTOM STATEFUL WIDGET FOR DRAWER HOVER ANIMATION ---

class _DrawerItemAnimatedCustomer extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color iconColor;
  final Color textColor;
  final Color hoverColor;

  const _DrawerItemAnimatedCustomer({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor = kCustomerPrimary,
    this.textColor = Colors.black,
    this.hoverColor = const Color(0xFFE0E0E0),
  }) : super(key: key);

  @override
  _DrawerItemAnimatedCustomerState createState() => _DrawerItemAnimatedCustomerState();
}


class _DrawerItemAnimatedCustomerState extends State<_DrawerItemAnimatedCustomer> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        // Floating effect on hover
        margin: _hovering ? const EdgeInsets.symmetric(horizontal: 10, vertical: 4) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: _hovering ? widget.hoverColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: _hovering
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ]
              : null,
        ),
        child: ListTile(
          leading: Icon(widget.icon, color: widget.iconColor, size: 24),
          title: Text(
            widget.title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: widget.textColor,
              fontWeight: _hovering ? FontWeight.w700 : FontWeight.w500, // Thicker font on hover
            ),
          ),
          trailing: _hovering
              ? Icon(Icons.arrow_forward_ios_rounded, size: 16, color: widget.iconColor)
              : const Icon(Icons.chevron_right_rounded, size: 16, color: Colors.grey),
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