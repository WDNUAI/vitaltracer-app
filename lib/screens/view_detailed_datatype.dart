import 'package:flutter/material.dart';
import 'package:vitaltracer_app/widgets/data_button.dart';
import 'package:vitaltracer_app/widgets/data_detailed_view_page.dart';

class ViewDetailedDatatype extends StatelessWidget {
  const ViewDetailedDatatype({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Detailed Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select the type of data to view.',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.blue,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            DataButton(
              buttonIconImage: 'lib/images/heartrate.png',
              buttonData: 'Heart Rate',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataDetailedViewPage(
                      datatypeTitle: 'Heart Rate',
                      dataGraph: 'lib/images/ECGData.png',
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            DataButton(
              buttonIconImage: 'lib/images/blood-pressure.png',
              buttonData: 'Blood Pressure',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataDetailedViewPage(
                      datatypeTitle: 'Blood Pressure',
                      dataGraph: 'lib/images/ECGData.png',
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            DataButton(
              buttonIconImage: 'lib/images/temperature.png',
              buttonData: 'Temperature',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataDetailedViewPage(
                      datatypeTitle: 'Temperature',
                      dataGraph: 'lib/images/ECGData.png',
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            DataButton(
              buttonIconImage: 'lib/images/oxygen.png',
              buttonData: 'Oxygen Levels',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataDetailedViewPage(
                      datatypeTitle: 'Oxygen Levels',
                      dataGraph: 'lib/images/ECGData.png',
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            DataButton(
              buttonIconImage: 'lib/images/activity.png',
              buttonData: 'Activity',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataDetailedViewPage(
                      datatypeTitle: 'Activity',
                      dataGraph: 'lib/images/ECGData.png',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
