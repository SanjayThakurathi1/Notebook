/*class Note {
  int _id;
  String _title;
  String _description;
  String _date;

  Note(this._title, this._date, this._id, [this._description]);
  Note.named(this._title, this._date, this._id,
      [this._description]); //named Constructor

  //named Constructur
  String get title => _title;
  int get id => _id;
  String get description => _description;
  String get date => _date;

  set title(String newtitle) {
    if (newtitle.length <= 200) {
      this._title = newtitle;
    }
  }

  set description(String newdes) {
    if (newdes.length <= 300) {
      this._description = newdes;
    }
  }

  set date(String newdate) {
    this._date = newdate;
  }
  //SQFLITE plugin saves map objects to your sqldatabase ->
  //before saving data to database we have to convert data into map

  //SQFlite plugin retrieves map object from your sqllitedatabase <-
  //In Short when you retrieve data from database you get a map object.you need to convert it to simple object before using it

  //Function to convert Notekeeper object to map object
  Map<String, dynamic> tomapnoteobject() {
    var map =
        Map<String, dynamic>(); //String for['id','title'..]and dynamic for _id

    //first initialize a empty map object
    if (_id != null) {
      map['id'] = _id;
    }

    map['title'] = _title;
    map['description'] = _description;

    map['date'] = _date;
    return map;

    /* Map<String, dynamic> row = {
        db.colid: this._id,
        db.coltitle:this.title,
        db.coldescription:this.description,
        db.date:this.date,
        db.priority:this.priority
    };
    return row;
    
  }
  */
  }

  //Function to extract a note object from a Map Object
  Note.extractfrommap(Map<String, dynamic> toMap) //return type of map i
  {
    this._id = toMap['id'];
    this.title = toMap['name'];
    this.date = toMap['date'];
    this.description = toMap['desc'];
  }
}


*/
