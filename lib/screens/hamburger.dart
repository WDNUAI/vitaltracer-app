import 'package:flutter/material.dart';
import 'settings.dart';
import 'home_screen.dart';
import 'bluetooth-connections-screen.dart';
import 'ble-connections-screen.dart';
import 'view_detailed_datatype.dart';
import 'test_view_graph.dart';
import 'auth_service.dart';
import 'sign_in_screen.dart';
import 'recorded_data_screen.dart';
import 'ecg_test_graph.dart';

class HamburgerMenu extends StatelessWidget {
  final VoidCallback onPressed;
  final AuthService _auth;

//Forced me to use a value that is not null not sure consequences of VoidCallback are - was added using quick fix btn

//Below Code creates clickable icon, position of icon is determined in the class where it is called
  HamburgerMenu({super.key, required this.onPressed}) : _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: onPressed,
    );
  }

//Every time the hamburger is opened we build its view. Below code creates the List view and defines what happens to context after press
  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            //Set Title of Button
            title: const Text('Home'),
            onTap: () {
              // Home Tap
              Navigator.pop(
                  context); // Close the drawer and open the new context
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          //Set Title
          ListTile(
            title: const Text('Settings'),
            //Define what happens on press
            onTap: () {
              // Settings Tap
              Navigator.pop(
                  context); // Close the drawer and open the new context
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings()),
              );
              // to change where the button brings context change above line to desired screen. Import above
            },
          ),
          //Set Title of Button
          ListTile(
            title: const Text('Bluetooth classic Connections'),
            onTap: () {
              // Connections Tap
              Navigator.pop(
                  context); // Close the drawer and open the new context
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ClassicConnectionsScreen()),
              );
            },
          ),
          //Set Title of Button
          ListTile(
            title: const Text('Ble Connections'),
            onTap: () {
              // Connections Tap
              Navigator.pop(
                  context); // Close the drawer and open the new context
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BluetoothConnectionsScreen()),
              );
            },
          ),
          ListTile(
              title: const Text('Previous Sessions'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RecordedDataScreen()),
                );
              }),
          ListTile(
              title: const Text('Record with Vital Tracer'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TestViewGraph()),
                );
              }),
          ListTile(
              title: const Text('Record with ESP32'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewGraph()),
                );
              }),
          ListTile(
            title: const Text('Sign Out'),
            onTap: () async {
              await _auth.signOut();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignScreen()),
              );
            },
          ),
          // add more buttons at a later point here
        ],
      ),
    );
  }
}
