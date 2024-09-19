import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:provider/provider.dart';
import 'package:vitaltracer_app/models/theme_notifier.dart';
import 'detailed_view_screen.dart';
import 'ble-connections-screen.dart';
import 'components/health_data_tile.dart';
import 'settings.dart';
import 'hamburger.dart';

class ConfigurePatch extends StatelessWidget {
  const ConfigurePatch({super.key});


  @override
  Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
      //give title to list of below apps
      title: const Text('Settings'),
    ),
    // Hamburger menu in the leading position

    // Main content of the home screen
    body: const ConfigurePatchContent(),
  );
  }
}

class ConfigurePatchContent extends StatefulWidget {
  const ConfigurePatchContent({super.key});

  @override
  _ConfigurePatchContentState createState() => _ConfigurePatchContentState();

}

class _ConfigurePatchContentState extends State<ConfigurePatchContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false),
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top tile with device information
                        buildTopTile(context),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Configure over Bluetooth",textScaler: TextScaler.linear(1.8))
                        ),
                        GestureDetector(
                            onTap: () {log("working");},
                            // enables the entire row to be tapable rather than just the text itself.
                            behavior: HitTestBehavior.translucent,
                            child:
                        Row(
                          children: [

                            Container(
                                padding: EdgeInsets.only(left: 16.0),
                            child: Icon(Icons.power_settings_new)
                            ),
                            Container(

                                padding: EdgeInsets.all(16.0),
                                child: Text("Factory Reset",textScaler: TextScaler.linear(1.5))

                            )
                          ],
                        )
    )

                      ])
              )
          )
        ]);
  }

  Widget buildTopTile(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0.w),
      decoration: BoxDecoration(
        color: Color(0x0F1622),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text('VT-Patch 1',
                  textScaler: TextScaler.linear(1.5)),
                Text('00-B0-D0-63-C2-26',
                    textScaler: TextScaler.linear(1.2)),
                SizedBox(height: 8.h),
                Text(
                  'Connected',
                  style: TextStyle(color: Colors.green),
                  textScaler: TextScaler.linear(1.5),
                ),
              ],
            ),
            // Device image
            Image.asset(
              'lib/images/vt1.png',
              height: 100.h,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
