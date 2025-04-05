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
      "bus_number": "101",
      "route": [
        "Gandhipuram",
        "Ukkadam",
        "Town Hall",
        "RS Puram",
        "Peelamedu"
      ],
      "number_plate": "TN 01 AB 1234",
      "google_map_link": "https://www.google.com/maps/dir/Gandhipuram,+Coimbatore,+Tamil+Nadu/Peelamedu,+Coimbatore,+Tamil+Nadu/",
      "view_route_text": "View Route",
      "image_logo": "Assets/logo.png"
    },
    {
      "bus_number": "102",
      "route": [
        "Singanallur",
        "Ramanathapuram",
        "Sundarapuram",
        "Podanur",
        "Kuniyamuthur"
      ],
      "number_plate": "TN 02 CD 5678",
      "google_map_link": "https://www.google.com/maps/dir/Singanallur,+Coimbatore,+Tamil+Nadu/Kuniyamuthur,+Coimbatore,+Tamil+Nadu/",
      "view_route_text": "View Route",
      "image_logo": "Assets/logo.png"
    },
    {
      "bus_number": "103",
      "route": [
        "Vadavalli",
        "Thondamuthur",
        "Perur",
        "Thennampalayam",
        "Malumichampatti"
      ],
      "number_plate": "TN 03 EF 9101",
      "google_map_link": "https://www.google.com/maps/dir/Vadavalli,+Coimbatore,+Tamil+Nadu/Malumichampatti,+Coimbatore,+Tamil+Nadu/",
      "view_route_text": "View Route",
      "image_logo": "Assets/logo.png"
    },
    {
      "bus_number": "104",
      "route": [
        "Saravanampatti",
        "Vilankurichi",
        "Kalapatti",
        "Keeranatham",
        "Idigarai"
      ],
      "number_plate": "TN 04 GH 1122",
      "google_map_link": "https://www.google.com/maps/dir/Saravanampatti,+Coimbatore,+Tamil+Nadu/Idigarai,+Coimbatore,+Tamil+Nadu/",
      "view_route_text": "View Route",
      "image_logo": "Assets/logo.png"
    },
    {
      "bus_number": "105",
      "route": [
        "Pollachi",
        "Kinathukadavu",
        "Sulur",
        "Irugur",
        "Avinashi Road"
      ],
      "number_plate": "TN 05 IJ 3344",
      "google_map_link": "https://www.google.com/maps/dir/Pollachi,+Coimbatore,+Tamil+Nadu/Avinashi+Road,+Coimbatore,+Tamil+Nadu/",
      "view_route_text": "View Route",
      "image_logo": "Assets/logo.png"
    }
  ];

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: common_appbar("Bus Tracking"),
      body: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: busdata.length,
        itemBuilder: (context, index) {
          final busRoute = busdata[index];
          return Card(
            elevation: 5,
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Bus Number : "+busRoute['bus_number'],
                          style: commonstylepoppins(size: 20,weight: FontWeight.w800)
                      ),
                      SizedBox(height: 5),
                      Text(
                          busRoute['number_plate'],
                          style: commonstylepoppins(color: Colors.grey,size: 15,weight: FontWeight.w700)
                      ),
                      SizedBox(height: 10),
                      Text(
                          'Bus Route Via:',
                          style: commonstylepoppins(size: 15,weight: FontWeight.w700)
                      ),
                      for (var stop in busRoute['route'])
                        Text(
                            stop,
                            style: commonstylepoppins(color: Colors.grey,weight: FontWeight.w500)
                        ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => _launchURL(busRoute['google_map_link']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellowAccent.shade700,
                        ),
                        child: Text('View Bus Route',style: commonstylepoppins(color: Colors.black,weight: FontWeight.w800),),
                      ),
                    ],
                  ),
                  // Right part with bus logo
                  SizedBox(width: 10),
                  Image.asset(
                    busRoute['image_logo'],
                    width: displaywidth(context)*0.35,
                    // height: 50,
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
