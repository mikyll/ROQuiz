class License {
  String title = "";
  String text = "";

  License(this.title, this.text);

  License.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    text = json['text'];
  }
}
