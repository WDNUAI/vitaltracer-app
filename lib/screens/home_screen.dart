import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vitaltracer_app/services/bluetooth_service.dart';
import 'detailed_view_screen.dart';
import 'components/health_data_tile.dart';
import 'hamburger.dart';
import 'ble-connections-screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ecg_test_graph.dart';
import 'settings.dart';

/// Main HomeScreen widget that sets up the app's structure
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar configuration
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Health Overview'),
            // Display current date
            Text(
              DateTime.now().toString().split(' ')[0],
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        // Hamburger menu in the leading position
        leading: Builder(
          builder: (context) => HamburgerMenu(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        // Bluetooth icon in the actions area
        actions: [
          IconButton(
            icon: Icon(Icons.bluetooth),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BluetoothConnectionsScreen()),
              );
            },
          ),
        ],
      ),
      // Drawer configuration using HamburgerMenu
      drawer: HamburgerMenu(
        onPressed: () {},
      ).buildDrawer(context),
      // Main content of the home screen
      body: const HomeScreenContent(),
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
        ],
        currentIndex: 1, // Home selected by default
        selectedItemColor: Colors.blue,
        onTap: (index) {
          // Navigate to Settings when tapped
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Settings()),
            );
          }
          // Other navigation options can be added here
        },
      ),
    );
  }
}

/// Stateful widget for the main content of the home screen
class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  Timer? _timer;
  double? _currentTemperature = VTBluetoothService.currentTemperature;
  // ScrollController to manage scrolling behavior
  final ScrollController _scrollController = ScrollController();
  bool _showScrollIndicator = false;

  // Define a constant neutral background color for all tiles
  final Color tileBgColor = Colors.white;

  @override
  void initState() {
    super.initState();
    // Add scroll listener to handle scroll indicator visibility
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _timer?.cancel();
    // Clean up the scroll controller when the widget is disposed
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTemperature = VTBluetoothService.currentTemperature;
      });
    });
  }

  // Listener for scroll events to show/hide scroll indicator
  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _showScrollIndicator = false;
      });
    } else {
      setState(() {
        _showScrollIndicator = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main scrollable content
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top tile with device information
                HealthDataTile(
                  label: 'Top Tile',
                  value: '',
                  imagePath: 'lib/images/vt1.png',
                  onTap: () {},
                  color: Colors.white,
                  isTopTile: true,
                ),
                Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Grid of health data tiles
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0.w,
                        mainAxisSpacing: 16.0.h,
                        childAspectRatio: 1.2,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // Heart Rate tile
                          HealthDataTile(
                            label: 'Heart Rate',
                            value: '72 BPM',
                            imagePath: 'lib/images/heart.webp',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DetailedViewScreen()),
                              );
                            },
                            color: tileBgColor,
                          ),
                          // ECG tile
                          HealthDataTile(
                            label: 'ECG',
                            value: 'Normal',
                            imagePath: 'lib/images/ecg.webp',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ViewGraph()),
                              );
                            },
                            color: tileBgColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Body Temperature tile
                      HealthDataTile(
                        label: 'Body Temperature',
                        value:
                            '${_currentTemperature?.toStringAsFixed(1) ?? "N/A"} °C',
                        imagePath: 'lib/images/temp.webp',
                        onTap: () {},
                        color: tileBgColor,
                        isTemperature: true,
                      ),
                      SizedBox(height: 16.h),
                      // Another grid of health data tiles
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0.w,
                        mainAxisSpacing: 16.0.h,
                        childAspectRatio: 1.2,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // Steps tile
                          HealthDataTile(
                            label: 'Steps',
                            value: '10,000 steps',
                            imagePath: 'lib/images/activity.webp',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DetailedViewScreen()),
                              );
                            },
                            color: tileBgColor,
                          ),
                          // SPO2 tile
                          HealthDataTile(
                            label: 'SPO2',
                            value: '92%',
                            imagePath: 'lib/images/O2.webp',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DetailedViewScreen()),
                              );
                            },
                            color: tileBgColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Activity section
                      Text(
                        'Activity',
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.h),
                      // Horizontal scrollable list of activity tiles
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Sitting activity tile
                            HealthDataTile(
                              label: 'Sitting',
                              value: '2 hours',
                              imagePath: '',
                              onTap: () {},
                              color: Colors.grey[200]!,
                              isActivity: true,
                            ),
                            // Walking activity tile
                            HealthDataTile(
                              label: 'Walking',
                              value: '6 hours',
                              imagePath: '',
                              onTap: () {},
                              color: Colors.grey[200]!,
                              isActivity: true,
                            ),
                            HealthDataTile(
                              label: 'Sleeping',
                              value: '8 hours',
                              imagePath: '',
                              onTap: () {},
                              color: Colors.grey[200]!,
                              isActivity: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Scroll indicator at the bottom of the screen
        if (_showScrollIndicator)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
