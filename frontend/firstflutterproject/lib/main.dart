import 'package:firstflutterproject/admin/admin_registration_page.dart';
import 'package:firstflutterproject/home/home_page.dart';
import 'package:firstflutterproject/page/loginpage.dart';
import 'package:firstflutterproject/page/registration.dart';
import 'package:firstflutterproject/password/reset_password.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    final Uri uri = Uri.base;
    final String? token = uri.queryParameters['token'];

    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: token != null
          ? ResetPasswordScreen(token: token)
          : HomePage(),
    );
  }
}



