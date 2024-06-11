import 'package:flutter/material.dart';
import 'detailed_view_screen.dart';
import 'components/health_data_tile.dart';
import 'hamburger.dart';
import 'bluetooth-connections-screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vital Tracer Home'),
        //Create Hamburger Menu
        leading: Builder(
          builder: (context) => HamburgerMenu(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: HamburgerMenu(
        onPressed: () {},
        //When Icon is pressed, call Builddrawer() within hamburger class
      ).buildDrawer(context),
      body: const HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Image.asset(
              'lib/images/vt1.png',
              height: 200,
              width: 250,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                    context); // Close the drawer and open the new context
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BlueoothConnectionsScreen()),
                );
                // Connect to device
              },
              child: const Text('Connect'),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  HealthDataTile(
                    label: 'Heart Rate',
                    value: '72 BPM',
                    imagePath: 'lib/images/heart.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DetailedViewScreen()),
                      );
                    },
                  ),
                  HealthDataTile(
                    label: 'Temperature',
                    value: '36.5 °C',
                    imagePath: 'lib/images/temp.jpg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DetailedViewScreen()),
                      );
                    },
                  ),
                  HealthDataTile(
                    label: 'ECG',
                    value: 'Normal',
                    imagePath: 'lib/images/ecg.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DetailedViewScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
