import 'package:flutter/material.dart';

class CustomNavigator {
  static void pushWithSlideTransition(
    BuildContext context,
    Widget page, {
    Offset begin = const Offset(1.0, 0.0),
    Offset end = Offset.zero,
    Curve curve = Curves.easeInOut,
    Duration duration = const Duration(milliseconds: 300),
    RouteSettings? settings,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, secondaryAnimation) => page,
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: duration,
        settings: settings,
      ),
    );
  }
}
