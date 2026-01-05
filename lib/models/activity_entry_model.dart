import 'package:intl/intl.dart';

// Models
class ActivityEntry {
  final String title;
  final String author;
  final String date;
  final String status;

  ActivityEntry({
    required this.title,
    required this.author,
    required this.date,
    required this.status,
  });

  factory ActivityEntry.fromMap(Map<String, dynamic> map) {
    // 1. Parse Date from T (millis)
    String formattedDate = '';
    if (map['T'] != null) {
      try {
        DateTime dt = DateTime.fromMillisecondsSinceEpoch(map['T']);
        formattedDate = DateFormat('dd MMM yyyy').format(dt);
      } catch (e) {
        formattedDate = 'N/A';
      }
    }

    // 2. Parse Title & Status
    String type = map['type']?.toString() ?? '';
    String subtype = map['subtype']?.toString() ?? '';
    String toStatus = map['to']?.toString() ?? '';

    String title = '';
    String status = '';

    if (type == 'sts_change') {
      // Example: subtype = 'booked' -> Title: Booked
      title = _capitalize(subtype.replaceAll('_', ' '));
      // Status usually comes from 'to' field for state changes
      status = toStatus.isNotEmpty ? toStatus : 'CONFIRMED';
    } else if (type == 'accounts') {
      title = 'Payment';
      if (subtype == 'pay_capture') title = 'Payment Received';
      // For payments, status could be 'CONFIRMED' if it exists in logs
      status = 'CONFIRMED';
    } else {
      title = _capitalize(type.replaceAll('_', ' '));
      status = 'UPDATED';
    }

    // Normalize status for UI color mapping (CONFIRMED, IN PROGRESS, REJECTED)
    status = _normalizeStatus(status);

    return ActivityEntry(
      title: title,
      author: map['by']?.toString() ?? 'SYSTEM',
      date: formattedDate,
      status: status,
    );
  }

  static String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  static String _normalizeStatus(String raw) {
    String lower = raw.toLowerCase();
    if (lower.contains('confirm') ||
        lower.contains('booked') ||
        lower == 'active') {
      return 'CONFIRMED';
    } else if (lower.contains('review') || lower.contains('progress')) {
      return 'IN PROGRESS';
    } else if (lower.contains('reject') || lower.contains('allocat')) {
      // allocation might be confirmed, but let's stick to simple mapping for now
      // purely based on provided examples, 'review' is yellow, 'confirmed' is green.
      return 'REJECTED';
    }
    // Default fallback
    if (lower == 'allotted') return 'CONFIRMED';

    return raw.toUpperCase();
  }
}
