/// Extracts the first Dart file path, line, and column from a stack trace string.
/// Returns a string like "client_test/error_test_screen.dart:38:34", or null if not found.
String? extractErrorLocation(String? stackTraceString) {
  if (stackTraceString == null) return null;
  final match = RegExp(r'([\/\w\-_]+\.dart):(\d+):(\d+)').firstMatch(stackTraceString);
  if (match != null && match.groupCount >= 3) {
    return '${match.group(1)}:${match.group(2)}:${match.group(3)}';
  }
  return null;
}

// Utility to get the first N lines of a stack trace
String getShortStackTrace(StackTrace trace, {int maxLines = 8}) {
  final lines = trace.toString().split('\n');
  if (lines.length <= maxLines) return trace.toString();
  return '${lines.take(maxLines).join('\n')}\n...';
}
