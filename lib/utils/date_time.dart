import 'package:intl/intl.dart';

String formatRelativeTime(String datetimeStr) {
  DateTime dateTime = DateTime.parse(datetimeStr);
  DateTime now = DateTime.now();
  Duration diff = now.difference(dateTime);

  if (diff.inHours < 24) {
    return DateFormat('h:mm a').format(dateTime); // e.g., "3 PM"
  } else if (diff.inDays < 30) {
    return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
  } else if (diff.inDays < 365) {
    int monthsAgo = (diff.inDays / 30).floor();
    return '$monthsAgo month${monthsAgo == 1 ? '' : 's'} ago';
  } else {
    int yearsAgo = (diff.inDays / 365).floor();
    return '$yearsAgo year${yearsAgo == 1 ? '' : 's'} ago';
  }
}
