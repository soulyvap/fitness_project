import 'package:fitness_project/core/classes/permission_request_service.dart';
import 'package:fitness_project/presentation/navigation/pages/navigation.dart';
import 'package:flutter/material.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  bool? hasNotificationPermission;
  bool? hasCameraPermission;

  @override
  void initState() {
    PermissionRequestService().hasNotificationPermission().then((value) {
      setState(() {
        hasNotificationPermission = value;
      });
    });
    PermissionRequestService().hasCameraPermission().then((value) {
      setState(() {
        hasCameraPermission = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Before we get started'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Expanded(
              child: Center(
                child: Text(
                  "For you to experience the full functionality of the app, we need to ask for some permissions.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Card(
              child: ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notification permission'),
                  subtitle: const Text(
                      'This will allow other users to tell you when a new challenge has started.'),
                  trailing: hasNotificationPermission == null
                      ? const CircularProgressIndicator()
                      : hasNotificationPermission!
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    if (hasNotificationPermission == true) {
                      return;
                    }
                    PermissionRequestService()
                        .requestNotificationPermission()
                        .then((value) {
                      setState(() {
                        hasNotificationPermission = value;
                      });
                    });
                  }),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera permission'),
                subtitle: const Text(
                    'This will allow you to record videos and show you have completed a challenge.'),
                trailing: hasCameraPermission == null
                    ? const CircularProgressIndicator()
                    : hasCameraPermission!
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  if (hasCameraPermission == true) {
                    return;
                  }
                  PermissionRequestService()
                      .requestCameraPermission()
                      .then((value) {
                    setState(() {
                      hasCameraPermission = value;
                    });
                  });
                },
              ),
            ),
            if (hasCameraPermission == true &&
                hasNotificationPermission == true)
              const SizedBox(height: 16),
            if (hasCameraPermission == true &&
                hasNotificationPermission == true)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const Navigation(),
                    ));
                  },
                  child: const Text('Continue'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
