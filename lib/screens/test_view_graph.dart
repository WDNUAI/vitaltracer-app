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
      20; // Amount of data to be displayed per update (5ms x 50 points = 250ms of data or 1/4 second)
  double xScaleFactor = 1000.0; // Scale factor to convert ms to seconds
  List<LiveData> _irStoredData = [];
  List<LiveData> _ecgStoredData = [];
  int _currentIndex = 0;
  bool showIRGraph = true; // Toggle variable to control IR graph
  bool showECGGraph = true; // Toggle variable to control ECG graph

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
    const int updateIntervalMs = 100; // Timer for when we update state again
    _timer = Timer.periodic(Duration(milliseconds: updateIntervalMs), (timer) {
      if (!mounted) return; // Check if widget is still mounted
      if (_currentIndex < _irStoredData.length &&
          _currentIndex < _ecgStoredData.length) {
        //set state to new data points if we have not parsed entire list
        setState(() {
          // Calculate the number of points to add in batches, allows the application to run smoothly
          int remainingPoints = _irStoredData.length - _currentIndex;
          int pointsToAdd =
              remainingPoints < batchSize ? remainingPoints : batchSize;

          // Add new points to irChartData and remove oldest points if exceeds maxDataPoints
          if (showIRGraph) {
            irChartData.addAll(_irStoredData.getRange(
                _currentIndex, _currentIndex + pointsToAdd));
            if (irChartData.length > maxDataPoints) {
              irChartData.removeRange(0, irChartData.length - maxDataPoints);
            }

            // Update the IR chart
            if (_irChartSeriesController != null) {
              _irChartSeriesController!.updateDataSource(
                addedDataIndexes: List.generate(
                    pointsToAdd, (i) => irChartData.length - pointsToAdd + i),
                removedDataIndexes: irChartData.length > maxDataPoints
                    ? List.generate(irChartData.length - maxDataPoints, (i) => i)
                    : [],
              );
            }
          }

          // Add new points to ecgChartData and remove oldest points if exceeds maxDataPoints
          if (showECGGraph) {
            ecgChartData.addAll(_ecgStoredData.getRange(
                _currentIndex, _currentIndex + pointsToAdd));
            if (ecgChartData.length > maxDataPoints) {
              ecgChartData.removeRange(0, ecgChartData.length - maxDataPoints);
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

//Function to remove timer started when data update is called
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

//Widget to Pop out and give user option to toggle graphs and style
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recording'),
        actions: [
          IconButton(
            //Show settings cog - pop out menu when pressed
            icon: const Icon(Icons.settings),
            onPressed: () {

              //Usage of below function https://dev.to/theotherdevs/getting-to-know-flutter-advanced-use-of-modalbottomsheet-1hjf
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //Show IR Graph in menu, start data update when pressed but willl be removed when we parse in real time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Show IR Graph'),
                            Switch(
                              value: showIRGraph,
                              onChanged: (value) {
                                setState(() {
                                  showIRGraph = value;
                                  if (showIRGraph && isRecording) {
                                    _irChartSeriesController = null;
                                    _startDataUpdate();
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        //ECG Toggle button 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Show ECG Graph'),
                            Switch(
                              value: showECGGraph,
                              onChanged: (value) {
                                setState(() {
                                  showECGGraph = value;
                                  if (showECGGraph && isRecording) {
                                    _ecgChartSeriesController = null;
                                    _startDataUpdate();
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
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
                const SizedBox(height: 16),
                // Conditional rendering of IR Count graph
                if (showIRGraph)
                  Container(
                    height: showECGGraph ? 300 : 600,
                    child: SfCartesianChart(
                      primaryXAxis: NumericAxis(
                        majorGridLines: const MajorGridLines(width: 1),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        interval: 1, // Adjusted interval for whole numbers
                        title: const AxisTitle(text: 'Time (s)'),
                      ),
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
                          onRendererCreated:
                              (ChartSeriesController controller) {
                            _irChartSeriesController = controller;
                          },
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                // Conditional rendering of ECG graph
                if (showECGGraph)
                  Container(
                    height: showIRGraph ? 300 : 600,
                    child: SfCartesianChart(
                      primaryXAxis: NumericAxis(
                        majorGridLines: const MajorGridLines(width: 1),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        interval: 1, // Adjusted interval for whole numbers
                        title: const AxisTitle(text: 'Time (s)'),
                      ),
                      primaryYAxis: const NumericAxis(
                        axisLine: AxisLine(width: 1),
                        majorTickLines: MajorTickLines(size: 10),
                        title: AxisTitle(text: 'ECG'),
                      ),
                      series: <LineSeries<LiveData, double>>[
                        LineSeries<LiveData, double>(
                          dataSource: ecgChartData,
                          xValueMapper: (LiveData data, _) => data.time,
                          yValueMapper: (LiveData data, _) =>
                              data.ecg.toDouble(),
                          onRendererCreated:
                              (ChartSeriesController controller) {
                            _ecgChartSeriesController = controller;
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Buttons for starting and stopping the recording
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: isRecording
                      ? null
                      : () {
                          setState(() {
                            isRecording = true;
                            _initializeData(); // Start the data initialization
                          });
                        },
                  child: const Text('Start Recording'),
                ),
                ElevatedButton(
                  onPressed: isRecording
                      ? () {
                          setState(() {
                            isRecording = false;
                            _timer?.cancel();
                            _timer = null;
                          });
                        }
                      : null,
                  child: const Text('Stop Recording'),
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
