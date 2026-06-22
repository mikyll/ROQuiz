String getTimeString(int counter) {
  String hours = "${counter ~/ 3600}".padLeft(2, '0');
  String minutes = "${(counter % 3600) ~/ 60}".padLeft(2, '0');
  String seconds = "${counter % 60}".padLeft(2, '0');
  return "$hours:$minutes:$seconds";
}

const List<String> _monthsAbbr = [
  "gen",
  "feb",
  "mar",
  "apr",
  "mag",
  "giu",
  "lug",
  "ago",
  "set",
  "ott",
  "nov",
  "dic",
];

/// Human-readable date for the history, e.g. `23 giu 2026, 14:32`.
String getDateString(DateTime date) {
  final String day = date.day.toString();
  final String month = _monthsAbbr[date.month - 1];
  final String hour = date.hour.toString().padLeft(2, '0');
  final String minute = date.minute.toString().padLeft(2, '0');
  return "$day $month ${date.year}, $hour:$minute";
}
