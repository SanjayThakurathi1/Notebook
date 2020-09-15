import 'package:flutter/cupertino.dart';
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

  final _descfocusnode = FocusNode();
  @override
  void dispose() {
    _descfocusnode.dispose();
    super.dispose();
  }

  final db = DatabaseHelper.instance;
  String title, description, date;
  // String date = DateFormat.yMEd().add_jms().format(DateTime.now());

  final dbb = DatabaseHelper.instance;

  Future<int> insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.coloumntitle: title,
      DatabaseHelper.coloumndate:
          date == null ? DateFormat.yMEd().format(DateTime.now()) : date,
      DatabaseHelper.coloumndescription: description,
    };
    final id = await db.insert(row);
    print(id);
    return id;
  }

  Future<DateFormat> _datepicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2021))
        .then((pickeddate) {
      if (pickeddate == null) {
        date = DateFormat.yMEd().format(DateTime.now());
      } else
        date = DateFormat.yMEd().format(pickeddate);
    });
  }

  /*Future<DateFormat> datepicker() {
    Container(
      child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          //backgroundColor: Colors,
          minimumDate: DateTime(2020),
          maximumDate: DateTime(2021),
          initialDateTime: DateTime.now(),
          onDateTimeChanged: (DateTime value) {
            print(value);
            if (value == null) {
              date = DateFormat.yMEd().format(DateTime.now());
            } else {
              date = DateFormat.yMEd().format(value);
              print(date);
            }
          }),
    );
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<Changes>(context).mode ? Colors.grey[800] : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
          color: Provider.of<Changes>(context, listen: false).mode
              ? Colors.white
              : Colors.black,
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        brightness: Provider.of<Changes>(context).mode
            ? Brightness.dark
            : Brightness.light,
        backgroundColor: Provider.of<Changes>(context, listen: false).mode
            ? Colors.grey[800]
            : Colors.amber,
        title: Text(
          widget.appbartitle,
          style: TextStyle(
            color: Provider.of<Changes>(context, listen: false).mode
                ? Colors.white
                : Colors.black,
          ),
        ),
        actions: [
          Tooltip(
            textStyle: TextStyle(
              color: Provider.of<Changes>(context, listen: false).mode
                  ? Colors.black
                  : Colors.lightBlue,
            ),
            message: "Pick the date",
            child: IconButton(
                onPressed: () =>
                    //Provider.of<Changes>(context, listen: false).mode
                    //  ? _datepicker():
                    _datepicker(),
                icon: Icon(
                  Icons.date_range,
                  color: Provider.of<Changes>(context, listen: false).mode
                      ? Colors.white
                      : Colors.black,
                  size: 40,
                )),
          ),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: Form(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(
                    _descfocusnode,
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    title = value;
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.amber,
                      hoverColor: Colors.amber,
                      hintText: "Title",
                      hintStyle: TextStyle(
                          color:
                              Provider.of<Changes>(context, listen: false).mode
                                  ? Colors.white
                                  : Colors.black,
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.horizontal())),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    focusNode: _descfocusnode,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    // expands: true,
                    onChanged: (value) {
                      description = value;
                    },
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: Provider.of<Changes>(context, listen: false)
                                    .mode
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold),
                        labelText: "Description",
                        contentPadding: EdgeInsets.fromLTRB(80, 80, 80, 80),
                        //hintText: "Description",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal())),
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
                            colorBrightness:
                                Provider.of<Changes>(context, listen: false)
                                        .mode
                                    ? Brightness.dark
                                    : Brightness.light,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Provider.of<Changes>(context, listen: false)
                                    .mode
                                ? Colors.grey[800]
                                : Colors.amber,
                            child: Text("Add"),
                            onPressed: () {
                              insert();
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  duration: Duration(seconds: 2),
                                  content: Text("Note Added Sucessfully")));
                              Navigator.pop(context, true);

                              setState(() {});
                            }),
                      ),
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
                    )
                    */
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
