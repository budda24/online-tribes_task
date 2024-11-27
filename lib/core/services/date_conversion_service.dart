import 'package:intl/intl.dart';

class DateConversionService {
  /// Formats a [DateTime] object into a string according to the provided [format].
  ///
  /// The [format] parameter should be a pattern recognized by [DateFormat].
  /// If no format is provided, defaults to `'yyyy-MM-dd HH:mm:ss'`.
  String formatDate(DateTime date, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    final formatter = DateFormat(format);
    return formatter.format(date);
  }

  /// Parses a date string into a [DateTime] object according to the provided [format].
  ///
  /// Returns `null` if parsing fails.
  DateTime? parseDate(
    String dateString, {
    String format = 'yyyy-MM-dd HH:mm:ss',
  }) {
    try {
      final formatter = DateFormat(format);
      return formatter.parse(dateString);
    } catch (e) {
      // Handle parsing error
      return null;
    }
  }

  /// Converts a [DateTime] object to another time zone.
  ///
  /// Requires the 'timezone' package and proper initialization.
  DateTime convertToTimeZone(DateTime date, String timeZone) {
    // Implementation depends on your requirements
    // See section on Time Zone handling below
    throw UnimplementedError('Time zone conversion not implemented yet.');
  }

  /// Returns a string representing how long ago the [lastActive] time was.
  ///
  /// - If less than an hour ago, returns minutes (e.g., "45m ago").
  /// - If less than a day ago, returns hours (e.g., "5h ago").
  /// - If less than a week ago, returns days (e.g., "3d ago").
  /// - If less than a month ago, returns weeks (e.g., "2w ago").
  /// - If more than a month ago, returns "not active".
  String getLastActiveString(DateTime lastActive) {
    final now = DateTime.now();
    final difference = now.difference(lastActive);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else {
      return 'not active';
    }
  }
}
