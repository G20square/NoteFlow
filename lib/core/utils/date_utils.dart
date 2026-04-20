import 'package:intl/intl.dart';

class NoteDate {
  NoteDate._();

  static String format(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return DateFormat('EEEE').format(date); // Monday, Tuesday...
    } else if (date.year == now.year) {
      return DateFormat('MMM d').format(date); // Apr 5
    } else {
      return DateFormat('MMM d, yyyy').format(date); // Apr 5, 2024
    }
  }

  static String fullFormat(DateTime date) {
    return DateFormat('MMMM d, yyyy • h:mm a').format(date);
  }
}
