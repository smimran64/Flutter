
import 'package:firstflutterproject/admin/admin_registration_page.dart';
import 'package:firstflutterproject/admin/adminpage.dart';
import 'package:firstflutterproject/customer/customer_profile.dart';
import 'package:firstflutterproject/page/registration.dart';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:firstflutterproject/service/customer_service.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(16.00),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            TextField(

              controller: email,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email)
              ),
            ),

            SizedBox(
              height: 20.0,
            ),
            TextField(

              controller: password,
              decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.password),
              ),
              obscureText: true,
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                onPressed: (){
                  loginUser(context);
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.black

                  ),

                ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,

                foregroundColor: Colors.white
              )

            ),

            SizedBox(
              height: 20.0 ,

            ),
            ElevatedButton(
                onPressed: (){
                 Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context)=> Registration()),
                 );
                },
                child: Text(
                    'Registration as a Customer',
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
            SizedBox(
              height: 20.0 ,

            ),
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

        ),
      ),
    );
  }


  Future<void> loginUser(BuildContext context) async{

    try{

      final response = await authService.login(email.text, password.text);

      // Successful login , role based navigation

      final role = await authService.getUserRole();

      if(role == 'ADMIN'){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminPage()),
           );
      }

      else if(role == 'CUSTOMER'){
        final profile = await customerService.getCustomerProfile();

        if(profile !=null){
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CustomerProfile(profile: profile))
          );
        }

      }

      else{

        print('Unknown User login');
      }

    }
    catch(error){
      print('User login Failed');
    }

  }
}
