import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart' as fl;
import 'dart:async';
import 'parseCsv.dart';

//Methods inspired by example code for using syncfusion for live recording::https://github.com/SyncfusionExamples/how-to-create-a-real-time-flutter-chart-in-10-minutes/blob/main/lib/main.dart

class TestViewGraph extends StatefulWidget {
  const TestViewGraph({Key? key}) : super(key: key);

  @override
  _TestViewGraphState createState() => _TestViewGraphState();
}

class _TestViewGraphState extends State<TestViewGraph> {
  //define blank data sets to be used as a cache
  List<LiveData> irChartData = [];
  List<LiveData> ecgChartData = [];
  //define controller for each real time chart
  ChartSeriesController? _irChartSeriesController;
  ChartSeriesController? _ecgChartSeriesController;
  bool isRecording = false;
  Timer? _timer;
  int maxDataPoints =
      1000; // Modify this value to determine how many points can appear on the graph at once (1000 points x 5ms per point = 5 seconds of dat)
  int batchSize =
      30; // Amount of data to be displayed per update (5ms x 50 points = 250ms of data or 1/4 second)
  double xScaleFactor = 1000.0; // Scale factor to convert ms to seconds
  List<LiveData> _irStoredData = [];
  List<LiveData> _ecgStoredData = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  // Initialize data retrieval and start data updates
  void _initializeData() async {
    List<fl.FlSpot> irSpots = await ParseCSV.getSpotsFromCSV(2);
    List<fl.FlSpot> ecgSpots = await ParseCSV.getSpotsFromCSV(1);
    //store spots some we only need to parse one time - temp
    _irStoredData = irSpots
        .map((spot) => LiveData(spot.x / xScaleFactor, spot.y.toInt(), 0))
        .toList();
    _ecgStoredData = ecgSpots
        .map((spot) => LiveData(spot.x / xScaleFactor, 0, spot.y.toInt()))
        .toList();
    _currentIndex = 0; // Reset index to start from the beginning
    _startDataUpdate(); // Start data updates
  }

  // Method for starting periodic data updates - first 150 rows have bad data - discuss with Luca on if they want to remove calibration view
  void _startDataUpdate() {
    const int updateIntervalMs = 300; // timer for when we update state again
    _timer =
        Timer.periodic(const Duration(milliseconds: updateIntervalMs), (timer) {
      if (_currentIndex < _irStoredData.length &&
          _currentIndex < _ecgStoredData.length) {
        //set state to new data points if we have not parsed entire list
        setState(() {
          // Calculate the number of points to add in batches, allows the application to run smoothly
          int remainingPoints = _irStoredData.length - _currentIndex;
          int pointsToAdd =
              remainingPoints < batchSize ? remainingPoints : batchSize;

          // Add new points to irChartData and remove oldest points if exceeds maxDataPoints
          irChartData.addAll(_irStoredData.getRange(
              _currentIndex, _currentIndex + pointsToAdd));
          if (irChartData.length > maxDataPoints) {
            irChartData.removeRange(0, irChartData.length - maxDataPoints);
          }

          // Add new points to ecgChartData and remove oldest points if exceeds maxDataPoints
          ecgChartData.addAll(_ecgStoredData.getRange(
              _currentIndex, _currentIndex + pointsToAdd));
          if (ecgChartData.length > maxDataPoints) {
            ecgChartData.removeRange(0, ecgChartData.length - maxDataPoints);
          }

          // Update the IR chart
          if (_irChartSeriesController != null) {
            _irChartSeriesController!.updateDataSource(
              //add points to graph
              addedDataIndexes: List.generate(
                  pointsToAdd, (i) => irChartData.length - pointsToAdd + i),
              //remove indexs if length past chart length
              removedDataIndexes: irChartData.length > maxDataPoints
                  ? List.generate(irChartData.length - maxDataPoints, (i) => i)
                  : [],
            );
          }

          // Update the ECG chart
          if (_ecgChartSeriesController != null) {
            _ecgChartSeriesController!.updateDataSource(
              addedDataIndexes: List.generate(
                  pointsToAdd, (i) => ecgChartData.length - pointsToAdd + i),
              removedDataIndexes: ecgChartData.length > maxDataPoints
                  ? List.generate(ecgChartData.length - maxDataPoints, (i) => i)
                  : [],
            );
          }

          // Update the current index
          _currentIndex += pointsToAdd;
        });

        // Stop the timer if we've reached the end of the stored data
        if (_currentIndex >= _irStoredData.length ||
            _currentIndex >= _ecgStoredData.length) {
          timer.cancel();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed View'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Live stream section for recordings
            Column(
              children: [
                const Text(
                  'Live Recording of Data',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                //Container for IR Count
                Container(
                  height: 300,
                  child: SfCartesianChart(
                    //Adjust X Axis properties
                    primaryXAxis: const NumericAxis(
                      majorGridLines: MajorGridLines(width: 1),
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      interval: 1, // Adjusted interval for better readability
                      title: AxisTitle(text: 'Time (s)'),
                    ),
                    //Adjust Y Axis properties
                    primaryYAxis: const NumericAxis(
                      axisLine: AxisLine(width: 1),
                      majorTickLines: MajorTickLines(size: 10),
                      title: AxisTitle(text: 'IR Count'),
                    ),
                    series: <LineSeries<LiveData, double>>[
                      LineSeries<LiveData, double>(
                        dataSource: irChartData,
                        xValueMapper: (LiveData data, _) => data.time,
                        yValueMapper: (LiveData data, _) =>
                            data.irCount.toDouble(),
                        onRendererCreated: (ChartSeriesController controller) {
                          _irChartSeriesController = controller;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                //Container for displaying ECG graph. pass in live data to series to be graphed
                Container(
                  //determine heigh or max Y value upon init
                  height: 300,
                  //Adjust X axis properties
                  child: SfCartesianChart(
                    primaryXAxis: const NumericAxis(
                      majorGridLines: MajorGridLines(width: 1),
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      interval: 1, // determines size of spacing on x axis
                      title: AxisTitle(text: 'Time (s)'),
                    ),
                    //Adjust Y  Axis properties
                    primaryYAxis: const NumericAxis(
                      axisLine: AxisLine(width: 1),
                      majorTickLines: MajorTickLines(size: 10),
                      title: AxisTitle(text: 'ECG'),
                      //adjust max and min values in chart
                      minimum: 50,
                      maximum: 250,
                    ),
                    series: <LineSeries<LiveData, double>>[
                      LineSeries<LiveData, double>(
                        dataSource: ecgChartData,
                        xValueMapper: (LiveData data, _) => data.time,
                        yValueMapper: (LiveData data, _) => data.ecg.toDouble(),
                        onRendererCreated: (ChartSeriesController controller) {
                          _ecgChartSeriesController = controller;
                        },
                      ),
                    ],
                  ),
                ),
                // Button to start/stop recording
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Toggle recording state
                      isRecording = !isRecording;
                      if (isRecording) {
                        _initializeData(); // Start recording data
                      } else {
                        _timer?.cancel(); // Stop recording data
                      }
                    });
                  },
                  child:
                      Text(isRecording ? 'Stop Recording' : 'Start Recording'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Modelling time and ir count/ecg data
class LiveData {
  final double time;
  final int irCount;
  final int ecg;

  LiveData(this.time, this.irCount, this.ecg);
}
