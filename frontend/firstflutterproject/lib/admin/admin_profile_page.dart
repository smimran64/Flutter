


import 'package:firstflutterproject/hotel/view_all_hotel.dart';
import 'package:firstflutterproject/hotel_amenities/view_all_amenities.dart';
import 'package:firstflutterproject/hotel_information/view_hotel_information.dart';
import 'package:firstflutterproject/hotel_photo_gallery/view_photo_by_id.dart';
import 'package:firstflutterproject/location/view_location_page.dart';
import 'package:firstflutterproject/page/loginpage.dart';
import 'package:firstflutterproject/service/authservice.dart';
import 'package:firstflutterproject/service/hotel_aminities_service.dart';
import 'package:firstflutterproject/service/hotel_information_service.dart';
import 'package:firstflutterproject/service/hotel_photo_service.dart';
import 'package:firstflutterproject/service/hotel_service.dart';
import 'package:firstflutterproject/service/location_service.dart';
import 'package:flutter/material.dart';


class AdminProfilePage extends StatelessWidget {

  final Map<String, dynamic> profile;

  final AuthService _authService = AuthService();
  final HotelService _hotelService = HotelService();

  AdminProfilePage({Key? key, required this.profile}): super(key: key);



  @override
  Widget build(BuildContext context) {





    LocationService locationService = LocationService();

    HotelService hotelService = HotelService();

    HotelAminitiesService hotelAminitiesService = HotelAminitiesService();

    HotelInformationService hotelInformationService = HotelInformationService();

    HotelPhotoService hotelPhotoService = HotelPhotoService();


    final String baseUrl = "http://localhost:8082/images/Admins";

    final String? photoName = profile['image'];

    final String? photoUrl = (photoName != null && photoName.isNotEmpty) ? "$baseUrl/$photoName": null;


    //Scaffold main Screen+++++++++++


    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Profile',

          style: TextStyle(
              color: Colors.white
          ),

        ),
        backgroundColor: Colors.cyan,
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
              accountEmail: Text(profile['email']?? 'N/A'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: (photoUrl != null)?
                NetworkImage(photoUrl): const AssetImage('assets/default_user.png') as ImageProvider,
              ),
            ),

            // menu item++++++++++++++

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              onTap: () => Navigator.pop(context),

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
              title: const Text('Location History'),
              onTap: () async {
                // TODO: Add navigation to Edit Profile Page
                final location = await locationService.getAllLocations();

                if (location != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocationPage(),
                    ),
                  );
                }
              },
            ),

            ListTile(
              leading: const Icon(Icons.hotel),
              title: const Text('All Hotels'),
              onTap: () async {
                // TODO: Add navigation to Edit Profile Page
                final hotel = await hotelService.getAllHotels();

                if (hotel != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewAllHotel(),
                    ),
                  );
                }
              },
            ),

            ListTile(
              leading: const Icon(Icons.hotel),
              title: const Text('All Hotels Amenities'),
              onTap: () async {
                // TODO: Add navigation to Edit Profile Page
                final amenities = await hotelAminitiesService.getAllAmenities();

                if (amenities != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewAllAmenities(),
                    ),
                  );
                }
              },
            ),

            ListTile(
              leading: const Icon(Icons.hotel_class_sharp),
              title: const Text('All Hotels Information'),
              onTap: () async {
                // TODO: Add navigation to Edit Profile Page
                final information = await hotelInformationService.getAllHotelInformation();

                if (information != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewAllHotelInfoPage()
                    ),
                  );
                }
              },
            ),

            ListTile(
              leading: const Icon(Icons.hotel_class_sharp),
              title: const Text('Photo Gallery'),
              onTap: () async {
                // TODO: Add navigation to Edit Profile Page

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HotelPhotoGalleryPage()
                    ),
                  );

              },
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
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

      // Body: main content area


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
                    )
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: (photoUrl != null)
                      ?NetworkImage(photoUrl)// from backend
                      :const AssetImage("assets/default_user.png") as ImageProvider,
                ),
              ),
              const SizedBox(height: 20,),

              // Display Customer Name

              Center(
                child: Text(
                  profile['name']?? 'Unknown',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

              ),


              const SizedBox(height: 10),

              // Display user email (nested under user object)

              Text(
                "Email : ${profile['email']?? 'N/A'}",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),

              ),

              const SizedBox(height: 10),

              Text(
                "Address: ${profile['address']?? 'N/A'}",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),

              const SizedBox(height: 10),

              Text(
                "Gender: ${profile['gender']?? 'N/A'}" ,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 10),

              Text(
                "Date Of Birth: ${profile['dateOfBirth']?? 'N/A'}",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),





              // Button for editing profile

              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Add edit functionality or navigation
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit Profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
              ),

            ],
          ),
        )

    );
  }
}
