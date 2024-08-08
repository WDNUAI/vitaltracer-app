import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../ble-connections-screen.dart';

/// A versatile widget for displaying various types of health data tiles
class HealthDataTile extends StatelessWidget {
  // Properties for configuring the tile
  final String label;
  final String value;
  final String imagePath;
  final VoidCallback onTap;
  final Color color;
  final bool isTemperature;
  final bool isTopTile;
  final bool isActivity;

  /// Constructor for the HealthDataTile
  /// 
  /// [label]: The title or name of the health data
  /// [value]: The current value or status of the health data
  /// [imagePath]: Path to the icon or image representing the data
  /// [onTap]: Callback function when the tile is tapped
  /// [color]: Background color of the tile
  /// [isTemperature]: Flag to indicate if this is a temperature tile
  /// [isTopTile]: Flag to indicate if this is the top device info tile
  /// [isActivity]: Flag to indicate if this is an activity tile
  const HealthDataTile({
    Key? key,
    required this.label,
    required this.value,
    required this.imagePath,
    required this.onTap,
    required this.color,
    this.isTemperature = false,
    this.isTopTile = false,
    this.isActivity = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine which type of tile to build based on the flags
    if (isTopTile) {
      return _buildTopTile(context);
    } else if (isTemperature) {
      return _buildTemperatureTile();
    } else if (isActivity) {
      return _buildActivityTile();
    } else {
      return _buildStandardTile();
    }
  }

  /// Builds the top tile containing device information and selection
  Widget _buildTopTile(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                SizedBox(height: 8.h),
                // Button to choose a device
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BluetoothConnectionsScreen()),
                    );
                  },
                  child: Text('Choose Device'),
                ),
                SizedBox(height: 8.h),
                // Help text
                Text(
                  'Having trouble? View help',
                  style: TextStyle(fontSize: 14.sp, color: Colors.blue),
                ),
              ],
            ),
            // Device image
            Image.asset(
              imagePath,
              height: 80.h,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a standard health data tile
  Widget _buildStandardTile() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Health data icon
            Image.asset(
              imagePath,
              height: 50.h,
              width: 50.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 8.h),
            // Health data label
            Text(
              label,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.h),
            // Health data value
            Text(
              value,
              style: TextStyle(fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a temperature-specific tile
  Widget _buildTemperatureTile() {
    return Container(
      width: double.infinity,
      height: 100.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            // Temperature icon
            Image.asset(
              imagePath,
              height: 50.h,
              width: 50.w,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Temperature label
                Text(
                  label,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                // Temperature value
                Text(
                  value,
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an activity-specific tile
  Widget _buildActivityTile() {
    return Container(
      width: 150.w,
      margin: EdgeInsets.only(right: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Activity name
          Text(label,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          // Activity duration
          Text(value, style: TextStyle(fontSize: 14.sp)),
        ],
      ),
    );
  }
}