import 'package:firstflutterproject/entity/customer_model.dart';
import 'package:firstflutterproject/hotel_admin/hotel_admin_profile.dart';
import 'package:firstflutterproject/hotel_admin/hotel_admin_registration.dart';
import 'package:firstflutterproject/password/forgot_password.dart';
import 'package:firstflutterproject/service/hotel_admin_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firstflutterproject/admin/admin_registration_page.dart';
import 'package:firstflutterproject/admin/admin_profile_page.dart';
import 'package:firstflutterproject/customer/customer_profile.dart';
import 'package:firstflutterproject/page/registration.dart';
import 'package:firstflutterproject/service/admin_service.dart';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:firstflutterproject/service/customer_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  final VoidCallback? redirectAfterLogin;

  const Loginpage({Key? key, this.redirectAfterLogin}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> with TickerProviderStateMixin {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final storage = new FlutterSecureStorage();

  AuthService authService = AuthService();
  CustomerService customerService = CustomerService();
  AdminService adminService = AdminService();
  HotelAdminService hotelAdminService = HotelAdminService();

  var _isVisible = false;

  // New: For Login Button animation
  bool _isButtonTapped = false;

  // New: For Logo animation/hover effect
  double _logoScale = 1.0;


  @override
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff4a148c), Color(0xff880e4f)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  SizedBox(height: deviceHeight * 0.07),

                  // ----------------------------------------------------
                  // --- NEW: Logo with Slow Slide-Down Entrance Animation ---
                  // ----------------------------------------------------
                  TweenAnimationBuilder<double>(
                    // Animate from top (Offset 30) to its final position (Offset 0)
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 700), // Slower animation
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          // Moves the logo from above (30px offset) down to its place
                          offset: Offset(0, 30 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setLogoState) {
                        return GestureDetector(
                          onTapDown: (_) => setLogoState(() => _logoScale = 0.95),
                          onTapUp: (_) => setLogoState(() => _logoScale = 1.0),
                          onTapCancel: () => setLogoState(() => _logoScale = 1.0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                            transform: Matrix4.identity()..scale(_logoScale),
                            height: deviceHeight * 0.22,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const CircleAvatar(
                                backgroundImage: AssetImage('assets/images/hotellogo.jpg'),
                                radius: 90,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // ----------------------------------------------------
                  // --- END OF ANIMATED LOGO ---
                  // ----------------------------------------------------

                  SizedBox(height: 30),

                  // --- Stylish Headers ---
                  Text(
                    'Elevate Your Stay!',
                    style: GoogleFonts.montserrat(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      shadows: [
                        const Shadow(
                          blurRadius: 5.0,
                          color: Colors.black38,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Login to unlock exclusive experiences.',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  SizedBox(height: 40),

                  // Email Field (Now with a modern glass-morphism style)
                  _buildTextField(
                    controller: email,
                    icon: Icons.email_rounded,
                    hintText: 'Email Address',
                    isPassword: false,
                  ),
                  SizedBox(height: 20),

                  // Password Field (Now with a modern glass-morphism style)
                  _buildTextField(
                    controller: password,
                    icon: Icons.lock_open_rounded,
                    hintText: 'Secret Key',
                    isPassword: true,
                    toggleVisibility: () {
                      setState(() {
                        _isVisible = !_isVisible;
                      });
                    },
                    isVisible: _isVisible,
                  ),

                  // Forgot Password Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPasswordScreen())
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.poppins(
                          color: Colors.amberAccent.shade100,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // --- Outstanding Modern Login Button (Pulsing/Tapped Effect) ---
                  GestureDetector(
                    onTapDown: (_) => setState(() => _isButtonTapped = true),
                    onTapUp: (_) => setState(() => _isButtonTapped = false),
                    onTapCancel: () => setState(() => _isButtonTapped = false),
                    onTap: () {
                      // Call the original method
                      loginUser(context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: double.infinity,
                      height: 55,
                      // Scale down slightly when tapped
                      transform: Matrix4.identity()..scale(_isButtonTapped ? 0.98 : 1.0),
                      decoration: BoxDecoration(
                        // Super modern gradient button style
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.deepPurple.shade50],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: _isButtonTapped ? 1 : 5, // Pulsing shadow
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'LOG IN',
                          style: GoogleFonts.montserrat(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xff4a148c), // Dark purple text
                          ),
                        ),
                      ),
                    ),
                  ),


                  SizedBox(height: 40),

                  // --- Registration as Customer Text ---
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "New here?\n",
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: 'Create a Customer Account!',
                          style: GoogleFonts.poppins(
                            color: Colors.amberAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.amberAccent,
                            height: 1.5,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Registration()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // --- Registration as Hotel Admin (Unique, Elevated Button) ---
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HotelAdminRegistration()),
                      );
                    },
                    icon: const Icon(Icons.apartment_rounded, size: 24),
                    label: Text(
                      'Hotel Manager Access',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      // Unique, eye-catching color
                      backgroundColor: Colors.tealAccent.shade400,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      elevation: 10,
                      shadowColor: Colors.tealAccent.shade200,
                    ),
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- _buildTextField: Enhanced with Glass-Morphism Look ---
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? toggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        // Glass-morphism effect: semi-transparent white background
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.3), // Light border for definition
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(4, 4),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isVisible,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.white70),
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(color: Colors.white54, fontWeight: FontWeight.w400),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              isVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
              color: Colors.white70,
            ),
            onPressed: toggleVisibility,
          )
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        ),
      ),
    );
  }

  // --- Existing login function (Unchanged) ---
  Future<void> loginUser(BuildContext context) async {
    try {
      final response = await authService.login(email.text, password.text);

      final role = await authService.getUserRole();

      if (role == 'ADMIN') {
        final profile = await adminService.getAdminProfile();
        if (profile != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminProfilePage(profile: profile)),
          );
        }
      } else if (role == 'CUSTOMER') {
        final profileJson = await customerService.getCustomerProfile();
        final profile = CustomerModel.fromJson(profileJson!); // <-- fix here

        final customers = AuthService().saveCustomerId();
        final customersId = AuthService().saveCustomerId();

          if (profile != null) {
          // SharedPreferences e customer info save kora
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('customerName', profile.name ?? '');
          prefs.setString('customerEmail', profile.email ?? '');
          prefs.setString('customerPhone', profile.phone ?? '');
          prefs.setString('customerAddress', profile.address ?? '');

          if (profile.id != null) {
            prefs.setInt('customerId', profile.id!);
          }

          // Check if a redirect callback is provided (for Booking Page)
          if (widget.redirectAfterLogin != null) {
            widget.redirectAfterLogin!(); // Navigate to Booking Page
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CustomerProfile(profile: profile)),
            );
          }
        }
      } else if (role == 'HOTEL_ADMIN') {
        final profile = await hotelAdminService.getHotelAdminProfile();
        if (profile != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HotelAdminProfile(profile: profile)),
          );
        }
      } else {
        print('Unknown User Role');
      }
    } catch (error) {
      print('User login Failed');
    }
  }
}