import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool _generalNotifications = true;
  bool _soundEnabled = false;
  bool _vibrationEnabled = true;
  bool _appUpdates = true;
  bool _newServiceAvailable = false;
  bool _newTipsAvailable = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notification',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'General Notifications',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _generalNotifications,
                  onChanged: (value) {
                    setState(() {
                      _generalNotifications = value;
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: Color(0xFF0A3D62),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sound',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _soundEnabled,
                  onChanged: (value) {
                    setState(() {
                      _soundEnabled = value;
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: Color(0xFF0A3D62),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vibrate',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _vibrationEnabled,
                  onChanged: (value) {
                    setState(() {
                      _vibrationEnabled = value;
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: Color(0xFF0A3D62),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'App Update',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _appUpdates,
                  onChanged: (value) {
                    setState(() {
                      _appUpdates = value;
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: Color(0xFF0A3D62),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Service Available',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _newServiceAvailable,
                  onChanged: (value) {
                    setState(() {
                      _newServiceAvailable = value;
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: Color(0xFF0A3D62),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Tips Available',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _newTipsAvailable,
                  onChanged: (value) {
                    setState(() {
                      _newTipsAvailable = value;
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: Color(0xFF0A3D62),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
