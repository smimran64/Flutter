import 'package:firstflutterproject/entity/customer_model.dart';
import 'package:firstflutterproject/page/loginpage.dart';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:flutter/material.dart';


class CustomerProfile extends StatelessWidget {
  final CustomerModel profile;
  final AuthService _authService = AuthService();

  CustomerProfile({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String baseUrl = "http://localhost:8082/images/customer";
    final String? photoName = profile.image;
    final String? photoUrl =
    (photoName != null && photoName.isNotEmpty) ? "$baseUrl/$photoName" : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customer Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.cyan,
        centerTitle: true,
        elevation: 4,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.purple),
              accountName: Text(
                profile.name ?? 'Unknown User',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(profile.email ?? 'N/A'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: (photoUrl != null)
                    ? NetworkImage(photoUrl)
                    : const AssetImage('assets/default_user.png') as ImageProvider,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Booking History'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await _authService.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Loginpage()),
                );
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  )
                ],
                border: Border.all(
                  color: Colors.purple,
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                backgroundImage: (photoUrl != null)
                    ? NetworkImage(photoUrl)
                    : const AssetImage("assets/default_user.png") as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                profile.name ?? 'Unknown',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Email: ${profile.email ?? 'N/A'}",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            Text(
              "Phone: ${profile.phone ?? 'N/A'}",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            Text(
              "Address: ${profile.address ?? 'N/A'}",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            Text(
              "Gender: ${profile.gender ?? 'N/A'}",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            Text(
              "Date Of Birth: ${profile.dateOfBirth != null ? profile.dateOfBirth!.toIso8601String().split('T')[0] : 'N/A'}",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Add edit functionality or navigation
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
