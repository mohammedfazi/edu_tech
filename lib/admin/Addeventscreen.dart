import 'package:edu_tech/Common/Textstyle.dart';
import 'package:edu_tech/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class CollegeEvent {
  final int? id;
  final String eventName;
  final String eventAbout;
  final DateTime eventDateTime;
  final String eventVenue;

  CollegeEvent({
    this.id,
    required this.eventName,
    required this.eventAbout,
    required this.eventDateTime,
    required this.eventVenue,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventName': eventName,
      'eventAbout': eventAbout,
      'eventDateTime': eventDateTime.toIso8601String(),
      'eventVenue': eventVenue,
    };
  }

  factory CollegeEvent.fromMap(Map<String, dynamic> map) {
    return CollegeEvent(
      id: map['id'],
      eventName: map['eventName'],
      eventAbout: map['eventAbout'],
      eventDateTime: DateTime.parse(map['eventDateTime']),
      eventVenue: map['eventVenue'],
    );
  }
}

class EventDatabase {
  static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'college_events.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE events(id INTEGER PRIMARY KEY AUTOINCREMENT, eventName TEXT, eventAbout TEXT, eventDateTime TEXT, eventVenue TEXT)',
        );
      },
    );
  }

  static Future<void> insertEvent(CollegeEvent event) async {
    final db = await _openDatabase();
    await db.insert('events', event.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<CollegeEvent>> getEvents() async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> maps = await db.query('events');
    return List.generate(maps.length, (i) {
      return CollegeEvent.fromMap(maps[i]);
    });
  }

  static Future<void> deleteEvent(int id) async {
    final db = await _openDatabase();
    await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _eventNameController = TextEditingController();
  final _eventAboutController = TextEditingController();
  DateTime _eventDateTime = DateTime.now();
  final _eventVenueController = TextEditingController();

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _eventDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_eventDateTime),
      );
      if (time != null) {
        setState(() {
          _eventDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:common_appbar("Add Events"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _eventNameController, decoration: InputDecoration(labelText: 'Event Name')),
            TextField(controller: _eventAboutController, decoration: InputDecoration(labelText: 'About Event')),
            ListTile(
              title: Text('Date and Time: ${DateFormat('yyyy-MM-dd HH:mm').format(_eventDateTime)}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDateTime(context),
            ),
            TextField(controller: _eventVenueController, decoration: InputDecoration(labelText: 'Venue')),
            ElevatedButton(
              onPressed: () async {
                final event = CollegeEvent(
                  eventName: _eventNameController.text,
                  eventAbout: _eventAboutController.text,
                  eventDateTime: _eventDateTime,
                  eventVenue: _eventVenueController.text,
                );
                await EventDatabase.insertEvent(event);
                Navigator.pop(context); // Go back to the events list screen
              },
              child: Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }
}

class GetEventScreen extends StatefulWidget {
  @override
  _GetEventScreenState createState() => _GetEventScreenState();
}

class _GetEventScreenState extends State<GetEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddEventScreen())).then((value) => setState(() {}));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}