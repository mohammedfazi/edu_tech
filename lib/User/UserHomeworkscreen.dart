import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Common/Textstyle.dart';
import '../admin/AddHomeworkscreen.dart';
import '../common_appbar.dart';

class Userhomeworkscreen extends StatefulWidget {
  const Userhomeworkscreen({super.key});

  @override
  State<Userhomeworkscreen> createState() => _UserhomeworkscreenState();
}

class _UserhomeworkscreenState extends State<Userhomeworkscreen> {

  final _dbHelper = DatabaseHelper();
  late Future<List<Homework>> _homeworks;

  @override
  void initState() {
    super.initState();
    _homeworks = _dbHelper.getAllHomeworks();
  }

  Future<void> _refreshHomeworks() async {
    setState(() {
      _homeworks = _dbHelper.getAllHomeworks();
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: common_appbar("Homework"),
      body: FutureBuilder<List<Homework>>(
        future: _homeworks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final homework = snapshot.data![index];
                return Dismissible(
                  key: Key(homework.id.toString()),
                  onDismissed: (direction) async{
                    await _dbHelper.deleteHomework(homework.id!);
                    _refreshHomeworks();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Homework deleted')));
                  },
                  background: Container(color: Colors.red),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(homework.subject,style: commonstylepoppins(size: 18,weight: FontWeight.w800),),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(homework.description,style: commonstylepoppins(),),
                        ),
                        trailing: Text(DateFormat('yyyy-MM-dd').format(homework.dueDate),style: commonstylepoppins(weight: FontWeight.w800,size: 10),),
                      ),
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
