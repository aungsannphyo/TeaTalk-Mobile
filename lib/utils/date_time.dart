import 'package:intl/intl.dart';

String formatRelativeTime(String datetimeStr) {
  final dateTime = DateTime.parse(datetimeStr).toLocal();
  final now = DateTime.now();
  final diff = now.difference(dateTime);

  if (diff.inSeconds < 60) {
    return 'last seen recently';
  } else if (diff.inMinutes < 60) {
    return 'last seen ${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
  } else if (diff.inHours < 24 && now.day == dateTime.day) {
    // Same calendar day
    return 'last seen ${DateFormat('h:mm a').format(dateTime)}'; // "8:05 PM"
  } else if (diff.inHours < 48 && now.day != dateTime.day) {
    // Yesterday, not same calendar day
    return 'yesterday at ${DateFormat('h:mm a').format(dateTime)}';
  } else if (diff.inDays < 30) {
    return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
  } else if (diff.inDays < 365) {
    final monthsAgo = (diff.inDays / 30).floor();
    return '$monthsAgo month${monthsAgo == 1 ? '' : 's'} ago';
  } else {
    final yearsAgo = (diff.inDays / 365).floor();
    return '$yearsAgo year${yearsAgo == 1 ? '' : 's'} ago';
  }
}
