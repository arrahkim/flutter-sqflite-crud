import 'package:flutter/material.dart';
import 'dbHelper.dart';
import 'myNote.dart';

class NotePage extends StatefulWidget {
  final Mynote _mynote;
  final bool _isNew;

  const NotePage(this._mynote, this._isNew);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  String title;
  bool btnSave = false;
  bool btnEdit = true;
  bool btnDelete = true;

  Mynote mynote;
  String createDate;

  final cTitle = TextEditingController();
  final cNote = TextEditingController();

  var now = DateTime.now();

  bool _enabledTextField = true;

  Future addRecord() async {
    var db = DBHelper();
    String dateNow =
        "${now.day}/${now.month}/${now.year}, ${now.hour}:${now.minute}";

    var mynote =
        Mynote(cTitle.text, cNote.text, dateNow, dateNow, now.toString());
    await db.saveNote(mynote);
    print("saved");
  }

  Future updateRecord() async {
    var db = DBHelper();
    String dateNow =
        "${now.day}/${now.month}/${now.year}, ${now.hour}:${now.minute}";

    var mynote =
        Mynote(cTitle.text, cNote.text, createDate, dateNow, now.toString());

    mynote.setNoteId(this.mynote.id);
    await db.updateNote(mynote);
  }

  void _saveData() {
    if (widget._isNew) {
      addRecord();
    } else {
      updateRecord();
    }
    Navigator.pop(context);
  }

  void _editData() {
    setState(() {
      _enabledTextField = true;
      btnEdit = false;
      btnSave = true;
      btnDelete = true;
      title = "Edit Note";
    });
  }

  void delete(Mynote mynote) {
    var db = DBHelper();
    db.deleteNote(mynote);
  }

  void _deleteData() {
    AlertDialog alertDialog = AlertDialog(
      content: Text(
        "Delete this note ?",
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
            delete(mynote);
            Navigator.pop(context);
          },
        ),
        RaisedButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  @override
  void initState() {
    if (widget._mynote != null) {
      mynote = widget._mynote;
      cTitle.text = mynote.title;
      cNote.text = mynote.note;
      title = "My Note";
      _enabledTextField = false;
      createDate = mynote.createDate;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._isNew) {
      title = "New Note";
      btnSave = true;
      btnEdit = false;
      btnDelete = false;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
              size: 30.0,
            ),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CreateButton(
                    icon: Icons.delete,
                    enable: btnDelete,
                    onpress: _deleteData,
                  ),
                  CreateButton(
                    icon: Icons.edit,
                    enable: btnEdit,
                    onpress: _editData,
                  ),
                  CreateButton(
                    icon: Icons.save,
                    enable: btnSave,
                    onpress: _saveData,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextFormField(
                  enabled: _enabledTextField,
                  controller: cTitle,
                  decoration: InputDecoration(hintText: "Title"),
                  style: TextStyle(fontSize: 24.0, color: Colors.black),
                  maxLines: null,
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextFormField(
                  enabled: _enabledTextField,
                  controller: cNote,
                  decoration: InputDecoration(hintText: "Write note"),
                  style: TextStyle(fontSize: 24.0, color: Colors.black),
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.newline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CreateButton extends StatelessWidget {
  final IconData icon;
  final bool enable;
  final onpress;

  const CreateButton({this.icon, this.enable, this.onpress});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: enable ? Colors.teal : Colors.grey),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        iconSize: 18.0,
        onPressed: () {
          if (enable) {
            onpress();
          }
        },
      ),
    );
  }
}
