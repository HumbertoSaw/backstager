import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  PermissionStatus _audioStatus = PermissionStatus.denied;
  PermissionStatus _photosStatus = PermissionStatus.denied;
  PermissionStatus _microphoneStatus = PermissionStatus.denied;
  bool _isCheckingPermissions = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    setState(() => _isCheckingPermissions = true);

    final audioStatus = await Permission.audio.status;
    final photosStatus = await Permission.photos.status;
    final microphoneStatus = await Permission.microphone.status;

    setState(() {
      _audioStatus = audioStatus;
      _photosStatus = photosStatus;
      _microphoneStatus = microphoneStatus;
      _isCheckingPermissions = false;
    });

    if (audioStatus.isGranted &&
        photosStatus.isGranted &&
        microphoneStatus.isGranted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/home');
      });
    }
  }

  Future<void> _requestPermissions() async {
    setState(() => _isCheckingPermissions = true);

    final statuses = await [
      Permission.audio,
      Permission.photos,
      Permission.microphone,
    ].request();

    setState(() {
      _audioStatus = statuses[Permission.audio] ?? PermissionStatus.denied;
      _photosStatus = statuses[Permission.photos] ?? PermissionStatus.denied;
      _microphoneStatus =
          statuses[Permission.microphone] ?? PermissionStatus.denied;
      _isCheckingPermissions = false;
    });

    if (_audioStatus.isPermanentlyDenied ||
        _photosStatus.isPermanentlyDenied ||
        _microphoneStatus.isPermanentlyDenied) {
      await openAppSettings();
    }

    await _checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.perm_media,
                size: 64,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                textAlign: TextAlign.center,
                'Audio, Microphone & Image Access Required',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Backstager needs permission to access audio files, the microphone and images on your device. '
                'This is required to load, create audio files and save clips.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              if (_isCheckingPermissions)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  onPressed: _requestPermissions,
                  child: const Text('Allow Access'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
