class Article {
  String? name;
  String? department;
  String? count;
  String? sem;

  Article({this.name, this.department, this.count, this.sem});

  factory Article.fromJson(Map json) {
    return Article(
      name: json["Name"],
      department: json["Department"],
      count: json['Count'].toString(),
      sem: json['Semester'].toString()
    );
  }

}
