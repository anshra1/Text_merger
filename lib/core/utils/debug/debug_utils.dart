import 'package:flutter/material.dart';

class DebugUtils {
  static void printJsonStructure(Map<String, dynamic> json, [int depth = 0]) {
    json.forEach((key, value) {
      final indent = '  ' * depth;
      if (value is Map<String, dynamic>) {
        debugPrint('$indent$key: {');
        printJsonStructure(value, depth + 1);
        debugPrint('$indent}');
      } else if (value is List) {
        debugPrint('$indent$key: [${value.length} items]');
      } else {
        debugPrint('$indent$key: ${value.runtimeType} = $value');
      }
    });
  }
}