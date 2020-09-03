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
    if (newindex > oldindex) {
      newindex = newindex - 1;
    }
    setState(() {
      final item = notelist.removeAt(oldindex);
      notelist.insert(newindex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Provider.of<Changes>(context).mode
            ? Colors.grey[800]
            : Colors.white,
        appBar: AppBar(
          actions: [
            Tooltip(
              message: "Switch to dark mode",
              child: Icon(
                Icons.settings,
                color: Provider.of<Changes>(context, listen: false).mode
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            CupertinoSwitch(
              //trackColor: Colors.grey
              activeColor: Provider.of<Changes>(context, listen: false).mode
                  ? Colors.grey
                  : Colors.lightBlue,
              value: Provider.of<Changes>(context).mode,
              onChanged: (value) {
                Provider.of<Changes>(context, listen: false).darkmode(value);
              },
            )
          ],
          brightness: Provider.of<Changes>(context, listen: false).mode
              ? Brightness.dark
              : Brightness.light,
          backgroundColor: Provider.of<Changes>(context, listen: false).mode
              ? Colors.grey[800]
              : Colors.amber,
          title: Text(
            "Notes",
            style: TextStyle(
              color: Provider.of<Changes>(context, listen: false).mode
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: queryall(),
          builder: (context, snapshot) => ReorderableListView(
              onReorder: (int oldIndex, int newIndex) {
                onreorder(oldIndex, newIndex);
              },
              children: List.generate(
                  notelist.length,
                  (index) => Dismissible(
                      key: UniqueKey(),
                      background: Container(
                        color: Colors.red,
                      ),
                      confirmDismiss: (DismissDirection direction) {
                        String action;
                        if (direction == DismissDirection.endToStart) {
                          // This is a delete action
                          action = "delete";
                          return showCupertinoDialog<bool>(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              content:
                                  Text("Are you sure you want to $action?"),
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
                        color: Provider.of<Changes>(context, listen: false).mode
                            ? Colors.grey[800]
                            : Colors.white,
                        key: ValueKey(index),
                        child: ListTile(
                          // key: ObjectKey(index),
                          title: Text(
                            "${notelist[index].title}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color:
                                  Provider.of<Changes>(context, listen: false)
                                          .mode
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            "${notelist[index].desc}",
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  Provider.of<Changes>(context, listen: false)
                                          .mode
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                          trailing: Text(
                            "${notelist[index].date}",
                            style: TextStyle(
                                color:
                                    Provider.of<Changes>(context, listen: false)
                                            .mode
                                        ? Colors.white
                                        : Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          leading: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: "${index + 1} ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Provider.of<Changes>(context,
                                              listen: false)
                                          .mode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ]),
                            //  " ${index + 1} ${notelist[index].title}",
                          ),
                        ),
                      )))),
        ),
        floatingActionButton: FloatingActionButton(
            tooltip: "Add Note",
            backgroundColor: Provider.of<Changes>(context).mode
                ? Colors.grey[800]
                : Colors.amber,
            child: Icon(
              Icons.add,
              color: Provider.of<Changes>(context, listen: false).mode
                  ? Colors.white
                  : Colors.black,
            ),
            onPressed: () {
              navigatetodetail('Add Note');
            }));

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
                      ),
 
                    ),
                  )),
          onReorder: (int oldindex, int newindex) {
            onreorder(oldindex, newindex);
          }),
 
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
              //  ),
            //  ),
//),
         // ),
        //)

        */
    // ),
  }

  List<Note> notelist = List();
  Future<List<Note>> queryall() async {
    notelist = List<
        Note>(); //clear the list before adding, else replicates will be there
    final db = DatabaseHelper.instance;
    final List<Map<String, dynamic>> allqueries = await db.queryall();
    int count = allqueries.length;
    for (int i = 0; i < count; i++) {
      notelist.add(Note.extractfrommap(allqueries[i]));
    }
  }
}
