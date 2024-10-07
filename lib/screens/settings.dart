import 'dart:io';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:provider/provider.dart';
import 'package:vitaltracer_app/models/theme_notifier.dart';
import 'package:vitaltracer_app/screens/ble-connections-screen.dart';
import 'package:vitaltracer_app/screens/configure_patch.dart';
import 'package:vitaltracer_app/services/rolling_file_system.dart';
import 'file_selection_dialog.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

   Future<void> _shareData(BuildContext context) async {
    try {
      RollingFileSystem fileSystem = RollingFileSystem();
      await fileSystem.initialize();

      List<File> availableFiles = await fileSystem.getRecentFiles(days: 3650);
      
      if (availableFiles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No data available to share.')),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FileSelectionDialog(availableFiles: availableFiles),
        ),
      );
    } catch (e) {
      print('Error accessing files: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accessing files: $e')),
      );
    }
  }

  

  @override
  Widget build(BuildContext context) {

     SettingsThemeData settingsTheme = SettingsThemeData(
        settingsListBackground : const Color(0xFFFFFF),
        dividerColor: const Color(0x000E5B),

    );
     // Get the themeNotifier from Provider
    final themeNotifier = Provider.of<ThemeNotifier>(context);

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
                  _shareData(context);
                },
              ),

              SettingsTile.navigation(
                leading: const Icon(Icons.watch),
                title: const Text('Connections'),
                onPressed: (BuildContext context) {
                  //go to connections page once made
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BluetoothConnectionsScreen(),
                    ),
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
              SettingsTile.navigation(
                 //Can Modify icons for btn below
                leading: const Icon(Icons.watch_sharp),
                title: const Text('Manage your patch'),
                onPressed: (BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConfigurePatch(),
                    ),
                  );
                },
              ),
                //Dark Mode Toggle
              SettingsTile.switchTile(
                onToggle: (bool value) {
                  themeNotifier.toggleTheme(value);
                },
                initialValue: themeNotifier.isDarkMode,
                leading: const Icon(Icons.dark_mode),  // Get initial value from themeNotifier
                title: const Text('Dark Mode'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}