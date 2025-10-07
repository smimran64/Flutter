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

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

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

  var _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // Logo Image
              Container(
                height: deviceHeight * 0.30,
                margin: EdgeInsets.only(top: 20),
                child: FittedBox(
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/hotellogo.jpg'),
                    radius: 120,
                  ),
                ),
              ),

              // Login Form Container
              Container(
                height: deviceHeight * 0.65,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: LayoutBuilder(
                  builder: (ctx, constraints) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          'Login Now',
                          style: TextStyle(
                              fontSize:36,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffc10ff4)
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight *0.01),
                        Text('Please enter the details below to continue'),
                        SizedBox(height: constraints.maxHeight *0.08),

                        // Email TextField
                        Container(
                          height: constraints.maxHeight *0.12,
                          decoration: BoxDecoration(
                            color: Color(0xffB4B4B4).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Center(
                              child: TextField(
                                controller: email,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: constraints.maxHeight *0.02),

                        // Password TextField
                        Container(
                          height: constraints.maxHeight *0.12,
                          decoration: BoxDecoration(
                            color: Color(0xffB4B4B4).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Center(
                              child: TextField(
                                controller: password,
                                obscureText: !_isVisible,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed:() {
                                      setState(() {
                                        _isVisible = !_isVisible;
                                      });
                                    },
                                    icon: Icon(
                                      _isVisible ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  hintText: 'Password',
                                  prefixIcon: Icon(Icons.password),
                                ),
                              ),
                            ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Color(0xffF80849),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Login Button
                        Container(
                          width: double.infinity,
                          height: constraints.maxHeight *0.12,
                          margin: EdgeInsets.only(top: constraints.maxHeight *0.05),
                          child: ElevatedButton(
                            onPressed: () {
                              loginUser(context);
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Color(0xfffbf5f7),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff540dda),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28)
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: constraints.maxHeight *0.02),

                        // Registration Links
                        RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            children: [
                              TextSpan(
                                text: 'Create a New Account As A Customer',
                                style: TextStyle(
                                  color: Color(0xffF80849),
                                  fontSize: 18,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => Registration()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: constraints.maxHeight *0.02),

                        ElevatedButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)=> AdminRegistrationPage()),
                            );
                          },
                          child: Text(
                            'Registration as an Admin',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: GoogleFonts.lato().fontFamily
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white
                          ),
                        ),

                      ],
                    );
                  },
                ),
              ),

            ],
          ),
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminProfilePage(profile: profile)),
          );
        }
      }
      else if(role == 'CUSTOMER'){
        final profile = await customerService.getCustomerProfile();
        if(profile != null){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CustomerProfile(profile: profile)),
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
