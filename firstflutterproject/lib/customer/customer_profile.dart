




import 'package:firstflutterproject/page/loginpage.dart';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:flutter/material.dart';


class CustomerProfile extends StatelessWidget {

  final Map<String, dynamic> profile;
  final AuthService _authService = AuthService();




   CustomerProfile({Key? key, required this.profile}): super(key: key);


  @override
  Widget build(BuildContext context) {

    final String baseUrl = "http://localhost:8082/images/customer/";

    final String? photoName = profile['image'];


    final String? photoUrl = (photoName != null && photoName.isNotEmpty) ? "$baseUrl$photoName": null;


    return Scaffold(
      body: AppBar(
        title: const Text('Customer Profile',
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.black12,
        centerTitle: true,
        elevation: 4,




      ),

      // Drawer: Side navigation menu

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header with user Info

            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.purple

              ),

              accountName: Text(
                profile['name'] ?? 'Unknown User',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(profile['user']?['email']?? 'N/A'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: (photoUrl != null)?
                NetworkImage(photoUrl): const AssetImage('null') as ImageProvider,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Booking History'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red,) ,
              title: const Text('Logout', style: TextStyle(color: Colors.red),),
              onTap: () async{

                await _authService.logout();

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context)=> Loginpage())
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
