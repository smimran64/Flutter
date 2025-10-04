
import 'package:firstflutterproject/admin/adminpage.dart';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


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

            )
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

      else{

        print('Unknown User login');
      }

    }
    catch(error){
      print('User login Failed');
    }

  }
}
