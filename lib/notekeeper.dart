import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notebook/statemngmnt.dart';
import 'package:provider/provider.dart';

import 'database.dart';

class Notekeeper extends StatefulWidget {
  Notekeeper({this.appbartitle});
  final String appbartitle;

  @override
  _NotekeeperState createState() => _NotekeeperState();
}

class _NotekeeperState extends State<Notekeeper> {
  void queryall() async {
    final db = DatabaseHelper.instance;
    var res = await db.queryall();
    res.forEach((element) {
      print(element);
    });
  }

  final db = DatabaseHelper.instance;
  String title, description;
  //String date = DateFormat.yMEd().add_jms().format(DateTime.now());
  String date = DateFormat.yMMMd().format(DateTime.now());
  final dbb = DatabaseHelper.instance;

  Future<int> insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.coloumntitle: title,
      DatabaseHelper.coloumndate: date,
      DatabaseHelper.coloumndescription: description,
    };
    final id = await db.insert(row);
    print(id);
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<Changes>(context).mode ? Colors.grey[800] : Colors.white,
      appBar: AppBar(
        brightness: Provider.of<Changes>(context).mode ? Brightness.dark : Brightness.light,
        backgroundColor: Provider.of<Changes>(context, listen: false).mode ? Colors.grey[800] : Colors.amber,
        title: Text(widget.appbartitle),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  title = value;
                },
                decoration: InputDecoration(fillColor: Colors.amber, hoverColor: Colors.amber, hintText: "Title", border: OutlineInputBorder(borderRadius: BorderRadius.horizontal())),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                child: TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  expands: true,
                  onChanged: (value) {
                    description = value;
                  },
                  decoration: InputDecoration(
                      labelText: "Description",
                      contentPadding: EdgeInsets.fromLTRB(80, 80, 80, 80),
                      //hintText: "Description",
                      border: OutlineInputBorder(borderRadius: BorderRadius.horizontal())),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 45,
                    width: 110,
                    child: Builder(
                      builder: (context) => RaisedButton(
                          colorBrightness: Provider.of<Changes>(context, listen: false).mode ? Brightness.dark : Brightness.light,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: Provider.of<Changes>(context, listen: false).mode ? Colors.grey[800] : Colors.amber,
                          child: Text("Add"),
                          onPressed: () {
                            insert();
                            Scaffold.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 2), content: Text("Note Added Sucessfully")));
                            Navigator.of(context).pop(true);
                          }),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  /*SizedBox(
                    height: 45,
                    width: 90,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.amber,
                        child: Text("Delete"),
                        onPressed: () async {
                          queryall();
                          // db.insertdata(note);
                          Navigator.pop(context);
                        }),
                  )*/
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
