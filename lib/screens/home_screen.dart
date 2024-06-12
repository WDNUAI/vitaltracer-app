import 'package:flutter/material.dart';
import 'package:vitaltracer_app/screens/sign_in_screen.dart';
import 'detailed_view_screen.dart';
import 'components/health_data_tile.dart';
import 'hamburger.dart';

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
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to the sign-in screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignScreen()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: HamburgerMenu(
        onPressed: () {},
      ).buildDrawer(context),
      body: const HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  // Connect to device
                },
                child: const Text('Connect'),
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  HealthDataTile(
                    label: 'Heart Rate',
                    value: '72 BPM',
                    imagePath: 'lib/images/heart.webp',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DetailedViewScreen()),
                      );
                    },
                  ),
                  HealthDataTile(
                    label: 'Body Temperature',
                    value: '36.5 °C',
                    imagePath: 'lib/images/temp.webp',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DetailedViewScreen()),
                      );
                    },
                  ),
                  HealthDataTile(
                    label: 'Activity',
                    value: '10,000 steps',
                    imagePath: 'lib/images/activity.webp',
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
                    imagePath: 'lib/images/ecg.webp',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DetailedViewScreen()),
                      );
                    },
                  ),
                  HealthDataTile(
                    label: 'SPO2',
                    value: '92%',
                    imagePath: 'lib/images/O2.webp',
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
            ],
          ),
        ),
      );
    });
  }
}
