import 'package:flutter/material.dart';

String formatDouble(dynamic input) {
  if (input == null) {
    return null;
  }
  if (input is String) {
    return input;
  }
  if (input is double) {
    return input.toStringAsFixed(2);
  }
  return input.toString();
}

bool isMinus(String value) {
  if (value == null) {
    return false;
  }
  return value.substring(0, 1) == '-';
}

Color riskColor(String risk) {
  switch (risk.toLowerCase()) {
    case 'low':
      return Colors.green;
    case 'medium':
      return Colors.orange;
    case 'high':
      return Colors.red;
    default:
      return Colors.green;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
