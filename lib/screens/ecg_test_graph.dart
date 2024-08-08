import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../services/bluetooth_service.dart';

// The TestViewGraph widget is a stateful widget that displays real-time ECG data in a line chart.
class ViewGraph extends StatefulWidget {
  const ViewGraph({Key? key}) : super(key: key);

  @override
  _TestViewGraphState createState() => _TestViewGraphState();
}

class _TestViewGraphState extends State<ViewGraph> {
  // List to store the live ECG data points for the chart
  List<LiveData> ecgChartData = [];
  // Controller to update the chart dynamically
  ChartSeriesController? _ecgChartSeriesController;
  // Maximum number of data points to display in the chart
  int maxDataPoints = 1000;
  // Scale factor for x-axis to account for the sample rate (250 Hz)
  double xScaleFactor = 250.0;
  // Subscription to the ECG data stream from the Bluetooth service
  StreamSubscription<List<int>>? ecgSubscription;
  // Time when the data collection starts
  double startTime = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the start time in seconds since epoch
    startTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
    // Initialize the data collection from the ECG stream
    _initializeData();
  }

  // Method to initialize data collection from the Bluetooth service
  void _initializeData() {
    // Subscribe to the ECG data stream
    ecgSubscription = VTBluetoothService.ecgStream.listen((ecgData) {
      // Check if the widget is still mounted to avoid errors when updating state
      if (mounted) {
        setState(() {
          // Add the new ECG data to the chart data
          _addEcgData(ecgData);
        });
      }
    });
  }

  // Method to add new ECG data points to the chart data
  void _addEcgData(List<int> ecgData) {
    // Get the current time in seconds
    final currentTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
    // Iterate over the ECG data, converting each pair of bytes to a value
    for (int i = 0; i < ecgData.length; i += 2) {
      // Combine two bytes to form the ECG value
      int value = (ecgData[i + 1] << 8) | ecgData[i];
      // Calculate the time for each data point
      double time = currentTime - startTime + (i / 2) / xScaleFactor;
      // Add the new data point to the chart data list
      ecgChartData.add(LiveData(time, value));
    }

    // Remove old data points if the list exceeds the maximum size
    while (ecgChartData.length > maxDataPoints) {
      ecgChartData.removeAt(0);
    }

    // Update the chart with the new data points
    if (_ecgChartSeriesController != null) {
      _ecgChartSeriesController!.updateDataSource(
        // Add indexes of new data points to the chart
        addedDataIndexes: List.generate(ecgData.length ~/ 2,
            (i) => ecgChartData.length - ecgData.length ~/ 2 + i),
        // Remove indexes of old data points from the chart if necessary
        removedDataIndexes: ecgChartData.length > maxDataPoints
            ? List.generate(ecgData.length ~/ 2, (i) => i)
            : [],
      );
    }
  }

  @override
  void dispose() {
    // Cancel the ECG data subscription to prevent memory leaks
    ecgSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ECG Monitor'),
      ),
      body: Column(
        children: [
          // Expanded widget to display the chart
          Expanded(
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: NumericAxis(
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                // Set minimum and maximum values for the x-axis
                minimum: ecgChartData.isNotEmpty ? ecgChartData.first.time : 0,
                maximum: ecgChartData.isNotEmpty ? ecgChartData.last.time : 4,
                interval: 0.2,
                title: AxisTitle(text: 'Time (s)'),
              ),
              primaryYAxis: NumericAxis(
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                minimum: 0,
                maximum: 300,
                interval: 50,
                title: AxisTitle(text: 'ECG'),
              ),
              // Line series to plot the ECG data points
              series: <LineSeries<LiveData, double>>[
                LineSeries<LiveData, double>(
                  dataSource: ecgChartData,
                  xValueMapper: (LiveData data, _) => data.time,
                  yValueMapper: (LiveData data, _) => data.ecg.toDouble(),
                  color: Colors.blue,
                  width: 2,
                  onRendererCreated: (ChartSeriesController controller) {
                    // Assign the chart series controller to update the chart
                    _ecgChartSeriesController = controller;
                  },
                )
              ],
            ),
          ),
          // Display the calculated heart rate below the chart
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Heart Rate: ${_calculateHeartRate()} BPM',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Method to calculate the heart rate based on recent ECG data
  int _calculateHeartRate() {
    // Ensure there are enough data points to calculate the heart rate
    if (ecgChartData.length < 500) return 0;

    // Extract the ECG values from the last second of data
    List<double> lastSecondData = ecgChartData
        .sublist(ecgChartData.length - 250)
        .map((e) => e.ecg.toDouble())
        .toList();
    int peakCount = 0;
    // Count the number of peaks in the ECG data (where a peak is higher than its neighbors and above a threshold)
    for (int i = 1; i < lastSecondData.length - 1; i++) {
      if (lastSecondData[i] > lastSecondData[i - 1] &&
          lastSecondData[i] > lastSecondData[i + 1] &&
          lastSecondData[i] > 200) {
        peakCount++;
      }
    }
    // Multiply the number of peaks by 60 to convert to beats per minute (BPM)
    return peakCount * 60;
  }
}

// Class to represent a data point in the ECG chart
class LiveData {
  final double time; // Time in seconds
  final int ecg; // ECG value

  LiveData(this.time, this.ecg);
}
