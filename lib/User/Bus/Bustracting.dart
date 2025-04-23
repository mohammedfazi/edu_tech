import 'package:edu_tech/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Common/Commonsize.dart';
import '../../Common/Textstyle.dart';

class Bustractingscreen extends StatefulWidget {
  const Bustractingscreen({super.key});

  @override
  State<Bustractingscreen> createState() => _BustractingscreenState();
}

class _BustractingscreenState extends State<Bustractingscreen> {

  List<dynamic> busdata = [
    {
      "bus_number": "C1",
      "route": [
        "Tambaram",
        "Chromepet",
        "Pallavaram",
        "Kundrathur",
        "Tiruninravur"
      ],
      "number_plate": "TN 22 AA 1111",
      "start_latitude": 12.9218, // Tambaram start latitude
      "start_longitude": 80.1247, // Tambaram start longitude
      "end_latitude": 13.0347, // Tiruninravur end latitude
      "end_longitude": 79.9556, // Tiruninravur end longitude
      "view_route_text": "View Route",
      "image_logo": "Assets/logo.png"
    },
    {
      "bus_number": "C2",
      "route": [
        "Poonamallee",
        "Avadi",
        "Nemilichery",
        "Tiruninravur",
        "Jaya Engineering College"
      ],
      "number_plate": "TN 29 BB 2222",
      "start_latitude": 13.0362, // Poonamallee start latitude
      "start_longitude": 80.1395, // Poonamallee start longitude
      "end_latitude": 13.0347, // Jaya Engineering College latitude
      "end_longitude": 79.9556, // Jaya Engineering College longitude
      "view_route_text": "View Route",
      "image_logo": "Assets/logo.png"
    },
    {
      "bus_number": "C3",
      "route": [
        "Guindy",
        "Kathipara",
        "Ambattur",
        "Pattravakkam",
        "Tiruninravur"
      ],
      "number_plate": "TN 23 CC 3333",
      "start_latitude": 13.0058, // Guindy start latitude
      "start_longitude": 80.2297, // Guindy start longitude
      "end_latitude": 13.0347, // Tiruninravur end latitude
      "end_longitude": 79.9556, // Tiruninravur end longitude
      "view_route_text": "View Route",
      "image_logo": "Assets/logo.png"
    },
    {
      "bus_number": "C4",
      "route": [
        "Broadway",
        "Central Station",
        "Egmore",
        "Kilpauk",
        "Ambattur OT"
      ],
      "number_plate": "TN 21 DD 4444",
      "start_latitude": 13.0827, // Broadway start latitude
      "start_longitude": 80.2831, // Broadway start longitude
      "end_latitude": 13.0757, // Ambattur OT end latitude
      "end_longitude": 80.1574, // Ambattur OT end longitude
      "view_route_text": "View Route",
      "image_logo": "Assets/logo.png"
    },
    {
      "bus_number": "C5",
      "route": [
        "Thiruvanmiyur",
        "Adyar",
        "Saidapet",
        "Ashok Nagar",
        "Vadapalani"
      ],
      "number_plate": "TN 25 EE 5555",
      "start_latitude": 12.9854, // Thiruvanmiyur start latitude
      "start_longitude": 80.2708, // Thiruvanmiyur start longitude
      "end_latitude": 13.0630, // Vadapalani end latitude
      "end_longitude": 80.2093, // Vadapalani end longitude
      "view_route_text": "View Route",
      "image_logo": "Assets/logo.png"
    }
  ];

  Future<void> _launchURL(double startLat, double startLng, double endLat, double endLng) async {
    String googleMapsUrl = "https://www.google.com/maps/dir/?api=1&origin=$startLat,$startLng&destination=$endLat,$endLng";

    final uri = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: common_appbar("Bus Tracking"),
      body: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: busdata.length,
        itemBuilder: (context, index) {
          final busRoute = busdata[index];
          return Card(
            elevation: 5,
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bus Number : " + busRoute['bus_number'],
                        style: commonstylepoppins(
                            size: 20, weight: FontWeight.w800),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        busRoute['number_plate'],
                        style: commonstylepoppins(
                            color: Colors.grey, size: 15, weight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Bus Route Via:',
                        style: commonstylepoppins(
                            size: 15, weight: FontWeight.w700),
                      ),
                      for (var stop in busRoute['route'])
                        Text(
                          stop,
                          style: commonstylepoppins(
                              color: Colors.grey, weight: FontWeight.w500),
                        ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => _launchURL(busRoute['start_latitude'], busRoute['start_longitude'], busRoute['end_latitude'], busRoute['end_longitude']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellowAccent.shade700,
                        ),
                        child: Text(
                          'View Bus Route',
                          style: commonstylepoppins(
                              color: Colors.black, weight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    busRoute['image_logo'],
                    width: displaywidth(context) * 0.35,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}