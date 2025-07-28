import 'package:flutter/material.dart';

/// A central place to define and manage all colors used in the app.
/// This makes it easier to maintain a consistent color scheme and
/// implement themes or color changes in the future.
class AppColors {
  // Primary brand colors
  static const Color primaryColor = Colors.pink; // Deep Purple
  static Color primaryColorLight = Colors.pink[100]!; // Lighter Purple
  static Color primaryColorDark = Colors.pink[900]!; // Darker Purple

  // Accent colors
  static const Color accentColor = Color(0xFF03A9F4); // Light Blue
  static const Color accentColorLight = Color(0xFF4FC3F7);
  static const Color accentColorDark = Color(0xFF0288D1);

  // Functional colors
  static const Color successColor = Color(0xFF4CAF50); // Green
  static const Color errorColor = Color(0xFFE53935); // Red
  static const Color warningColor = Color(0xFFFFA000); // Amber
  static const Color infoColor = Color(0xFF2196F3); // Blue

  // Text colors
  static const Color textPrimary = Color(0xFF212121); // Very Dark Gray
  static const Color textSecondary = Color(0xFF757575); // Medium Gray
  static const Color textHint = Color(0xFFBDBDBD); // Light Gray

  // Background colors
  static const Color background = Color(0xFFF5F5F5); // Light Gray
  static const Color cardBackground = Color(0xFFFFFFFF); // White
  static const Color dividerColor = Color(0xFFE0E0E0); // Light Gray

  // Dark theme colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCardBackground = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // Career section specific colors
  static const Color prosColor = Color(0xFF4CAF50); // Green for positives
  static const Color consColor = Color(0xFFE53935); // Red for negatives
  static const Color educationColor = Color(0xFF3F51B5); // Indigo for education
  static const Color salaryColor = Color(0xFF00796B); // Teal for money
  static const Color trendColor = Color(0xFF6200EA); // Purple for trends

  // Gradient backgrounds
  static LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColorLight, primaryColor, primaryColorDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient accentGradient = const LinearGradient(
    colors: [accentColorLight, accentColor, accentColorDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Helper method to get color based on theme
  static Color getThemeAwareColor(
      BuildContext context, Color lightColor, Color darkColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkColor : lightColor;
  }

  // Helper method to get a primary color with specific opacity
  static Color getPrimaryWithOpacity(double opacity) {
    return primaryColor.withValues(alpha: opacity);
  }
}
