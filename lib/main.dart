import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notebook/model.dart';
import 'package:notebook/statemngmnt.dart';
import 'package:provider/provider.dart';

import 'database.dart';
import 'notekeeper.dart';

void main() => runApp(ChangeNotifierProvider(
    create: (context) {
      return Changes();
    },
    child: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //bool mode = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      /* darkTheme: Provider.of<Changes>(context, listen: false).mode
          ? ThemeData.dark()
          : ThemeData.light(),
      themeMode: Provider.of<Changes>(context, listen: false).mode
          ? ThemeMode.dark
          : ThemeMode.light,*/
      home: Notebookhome(),
    );
  }
}

class Notebookhome extends StatefulWidget {
  @override
  _NotebookhomeState createState() => _NotebookhomeState();
}

class _NotebookhomeState extends State<Notebookhome> {
  int count = 0;
  bool x = false;
  void navigatetodetail(String title) async {
    bool res = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Notekeeper(
                  appbartitle: title,
                )));

    if (res == true) {
      setState(() {
        this.notelist = notelist;
      });
    }
  }

  void updatedata() {
    setState(() {
      this.notelist = notelist;
    });
  }

  void onreorder(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex = newindex - 1;
      }
      final item = notelist.removeAt(oldindex);
      notelist.insert(newindex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<Changes>(context).mode ? Colors.grey[800] : Colors.white,
      appBar: AppBar(
        actions: [
          CupertinoSwitch(
            activeColor: Provider.of<Changes>(context, listen: false).mode ? Colors.grey : Colors.lightBlue,
            value: Provider.of<Changes>(context).mode,
            onChanged: (value) {
              Provider.of<Changes>(context, listen: false).darkmode(value);
            },
          )
        ],
        brightness: Provider.of<Changes>(context, listen: false).mode ? Brightness.dark : Brightness.light,
        backgroundColor: Provider.of<Changes>(context, listen: false).mode ? Colors.grey[800] : Colors.amber,
        title: Text("Notes"),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: queryall(),
          builder: (context, snapshot) => ReorderableListView(
              children: List.generate(
                  notelist.length,
                  (index) => Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.red,
                        ),
                        confirmDismiss: (DismissDirection direction) async {
                          String action;
                          if (direction == DismissDirection.endToStart) {
                            // This is a delete action
                            action = "delete";
                            return await showCupertinoDialog<bool>(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                content: Text("Are you sure you want to $action?"),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: Text("Ok"),
                                    onPressed: () {
                                      setState(() {
                                        final db = DatabaseHelper.instance;
                                        db.deletedata(notelist[index].id);
                                        notelist.removeAt(index);
                                      });

                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      // Dismiss the dialog but don't
                                      // dismiss the swiped item
                                      return Navigator.of(context).pop(false);
                                    },
                                  )
                                ],
                              ),
                            );
                          } else {
                            // This is an archive action
                            action = "archive";
                            return false;
                          }
                          // In case the user dismisses
                        },
                        onDismissed: (direction) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              content: Text(
                                "Note Deleted Sucessfully",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              )));
                        },
                        child: Card(
                          color: Provider.of<Changes>(context, listen: false).mode ? Colors.grey[800] : Colors.white,
                          key: ValueKey(index),
                          child: ListTile(
                            // key: ObjectKey(index),
                            title: Text("${notelist[index].title}"),
                            trailing: Text(
                              notelist[index].date,
                              style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Container(
                              child: Text("${notelist[index].desc}"),
                            ),
                          ),
                        ),
                      )),
              onReorder: (int oldindex, int newindex) {
                {
                  onreorder(oldindex, newindex);
                }
              })
          /*ListView.builder
         (
          itemCount: notelist.length,
          itemBuilder: (context, index) => Card(
            shadowColor: Colors.amber,
            child: Dismissible(

              background: Container(
                color: Colors.red,
              ),
              confirmDismiss: (DismissDirection direction) {
                String action;
                if (direction == DismissDirection.endToStart) {
                  // This is a delete action
                  action = "delete";
                  showCupertinoDialog<bool>(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      content: Text("Are you sure you want to $action?"),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: Text("Ok"),
                          onPressed: () {
                            setState(() {
                              final db = DatabaseHelper.instance;
                              db.deletedata(notelist[index].id);
                              notelist.removeAt(index);
                            });

                            Navigator.of(context).pop(true);
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text('Cancel'),
                          onPressed: () {
                            // Dismiss the dialog but don't
                            // dismiss the swiped item
                            return Navigator.of(context).pop(false);
                          },
                        )
                      ],
                    ),
                  );
                } else {
                  // This is an archive action
                  action = "archive";
                }

                // In case the user dismisses
              },
              onDismissed: (direction) {
                Scaffold.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text(
                      "Note Deleted Sucessfully",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )));
              },
              key: UniqueKey(),
              child: ListTile(
                title: Text("${notelist[index].title}"),
                leading: Text(
                  notelist[index].date,
                  style: TextStyle(
                      color: Colors.lightBlue, fontWeight: FontWeight.bold),
                ),
                /*trailing: GestureDetector(
                  onTap: () {

                    updatedata();
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),*/
                subtitle: Container(
                  child: Text("${notelist[index].desc}"),
                ),
              ),
            ),
          ),
        ),
        */
          ),
      floatingActionButton: FloatingActionButton(
          tooltip: "Add Note",
          backgroundColor: Provider.of<Changes>(context).mode ? Colors.grey[800] : Colors.amber,
          child: Icon(Icons.add),
          onPressed: () {
            navigatetodetail('Add Note');
          }),
      //floatingActionButtonLocation: FloatingActionButtonLocation.,
    );
  }

  List<Note> notelist = List();
  Future<List<Note>> queryall() async {
    notelist = List<Note>(); //clear the list before adding, else replicates will be there
    final db = DatabaseHelper.instance;
    final List<Map<String, dynamic>> allqueries = await db.queryall();

    int count = allqueries.length;

    for (int i = 0; i < count; i++) {
      notelist.add(Note.extractfrommap(allqueries[i]));
      print(notelist[i].title);
    }
  }
}
