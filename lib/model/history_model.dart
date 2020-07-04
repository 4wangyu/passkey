class History {
  String path;
  int date;

  History(this.path, this.date);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["path"] = this.path;
    map["date"] = this.date;
    return map;
  }

  History.fromMap(Map<String, dynamic> map) {
    this.path = map["path"];
    this.date = map["date"];
  }
}
