import 'package:flutter/material.dart';

class ClipProgressBar extends StatelessWidget {
  final double startAt;
  final double endAt;
  final Duration totalDuration;
  final Color color;
  final Color backgroundColor;

  const ClipProgressBar({
    super.key,
    required this.startAt,
    required this.endAt,
    required this.totalDuration,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalMs = totalDuration.inMilliseconds;
        final startPx =
            (startAt * 1000 / totalMs).clamp(0.0, 1.0) * constraints.maxWidth;
        final endPx =
            (endAt * 1000 / totalMs).clamp(0.0, 1.0) * constraints.maxWidth;
        final width = (endPx - startPx).clamp(0.0, constraints.maxWidth);

        return Container(
          height: 6,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Stack(
            children: [
              Positioned(
                left: startPx,
                width: width,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
