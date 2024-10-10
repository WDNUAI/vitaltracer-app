import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vitaltracer_app/screens/recorded_data_screen.dart';
import '../services/bluetooth_service.dart';

class LiveData {
  late final double time; // Time in seconds
  final int ecg; // ECG value
  final int irCount; // IR count value
  final int activity; // Activity value
  final int redCount; // Red count value
  final DateTime recordingDate; 
  LiveData(this.time, this.ecg, this.irCount, this.activity, this.redCount, this.recordingDate);
}

// RecordingStore class to save session-based data - persist the recording data when not on recording screen - accessed byt recorded_data_screen.dart
class RecordingStore {
  static final RecordingStore _instance = RecordingStore._internal();
  factory RecordingStore() => _instance;

  // Store lists of recorded data
  List<List<LiveData>> _ecgRecordings = [];
  List<List<LiveData>> _irRecordings = [];
  List<List<LiveData>> _activityRecordings = [];
  List<List<LiveData>> _redCountRecordings = [];

  // Singleton pattern to access the same instance
  RecordingStore._internal();

  // Add a field to store the recording date
List<DateTime> _recordingDates = [];

//Metod to save recording and tag datetime
void saveRecording({
  required List<LiveData> ecgData,
  required List<LiveData> irData,
  required List<LiveData> activityData,
  required List<LiveData> redCountData,
  required DateTime recordingDate,
}) {
  _ecgRecordings.add(List.from(ecgData));
  _irRecordings.add(List.from(irData));
  _activityRecordings.add(List.from(activityData));
  _redCountRecordings.add(List.from(redCountData));
  _recordingDates.add(recordingDate);  // Add the recording date
}

// Method to retrieve recording dates - Not used as its passed in LIVE data- this way may be more efficient as it only passes one date
List<DateTime> getRecordingDates() => _recordingDates;


  // Retrieve all recordings for purpose of saving them to be used in Recorded_data_screen.dart
  List<List<LiveData>> getAllECGRecordings() => _ecgRecordings;
  List<List<LiveData>> getAllIRRecordings() => _irRecordings;
  List<List<LiveData>> getAllActivityRecordings() => _activityRecordings;
  List<List<LiveData>> getAllRedCountRecordings() => _redCountRecordings;

  // Clear all recordings (if needed)
  void clearRecordings() {
    _ecgRecordings.clear();
    _irRecordings.clear();
    _activityRecordings.clear();
    _redCountRecordings.clear();
  }
}

class TestViewGraph extends StatefulWidget {
  const TestViewGraph({Key? key}) : super(key: key);
  @override
  _ViewGraphState createState() => _ViewGraphState();
}

class _ViewGraphState extends State<TestViewGraph> {
  List<LiveData> ecgChartData = [];
  List<LiveData> irChartData = [];
  List<LiveData> activityChartData = [];
  List<LiveData> redCountChartData = [];
   List<LiveData> ecgRecordedData = [];
  List<LiveData> irRecordedData = [];
  List<LiveData> activityRecordedData = [];
  List<LiveData> redCountRecordedData = [];
  ChartSeriesController? _ecgChartSeriesController;
  ChartSeriesController? _irChartSeriesController;
  ChartSeriesController? _activityChartSeriesController;
  ChartSeriesController? _redCountSeriesController;

  double xScaleFactor = 250;
  double startTime = 0;
  bool showIRGraph = true;
  bool showECGGraph = true;
  bool showActivityGraph = true;
  bool showRedCountGraph = true;

  double zoomFactor = 1.0; // Initially no zoom
  late StreamSubscription<List<int>> ecgSubscription;
  late StreamSubscription<List<int>> activitySubscription;
  late StreamSubscription<double> temperatureSubscription;
  Timer? _chartUpdateTimer;
  //Adjust in future to whatever the default time is for patch
  Timer? _recordingTimer;
  int recordingDuration = 2;

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
    _initializeData();
    _startRecordingTimer();
    // Update chart at regular intervals (e.g., every 200 ms)
    _chartUpdateTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          _updateChart();
        });
      }
    });
    
  }

  void _initializeData() {
    ecgSubscription = VTBluetoothService.ecgStream.listen((ecgData) {
      if (mounted) {
        _addDataInBatch(ecgData, 'ECG');
      }
    });
    activitySubscription =
        VTBluetoothService.activityStream.listen((activityData) {
      print('Received activity data: $activityData'); // Debugging output
      if (mounted) {
        _addDataInBatch(activityData, 'Activity');
      }
    });
  }

// Add this variable to store the last activity value
  int lastActivityValue = 0; // Start with 0 as the default value
   void _addDataInBatch(List<int> data, String source) {
    final currentTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
    DateTime now = DateTime.now();
    int batchSize = 275; // Adjust the batch size to plot more points

    for (int i = 0; i < data.length && i < batchSize * 4; i += 4) {
      double time = currentTime - startTime + (i / 2) / xScaleFactor;

      if (source == 'ECG') {
        int ecgValue = (data[i + 1] << 8) | data[i];
        ecgChartData.add(LiveData(time, ecgValue, 0, 0, 0, now));
        ecgRecordedData.add(LiveData(time, ecgValue, 0, 0, 0, now)); // Store separately
      } else if (source == 'IR') {
        int irValue = (data[i + 1] << 8) | data[i];
        irChartData.add(LiveData(time, 0, irValue, 0, 0, now));
        irRecordedData.add(LiveData(time, 0, irValue, 0, 0, now)); // Store separately
      } else if (source == 'Activity') {
        int activityValue = (data[i + 1] << 8) | data[i];
        activityValue = activityValue > 0 ? 1 : 0; // Binary transformation
        activityChartData.add(LiveData(time, 0, 0, activityValue, 0, now));
        activityRecordedData.add(LiveData(time, 0, 0, activityValue, 0, now)); // Store separately
      } else if (source == 'RedCount') {
        int redCountValue = (data[i + 1] << 8) | data[i];
        redCountChartData.add(LiveData(time, 0, 0, 0, redCountValue, now));
        redCountRecordedData.add(LiveData(time, 0, 0, 0, redCountValue, now)); // Store separately
      }
    }
  }


void _startRecordingTimer() {
    // Cancel any previous timer
    _recordingTimer?.cancel();

    // Start a new recording timer based on the recording duration
    _recordingTimer = Timer(Duration(minutes: recordingDuration), () {
      _stopRecording(); // Save the data after the set duration
    });}

  void _updateChart() {
    double currentTime = DateTime.now().millisecondsSinceEpoch / 1000.0;

    // Apply zoom factor to extend the time window for data retention - can customative value in expression to change how long x axis will be
    ecgChartData.removeWhere(
        (data) => currentTime - startTime - data.time > 3 * zoomFactor);
    irChartData.removeWhere(
        (data) => currentTime - startTime - data.time > 4 * zoomFactor);
    activityChartData.removeWhere(
        (data) => currentTime - startTime - data.time > 8 * zoomFactor);
    redCountChartData.removeWhere(
        (data) => currentTime - startTime - data.time > 4 * zoomFactor);

    _ecgChartSeriesController?.updateDataSource(
      addedDataIndexes: List.generate(ecgChartData.length, (index) => index),
    );
    _irChartSeriesController?.updateDataSource(
      addedDataIndexes: List.generate(irChartData.length, (index) => index),
    );
    _activityChartSeriesController?.updateDataSource(
      addedDataIndexes:
          List.generate(activityChartData.length, (index) => index),
    );
    _redCountSeriesController?.updateDataSource(
      addedDataIndexes: List.generate(redCountChartData.length, (index) => index),
    );
  }

  // Stop the recording and save data to the RecordingStore
  void _stopRecording() {

     // Check if there's any recorded data before saving- modify to include all data types when neccesary
  if (ecgRecordedData.isEmpty &&  activityRecordedData.isEmpty ) {
    // Show an error message if no data is available
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("No data to save. Please record some data before saving."),
      ),
    );
    return; // Exit early if no data
  }
    ecgSubscription.cancel();
    activitySubscription.cancel();

    // Save data to RecordingStore
    RecordingStore().saveRecording(
      ecgData: ecgRecordedData, // Use separate recording data
      irData: irRecordedData,
      activityData: activityRecordedData,
      redCountData: redCountRecordedData,
      recordingDate: DateTime.now(),
    );
//When save button is pushed, change context to RecordedData Screen to create widget
     Navigator.push(
    context,
    //in future could pass the date thru here, however storing in RecordStore allows for persistence of the data so long as app is running
    MaterialPageRoute(builder: (context) => RecordedDataScreen()), // Navigate to RecordedDataScreen
  );
  }

  @override
  void dispose() {
    ecgSubscription.cancel();
    _chartUpdateTimer?.cancel();
    _recordingTimer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    //calculate amount of room on screen given the visibility of each graph
    int visibleGraphs = (showIRGraph ? 1 : 0) +
        (showECGGraph ? 1 : 0) +
        (showRedCountGraph ? 1 : 0) +
        (showActivityGraph ? 1 : 0);

    double availableHeight =
        MediaQuery.of(context).size.height - kToolbarHeight - 80;
    double chartHeight =
        visibleGraphs > 0 ? availableHeight / visibleGraphs : availableHeight;

  return Scaffold(
    appBar: AppBar(
      actions: [
        //Add settings icon to adjust recording lenghts
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: _showSettingsMenu,
        ),
        IconButton(
          icon: Icon(zoomFactor == 1.0 ? Icons.zoom_out : Icons.zoom_in),
          onPressed: () {
            setState(() {
              zoomFactor = (zoomFactor == 1.0) ? 2.0 : 1.0;
            });
          },
        ),
        IconButton(
          icon: const Text('Show All'),
          onPressed: () {
            setState(() {
              showIRGraph = true;
              showECGGraph = true;
              showActivityGraph = true;
              showRedCountGraph = true;
                  
            });
          },
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showIRGraph)
            _buildGraphContainer(chartHeight, _irChartSeriesController, irChartData, 'IR Count', showIRGraph),
          if (showECGGraph)
            _buildGraphContainer(chartHeight, _ecgChartSeriesController, ecgChartData, 'ECG', showECGGraph),
          if (showActivityGraph)
            _buildGraphContainer(chartHeight, _activityChartSeriesController, activityChartData, 'Activity', showActivityGraph),
          if (showRedCountGraph)
            _buildGraphContainer(chartHeight, _redCountSeriesController, redCountChartData, 'Red Count', showRedCountGraph),
        ],
      ),
    ),
    //Add Save Icon to Manually stop recording - place at bottom right space 
    floatingActionButton: FloatingActionButton.extended(
      onPressed: _stopRecording, // Save recording when pressed
      label: Row(
        children: [
          const Icon(Icons.save), // Icon for save
          const SizedBox(width: 8), // Spacing between icon and text
          const Text('Save'), // Save text
        ],
      ),
      backgroundColor: Colors.blue, 
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Positioning at the bottom right
  );
}


  Widget _buildGraphContainer(
    double chartHeight,
    ChartSeriesController? controller,
    List<LiveData> chartData,
    String title,
    bool visibility,
  ) {
    return Container(
      height: chartHeight,
      child: Stack(
        children: [
          SfCartesianChart(
            series: <FastLineSeries<LiveData, double>>[
              FastLineSeries<LiveData, double>(
                onRendererCreated: (ChartSeriesController chartController) {
                  controller = chartController;
                },
                dataSource: chartData,
                xValueMapper: (LiveData data, _) => data.time,
                yValueMapper: (LiveData data, _) {
                  if (title == 'Activity') {
                    return data.activity
                        .toDouble(); // Adjusted for binary activity
                  } else if (title == 'ECG') {
                    return data.ecg.toDouble();
                  } else if (title == 'IR Count') {
                    return data.irCount.toDouble();
                  } else if (title == 'Red Count') {
                    return data.redCount.toDouble();
                  }
                  return 0.0;
                },
              )
            ],
            primaryXAxis: const NumericAxis(
              majorGridLines: MajorGridLines(width: 0),
              axisLine: AxisLine(width: 0),
              labelStyle: TextStyle(color: Colors.transparent), // Hide labels
              interval: 1,
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: title),
              //Set min and max values of activity chart to allow user to see it easier
              minimum:
                  title == 'Activity' ? -1 : null, // Set minimum for Activity
              maximum:
                  title == 'Activity' ? 2 : null, // Set maximum for Activity
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              icon: Icon(visibility ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  if (title == 'Activity') {
                    showActivityGraph = !showActivityGraph;
                  } else if (title == 'ECG') {
                    showECGGraph = !showECGGraph;
                  } else if (title == 'IR Count') {
                    showIRGraph = !showIRGraph;
                  } else if (title == 'Red Count') {
                    showRedCountGraph = !showRedCountGraph;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

void _showSettingsMenu() {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: StatefulBuilder( // Use StatefulBuilder to manage the state of the modal
          builder: (context, setModalState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Recording Duration: $recordingDuration minutes',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Slider(
                  //Can adjust to change max lenght of recording sessions device allows for 
                  value: recordingDuration.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 15,
                  label: recordingDuration.toString(),
                  onChanged: (value) {
                    setModalState(() { 
                      //Value the slider is on is set to recording duration in real time - should adjust below button to instead confirm this value.
                      recordingDuration = value.toInt();
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    // Close the modal
                    Navigator.pop(context);

                    // Cancel any previous timer
                    _recordingTimer?.cancel();

                    // Start a new timer based on the recording duration (converted to seconds)
                    _recordingTimer = Timer(Duration(minutes: recordingDuration), () {
                      _stopRecording(); // Save the data after the set duration
                    });
                  },
                  child: const Text('Change Recording Duration'),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
}
