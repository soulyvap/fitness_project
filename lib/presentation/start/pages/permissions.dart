import 'package:fitness_project/core/classes/notification_service.dart';
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
        title: const Text('Permissions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.orangeAccent,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(32),
                        child: Icon(Icons.fitness_center,
                            size: 128, color: Colors.white),
                      )),
                  const SizedBox(height: 16),
                  const Text(
                    "For you to experience the app fully, please enable the following permissions.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ]),
              ),
            ),
            Card(
              child: ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.amber),
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
                        .then((value) async {
                      setState(() {
                        hasNotificationPermission = value;
                      });
                      if (value) {
                        await NotificationService.initNotifications();
                      }
                    });
                  }),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
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
