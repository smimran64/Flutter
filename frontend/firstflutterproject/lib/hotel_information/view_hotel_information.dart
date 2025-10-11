

import 'package:firstflutterproject/entity/hotel_information_model.dart';
import 'package:firstflutterproject/service/hotel_information_service.dart';
import 'package:flutter/material.dart';


class ViewAllHotelInfoPage extends StatefulWidget {
  const ViewAllHotelInfoPage({super.key});

  @override
  State<ViewAllHotelInfoPage> createState() => _ViewAllHotelInfoPageState();
}

class _ViewAllHotelInfoPageState extends State<ViewAllHotelInfoPage> {


  late Future<List<HotelInformation>> _hotelInfoList;


  @override
  void initState() {

    super.initState();
    _hotelInfoList = HotelInformationService().getAllHotelInformation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // ✅ Back to AdminProfilePage
            },
          ),
          title: const Text("Hotel Details")
      ),
      body: FutureBuilder<List<HotelInformation>>(
        future: _hotelInfoList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hotel info found"));
          }

          final infoList = snapshot.data!;

          return ListView.builder(
            itemCount: infoList.length,
            itemBuilder: (context, index) {
              final info = infoList[index];
              return Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.hotelName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "🧑‍💼 Owner's Speech:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(info.ownerSpeach),
                      const SizedBox(height: 10),
                      Text(
                        "📝 Description:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(info.description),
                      const SizedBox(height: 10),
                      Text(
                        "📋 Hotel Policy:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(info.hotelPolicy),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
