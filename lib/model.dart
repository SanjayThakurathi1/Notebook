class Note {
  int id;
  String title;
  String desc;
  String date;
  Note({
    this.id,
    this.title,
    this.desc,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': title,
      'desc': desc,
      'date': date,
    };
  }

  Note.extractfrommap(Map<String, dynamic> toMap) {
    this.id = toMap['id'];
    this.title = toMap['name'];
    this.date = toMap['date'];
    this.desc = toMap['desc'];
  }
}
