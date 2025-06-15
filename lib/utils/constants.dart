import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class AppConstants {
  static const String appName = 'Flutter Ecommerce';
  
  // Colors
  static const primaryColor = Color(0xFF2196F3);
  static const secondaryColor = Color(0xFF03DAC6);
  static const errorColor = Color(0xFFB00020);
  
  // Spacing
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  // Border Radius
  static const double defaultBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;
}

extension ContextExtension on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppConstants.errorColor : null,
      ),
    );
  }
}