import 'package:flutter/material.dart';

class ThemeManager {
  // Dark Mode Colors
  static const Color primaryDark = Color(0xFF1A1A1A);
  static const Color secondaryDark = Color(0xFF2D2D2D);
  static const Color buttonDark = Color(0xFF3A3A3A);
  static const Color buttonDarkSecondary = Color(0xFF2A2A2A);
  static const Color operatorOrange = Color(0xFFF39C12);
  static const Color functionGray = Color(0xFF4A4A4A);
  static const Color clearRed = Color(0xFFE74C3C);
  static const Color equalsGreen = Color(0xFF27AE60);
  static const Color accentBlue = Color(0xFF3498DB);

  // Light Mode Colors
  static const Color primaryLight = Color(0xFFF5F5F5);
  static const Color secondaryLight = Color(0xFFE0E0E0);
  static const Color buttonLight = Color(0xFFFAFAFA);
  static const Color buttonLightSecondary = Color(0xFFF0F0F0);
  static const Color operatorOrangeLight = Color(0xFFFF9800);
  static const Color functionGrayLight = Color(0xFFE8E8E8);
  static const Color clearRedLight = Color(0xFFF44336);
  static const Color equalsGreenLight = Color(0xFF4CAF50);
  static const Color accentBlueLight = Color(0xFF2196F3);
  static const Color lightAccentBlue = Color(0xFF2196F3);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: primaryDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: secondaryDark,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          elevation: 8,
          shadowColor: Colors.black26,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.white70,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: accentBlue,
        secondary: operatorOrange,
        surface: secondaryDark,
        error: clearRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: primaryLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: secondaryLight,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonLight,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          elevation: 4,
          shadowColor: Colors.black12,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w300,
          color: Colors.black87,
        ),
        headlineMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w300,
          color: Colors.black87,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.black54,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: accentBlueLight,
        secondary: operatorOrangeLight,
        surface: secondaryLight,
        error: clearRedLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black87,
        onError: Colors.white,
      ),
    );
  }

  // Dark Mode Decorations
  static BoxDecoration get buttonDecoration {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [buttonDark, buttonDarkSecondary],
      ),
      borderRadius: BorderRadius.circular(35),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration get operatorButtonDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [operatorOrange, operatorOrange.withValues(alpha: 0.8)],
      ),
      borderRadius: BorderRadius.circular(35),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration get functionButtonDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [functionGray, functionGray.withValues(alpha: 0.8)],
      ),
      borderRadius: BorderRadius.circular(35),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration get clearButtonDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [clearRed, clearRed.withValues(alpha: 0.8)],
      ),
      borderRadius: BorderRadius.circular(35),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration get equalsButtonDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [equalsGreen, equalsGreen.withValues(alpha: 0.8)],
      ),
      borderRadius: BorderRadius.circular(35),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration get backgroundDecoration {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [primaryDark, secondaryDark],
      ),
    );
  }

  static BoxDecoration get historyPanelDecoration {
    return BoxDecoration(
      color: Colors.black26,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white24),
    );
  }

  // Light Mode Decorations
  static BoxDecoration get lightButtonDecoration {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [buttonLight, buttonLightSecondary],
      ),
      borderRadius: BorderRadius.circular(35),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration get lightOperatorButtonDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [operatorOrangeLight, operatorOrangeLight.withValues(alpha: 0.8)],
      ),
      borderRadius: BorderRadius.circular(35),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration get lightFunctionButtonDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [functionGrayLight, functionGrayLight.withValues(alpha: 0.8)],
      ),
      borderRadius: BorderRadius.circular(35),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration get lightClearButtonDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [clearRedLight, clearRedLight.withValues(alpha: 0.8)],
      ),
      borderRadius: BorderRadius.circular(35),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration get lightEqualsButtonDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [equalsGreenLight, equalsGreenLight.withValues(alpha: 0.8)],
      ),
      borderRadius: BorderRadius.circular(35),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration get lightBackgroundDecoration {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [primaryLight, secondaryLight],
      ),
    );
  }

  static BoxDecoration get lightHistoryPanelDecoration {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Dark Mode Text Styles
  static TextStyle get displayTextStyle {
    return const TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w300,
      color: Colors.white,
    );
  }

  static TextStyle get historyTextStyle {
    return const TextStyle(
      fontSize: 16,
      color: Colors.white70,
    );
  }

  static TextStyle get buttonTextStyle {
    return const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }

  static TextStyle get functionButtonTextStyle {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }

  // Light Mode Text Styles
  static TextStyle get lightDisplayTextStyle {
    return const TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w300,
      color: Colors.black87,
    );
  }

  static TextStyle get lightHistoryTextStyle {
    return const TextStyle(
      fontSize: 16,
      color: Colors.black54,
    );
  }

  static TextStyle get lightButtonTextStyle {
    return const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );
  }

  static TextStyle get lightFunctionButtonTextStyle {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );
  }
} 