import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Common/Textstyle.dart';
import '../admin/Addeventscreen.dart';
import '../common_appbar.dart';

class Usereventscreen extends StatefulWidget {
  const Usereventscreen({super.key});

  @override
  State<Usereventscreen> createState() => _UsereventscreenState();
}

class _UsereventscreenState extends State<Usereventscreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: common_appbar("College Events"),
      body: FutureBuilder<List<CollegeEvent>>(
        future: EventDatabase.getEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final event = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.grey.shade50,
                    child: ListTile(
                      title: Text(event.eventName,style: commonstylepoppins(size: 15,weight: FontWeight.w800),),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(DateFormat('yyyy-MM-dd HH:mm').format(event.eventDateTime),style: commonstylepoppins(),),
                          Text(event.eventVenue,style: commonstylepoppins(size: 15,weight: FontWeight.w800),),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(event.eventAbout,style: commonstylepoppins(size: 15,weight: FontWeight.w500),),
                          ),

                        ],
                      ),
                      // trailing: IconButton(
                      //   icon: Icon(Icons.delete),
                      //   onPressed: () async {
                      //     await EventDatabase.deleteEvent(event.id!);
                      //     setState(() {});
                      //   },
                      // ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
