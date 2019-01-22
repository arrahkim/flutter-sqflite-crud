import 'package:flutter/material.dart';
import 'package:simple_note_sqflite/dbHelper.dart';
import 'package:simple_note_sqflite/listNote.dart';
import 'package:simple_note_sqflite/notePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Note',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var db = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => NotePage(
                  null,
                  true,
                ),
          ));
        },
      ),
      appBar: AppBar(
        leading: Container(
          padding: const EdgeInsets.only(top: 8.0, left: 14.0),
          child: Image.asset("img/upin.png"),
        ),
        title: Text(
          "Simple Note",
          style: TextStyle(
            fontSize: 25.0,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder(
        future: db.getNote(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          var data = snapshot.data;
          return snapshot.hasData
              ? NoteList(data)
              : Center(
                  child: Text("No Data"),
                );
        },
      ),
    );
  }
}
