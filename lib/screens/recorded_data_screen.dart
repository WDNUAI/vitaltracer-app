import 'package:flutter/material.dart';
import 'package:vitaltracer_app/screens/test_view_graph.dart'; 
import 'components/recorded_data_session_tile.dart';
import 'package:intl/intl.dart'; // for date formatting
import 'previous_sessions_graph.dart';

class RecordedDataScreen extends StatefulWidget {
  final List<LiveData>? newRecording;
  //Currently this does nothing - later will adjust logic to pass the date when saving - for now we get date from live data- list may look diff when we work with real data
  final DateTime? recordingDate; // Accept DateTime
//pass in recording data and date
  const RecordedDataScreen({super.key, this.newRecording, this.recordingDate});

  @override
  _RecordedDataScreenState createState() => _RecordedDataScreenState();
}

class _RecordedDataScreenState extends State<RecordedDataScreen> {
  String time = "_";
  String date = "_";
  String temperature = "_";
  String bloodPressure = "_";

  List<List<LiveData>> _allRecordings = [];
  List<List<LiveData>> _todayRecordings = [];
  List<List<LiveData>> _pastWeekRecordings = [];
  List<List<LiveData>> _pastMonthRecordings = [];

  @override
void initState() {
  super.initState();
  _loadRecordings();

}

void _loadRecordings() {
  _allRecordings = RecordingStore().getAllECGRecordings(); // Load all recordings from storage

  final now = DateTime.now();
  final startOfToday = DateTime(now.year, now.month, now.day); 
  final oneWeekAgo = startOfToday.subtract(const Duration(days: 7));
  final oneMonthAgo = startOfToday.subtract(const Duration(days: 30));
//Make empty live data lists for each recording date time period
  _todayRecordings = [];
  _pastWeekRecordings = [];
  _pastMonthRecordings = [];



//Sort Stored recordings based on time present in livedata of each recording
  for (var recording in _allRecordings) {
    //recording date stored in live data for now- will change when working woith real data
    final sessionDate = recording[0].recordingDate;

    // check if the recording is from today
    if (sessionDate.isSameDateAs(now)) {
      _todayRecordings.add(recording);
    }
    // Check if the recording is from the past week - but before today
    else if (sessionDate.isAfter(oneWeekAgo) && sessionDate.isBefore(startOfToday)) {
      _pastWeekRecordings.add(recording);
    }
    // Check if the recording is from the past month but before the past week
    else if (sessionDate.isAfter(oneMonthAgo) && sessionDate.isBefore(oneWeekAgo)) {
      _pastMonthRecordings.add(recording);
    }
  }

  setState(() {}); // Trigger a rebuild
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Sessions'),
        backgroundColor: const Color.fromARGB(255, 43, 87, 249),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              //Build each session grouping
              _buildSessionGroup("Today", _todayRecordings),
              _buildSessionGroup("Past Week", _pastWeekRecordings),
              _buildSessionGroup("Past Month", _pastMonthRecordings),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionCard({
    required String date, 
    required String time, 
    required String temperature, 
    required String bloodPressure,
    VoidCallback? onDetailsPressed,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recording on $date at $time',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              //Folllowing data types will likely change in future  using place holder
              children: [
                _buildInfoTile(
                  'Heart Rate',
                  'lib/images/heartrate.png',
                  '127 bpm',
                ),
                _buildInfoTile(
                  'Temperature',
                  'lib/images/temperature.png',
                  '$temperature °C',
                ),
                _buildInfoTile(
                  'Blood Pressure',
                  'lib/images/blood-pressure.png',
                  bloodPressure,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 177, 245, 254),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onDetailsPressed ?? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PreviousSessionsGraph()),
                );
              },
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String imagePath, String value) {
    return Expanded(
      child: Column(
        children: [
          Image.asset(imagePath, height: 50),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontSize: 16)),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSessionGroup(String title, List<List<LiveData>> recordings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        recordings.isNotEmpty
          ? Column(
              children: recordings.map((recording) {
              final sessionDate = recording[0].recordingDate;
                final sessionTime = DateFormat('hh:mm a').format(sessionDate);

                String sessionTemperature = 'N/A';
                String sessionBloodPressure = 'N/A';

                return _buildSessionCard(
                  date: DateFormat('MMM dd, yyyy').format(sessionDate),
                  time: sessionTime,
                  temperature: sessionTemperature,
                  bloodPressure: sessionBloodPressure,
                  onDetailsPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailedViewScreen(recording: recording),
                      ),
                    );
                  },
                );
              }).toList(),
            )
          : const Text("No recordings available."),
      ],
    );
  }
}

//Comparison to check if two date times are identical and belong in today group
extension DateOnlyCompare on DateTime {
  bool isSameDateAs(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
