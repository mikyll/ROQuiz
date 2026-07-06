class Contribution {
  String author = "";
  String task = "";
  String url = "";

  Contribution(this.author, this.task, this.url);

  Contribution.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    task = json['task'];
    url = json['url'];
  }
}
