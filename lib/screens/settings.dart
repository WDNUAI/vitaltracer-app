import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'bluetooth-connections-screen.dart';

//documentation on settings widgets here: https://pub.dev/documentation/settings_ui/latest/
class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //give title to list of below apps
        title: const Text('Settings'),
      ),
      //Settings List can contain several Sections ( General , Support etc.)
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('General'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                // Handle navigation to send data page
                leading: const Icon(Icons.send),
                title: const Text('Send Data To Professional'),
                onPressed: (BuildContext context) {
                  //show pop up when pressed - place holder for now as more logic needs to added  ( where do we send data ? input email)
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      //define popup with alert dialog
                      return AlertDialog(
                        title: const Text('Data Sent'),
                        content: const Text('Data from last session sent!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              //when ok is pressed remove context
                              Navigator.of(context).pop();
                            },
                            //display text to remove dialog box
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.watch),
                title: const Text('Connections'),
                onPressed: (BuildContext context) {
                  //pass context and the screen to goto - replace with connections page once made
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const BluetoothConnectionsScreen()),
                  );
                },
              ),
              SettingsTile.navigation(
                //Can Modify icons for btn below
                leading: const Icon(Icons.people),
                title: const Text('Input Personal Data'),
                onPressed: (BuildContext context) {
                  // Handle navigation to Input Data Page
                },
              ),
              //Dark Mode Toggle
              SettingsTile.switchTile(
                onToggle: (bool value) {},
                initialValue:
                    false, //dark mode is initially off when booting app
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
