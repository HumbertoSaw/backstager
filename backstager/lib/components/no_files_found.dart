import 'package:flutter/material.dart';

class NoFilesFound extends StatelessWidget {
  const NoFilesFound._({
    required this.icon,
    required this.title,
    this.subtitle,
    this.color = Colors.grey,
    this.iconSize = 64,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color color;
  final double iconSize;

  static Widget noFilesFound({
    IconData icon = Icons.folder_off_rounded,
    required String title,
    String? subtitle,
    Color color = Colors.grey,
    double iconSize = 64,
  }) {
    return NoFilesFound._(
      icon: icon,
      title: title,
      subtitle: subtitle,
      color: color,
      iconSize: iconSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: color),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: color),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: color),
            ),
          ],
        ],
      ),
    );
  }
}
