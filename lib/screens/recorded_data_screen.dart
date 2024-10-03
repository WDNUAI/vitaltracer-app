import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'components/recorded_data_session_tile.dart';
import 'previous_sessions_graph.dart';
import 'package:vitaltracer_app/screens/components/summarized_data_parse_csv.dart';

class RecordedDataScreen extends StatefulWidget {
  const RecordedDataScreen({super.key});
  @override
  _RecordedDataScreenState createState() => _RecordedDataScreenState();
}

class _RecordedDataScreenState extends State<RecordedDataScreen> {
  String time = "_";
  String date = "_";
  String temperature = "_";
  String bloodPressure = "_";

  @override
  void initState() {
    super.initState();
    _loadTemperatureAndDate();
  }

  Future<void> _loadTemperatureAndDate() async {
    Map<String, String> result =
        await SummarizedDataParseCsv.getTemperatureAndDateFromCSV();
    setState(() {
      date = result['date']!;
      time = result['time']!;
      temperature = result['temperature']!;
      bloodPressure = result['bloodPressure']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Previous Sessions'),
        ),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          RecordedDataSessionTile(
              date: date,
              time: time,
              heartRateImagePath: 'lib/images/heartrate.png',
              heartRate: '127',
              temperatureImagePath: 'lib/images/temperature.png',
              temperature: temperature,
              oxygenRateImagePath: 'lib/images/oxygen.png',
              oxygenRate: '0',
              bloodPressureImagePath: 'lib/images/blood-pressure.png',
              bloodPressure: bloodPressure,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PreviousSessionsGraph()),
                );
              })
        ])));
  }
}
