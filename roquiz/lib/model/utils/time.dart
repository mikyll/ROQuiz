String getTimeString(int counter) {
  String hours = "${counter ~/ 3600}".padLeft(2, '0');
  String minutes = "${counter ~/ 60}".padLeft(2, '0');
  String seconds = "${counter % 60}".padLeft(2, '0');
  return "$hours:$minutes:$seconds";
}
