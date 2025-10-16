import 'package:firstflutterproject/entity/customer_model.dart';
import 'package:firstflutterproject/hotel_admin/hotel_admin_profile.dart';
import 'package:firstflutterproject/hotel_admin/hotel_admin_registration.dart';
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

class _LoginpageState extends State<Loginpage> {

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final storage = new FlutterSecureStorage();

  AuthService authService = AuthService();
  CustomerService customerService = CustomerService();
  AdminService adminService = AdminService();
  HotelAdminService hotelAdminService = HotelAdminService();

  var _isVisible = false;


  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff540dda), Color(0xff8e44ad)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: deviceHeight * 0.05),

                  // Logo with animation
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: deviceHeight * 0.25,
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/hotellogo.jpg'),
                      radius: 90,
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(
                    'Welcome Back!',
                    style: GoogleFonts.poppins(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Login to continue',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),

                  SizedBox(height: 40),

                  // Email Field
                  _buildTextField(
                    controller: email,
                    icon: Icons.email,
                    hintText: 'Email',
                    isPassword: false,
                  ),
                  SizedBox(height: 20),

                  // Password Field
                  _buildTextField(
                    controller: password,
                    icon: Icons.lock,
                    hintText: 'Password',
                    isPassword: true,
                    toggleVisibility: () {
                      setState(() {
                        _isVisible = !_isVisible;
                      });
                    },
                    isVisible: _isVisible,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Login Button
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        loginUser(context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 6,
                        shadowColor: Colors.black45,
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xff540dda),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  // Registration as Customer
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Don't have an account?\n",
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: 'Create a Customer Account',
                          style: GoogleFonts.poppins(
                            color: Colors.amberAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
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

                  SizedBox(height: 20),

                  // Registration as Hotel Admin
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HotelAdminRegistration()),
                      );
                    },
                    icon: Icon(Icons.business),
                    label: Text(
                      'Register as Hotel Admin',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


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
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isVisible,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.white),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white70),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white70,
            ),
            onPressed: toggleVisibility,
          )
              : null,
          contentPadding: EdgeInsets.symmetric(vertical: 20),
        ),
      ),
    );
  }



  // Existing login function
  Future<void> loginUser(BuildContext context) async{
    try{
      final response = await authService.login(email.text, password.text);

      final role = await authService.getUserRole();

      if(role == 'ADMIN'){
        final profile = await adminService.getAdminProfile();
        if(profile != null){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminProfilePage(profile: profile)),
          );
        }
      }
      else if(role == 'CUSTOMER'){
        final profileJson = await customerService.getCustomerProfile();
        final profile = CustomerModel.fromJson(profileJson!); // <-- fix here

        final customers = AuthService().saveCustomerId();
        final customersId = AuthService().saveCustomerId();


        if(profile != null){
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
          if(widget.redirectAfterLogin != null){
            widget.redirectAfterLogin!(); // Navigate to Booking Page
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CustomerProfile(profile: profile)),
            );
          }
        }
      }



      else if(role == 'HOTEL_ADMIN'){
        final profile = await hotelAdminService.getHotelAdminProfile();
        if(profile != null){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HotelAdminProfile(profile: profile)),
          );
        }
      }
      else{
        print('Unknown User Role');
      }
    }
    catch(error){
      print('User login Failed');
    }
  }
}
