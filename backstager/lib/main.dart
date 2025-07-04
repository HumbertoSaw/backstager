import 'package:backstager/l10n/app_localizations.dart';
import 'package:backstager/views/permission_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color primaryPurple = Color(0xFF6A0DAD);
  static const Color accentGold = Color(0xFFFFD700);
  static const Color errorRed = Color(0xFFD32F2F);

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: const Color(0xFFF2F2F2),
    primaryColor: primaryPurple,
    colorScheme: const ColorScheme.light().copyWith(
      primary: primaryPurple,
      secondary: accentGold,
      surface: Color(0xFFE0E0E0),
      error: errorRed,
      onPrimary: Colors.white,
      onSecondary: Color(0xFF4D4D4D),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryPurple,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color.fromARGB(255, 67, 67, 67)),
      bodyMedium: TextStyle(color: Color.fromARGB(255, 95, 95, 95)),
      titleLarge: TextStyle(color: primaryPurple, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentGold,
      foregroundColor: Colors.white,
    ),
    cardColor: const Color(0xFFE0E0E0),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xFF3C3C3C),
    primaryColor: primaryPurple,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: primaryPurple,
      secondary: accentGold,
      surface: Color(0xFF4A4A4A),
      error: errorRed,
      onPrimary: Colors.white,
      onSecondary: Color(0xFFE0E0E0),
      onSurface: Color(0xFFE0E0E0),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryPurple,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
      bodyMedium: TextStyle(color: Color(0xFFE0E0E0)),
      titleLarge: TextStyle(color: accentGold, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentGold,
      foregroundColor: Color(0xFF3C3C3C),
    ),
    cardColor: const Color(0xFF4A4A4A),
    dividerColor: const Color(0xFF666666),
    dialogTheme: DialogThemeData(
      backgroundColor: const Color.fromARGB(255, 99, 99, 99),
    ),
  );

  Future<bool> _checkPermissions() async {
    final audioStatus = await Permission.audio.status;
    final photosStatus = await Permission.photos.status;
    return audioStatus.isGranted && photosStatus.isGranted;
  }

  Future<Widget> _getInitialScreen() async {
    final hasPermissions = await _checkPermissions();
    return hasPermissions ? const HomeView() : const PermissionsScreen();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialScreen(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return MaterialApp(
          title: 'Backstage',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.light,
          home: snapshot.data!,
          routes: {
            '/home': (context) => const HomeView(),
            '/permissions': (context) => const PermissionsScreen(),
          },
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
        );
      },
    );
  }
}
