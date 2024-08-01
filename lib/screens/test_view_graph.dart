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
    List<LiveData> activityChartData = [];
    List<LiveData> redCountChartData = [];
  //define controller for each real time chart
  ChartSeriesController? _irChartSeriesController;
  ChartSeriesController? _ecgChartSeriesController;
  ChartSeriesController? _activityChartSeriesController;
  ChartSeriesController? _RedCountSeriesController;
  bool isRecording = false;
  Timer? _timer;
  int maxDataPoints =
      1000; // Modify this value to determine how many points can appear on the graph at once (1000 points x 5ms per point = 5 seconds of dat)
  int batchSize =
      20; // Amount of data to be displayed per update (5ms x 50 points = 250ms of data or 1/4 second)
  double xScaleFactor = 1000.0; // Scale factor to convert ms to seconds
  List<LiveData> _irStoredData = [];
  List<LiveData> _ecgStoredData = [];
  List<LiveData> _activityStoredData = [];
    List<LiveData> _RedCountStoredData = [];
  int _currentIndex = 0;
  bool showIRGraph = true; // Toggle variable to control IR graph
  bool showECGGraph = true; // Toggle variable to control ECG graph
  bool showActivityGraph = true; // Toggle variable to control Activity graph
bool showRedCountGraph = true; // Toggle variable to control red countgraph

  @override
  void initState() {
    super.initState();
  }

  // Initialize data retrieval and start data updates
  void _initializeData() async {
    List<fl.FlSpot> irSpots = await ParseCSV.getSpotsFromCSV(2);
    List<fl.FlSpot> ecgSpots = await ParseCSV.getSpotsFromCSV(1);
    List<fl.FlSpot> activitySpots = await ParseCSV.getSpotsFromCSV(4);
    List<fl.FlSpot> redCountSpots = await ParseCSV.getSpotsFromCSV(3);

    // store spots so we only need to parse one time - temp
    _irStoredData = irSpots.map((spot) => LiveData(spot.x / xScaleFactor, spot.y.toInt(), 0, 0,0)).toList();
    _ecgStoredData = ecgSpots.map((spot) => LiveData(spot.x / xScaleFactor, 0, spot.y.toInt(), 0,0)).toList();
    _activityStoredData = activitySpots.map((spot) => LiveData(spot.x / xScaleFactor, 0, 0, spot.y.toInt(),0)).toList();
    _RedCountStoredData = redCountSpots.map((spot) => LiveData(spot.x / xScaleFactor, 0, 0,0, spot.y.toInt())).toList();



    _currentIndex = 0; // Reset index to start from the beginning
    _startDataUpdate(); // Start data updates
  }

  // Method for starting periodic data updates - first 150 rows have bad data - discuss with Luca on if they want to remove calibration view
  void _startDataUpdate() {
    const int updateIntervalMs = 100; // Timer for when we update state again
    _timer = Timer.periodic(Duration(milliseconds: updateIntervalMs), (timer) {
      if (!mounted) return; // Check if widget is still mounted
      if (_currentIndex < _irStoredData.length &&
          _currentIndex < _ecgStoredData.length &&
                    _currentIndex < _RedCountStoredData.length &&
          _currentIndex < _activityStoredData.length) {
        // Set state to new data points if we have not parsed entire list
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



           // Add new points to redcount and remove oldest points if exceeds maxDataPoints
          if (showRedCountGraph) {
            redCountChartData.addAll(_RedCountStoredData.getRange(
                _currentIndex, _currentIndex + pointsToAdd));
            if (redCountChartData.length > maxDataPoints) {
              redCountChartData.removeRange(0, redCountChartData.length - maxDataPoints);
            }

            // Update the red couint
            if (_RedCountSeriesController != null) {
              _RedCountSeriesController!.updateDataSource(
                addedDataIndexes: List.generate(
                    pointsToAdd, (i) => redCountChartData.length - pointsToAdd + i),
                removedDataIndexes: redCountChartData.length > maxDataPoints
                    ? List.generate(redCountChartData.length - maxDataPoints, (i) => i)
                    : [],
              );
            }
          }

          // Add new points to activityChartData and remove oldest points if exceeds maxDataPoints
          if (showActivityGraph) {
            activityChartData.addAll(_activityStoredData.getRange(_currentIndex, _currentIndex + pointsToAdd));
            if (activityChartData.length > maxDataPoints) {
              activityChartData.removeRange(0, activityChartData.length - maxDataPoints);
            }

            // Update the Activity chart
            if (_activityChartSeriesController != null) {
              _activityChartSeriesController!.updateDataSource(
                addedDataIndexes: List.generate(pointsToAdd, (i) => activityChartData.length - pointsToAdd + i),
                removedDataIndexes: activityChartData.length > maxDataPoints
                    ? List.generate(activityChartData.length - maxDataPoints, (i) => i)
                    : [],
              );
            }
          }

          // Update the current index
          _currentIndex += pointsToAdd;
        });

        // Stop the timer if we've reached the end of the stored data
        if (_currentIndex >= _irStoredData.length ||
            _currentIndex >= _ecgStoredData.length ||
            _currentIndex >= _RedCountStoredData.length ||
            _currentIndex >= _activityStoredData.length) {
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
    // Calculate the height by getting number of grpahs visible, scale size if more charts visible. 
    int visibleGraphs = (showIRGraph ? 1 : 0) + (showECGGraph ? 1 : 0) + (showRedCountGraph ? 1 : 0) + (showActivityGraph ? 1 : 0);
    double chartHeight = 600 / (visibleGraphs > 0 ? visibleGraphs : 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recording'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Live stream section for recordings
            Column(
              children: [
            
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                // Checkbox to toggle IR graph
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Show IR Graph'),
                    Checkbox(
                      value: showIRGraph,
                      onChanged: (value) {
                        setState(() {
                          showIRGraph = value ?? true;
                          // Reset the controller when toggling the graph
                          _irChartSeriesController = null;
                        });
                      },
                    ),
                  ],
                ),

                //Plot data if graph toggle is set to true
                if (showIRGraph)
                  Container(
                    height: chartHeight,
                    child: SfCartesianChart(
                      series: <LineSeries<LiveData, double>>[
                        LineSeries<LiveData, double>(
                          onRendererCreated: (ChartSeriesController controller) {
                            _irChartSeriesController = controller;
                          },
                          dataSource: irChartData,
                          xValueMapper: (LiveData data, _) => data.time,
                          yValueMapper: (LiveData data, _) => data.irCount,
                        ),
                      ],
                      primaryXAxis: NumericAxis(
                        majorGridLines: const MajorGridLines(width: 0),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        interval: 1, // Set the interval to 1 for whole numbers
                      ),
                      primaryYAxis: NumericAxis(
                        axisLine: const AxisLine(width: 0),
                        majorTickLines: const MajorTickLines(size: 0),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                // Checkbox to toggle ECG graph
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Show ECG Graph'),
                    Checkbox(
                      value: showECGGraph,
                      onChanged: (value) {
                        setState(() {
                          showECGGraph = value ?? true;
                          // Reset the controller when toggling the graph
                          _ecgChartSeriesController = null;
                        });
                      },
                    ),
                  ],
                ),


                //Plot data if graph toggle is set to true
                if (showECGGraph)
                  Container(
                    height: chartHeight,
                    child: SfCartesianChart(
                      series: <LineSeries<LiveData, double>>[
                        LineSeries<LiveData, double>(
                          onRendererCreated: (ChartSeriesController controller) {
                            _ecgChartSeriesController = controller;
                          },
                          dataSource: ecgChartData,
                          xValueMapper: (LiveData data, _) => data.time,
                          yValueMapper: (LiveData data, _) => data.ecg,
                        ),
                      ],
                      primaryXAxis: NumericAxis(
                        majorGridLines: const MajorGridLines(width: 0),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        interval: 1, // Set the interval to 1 for whole numbers
                      ),
                      primaryYAxis: NumericAxis(

                        axisLine: const AxisLine(width: 0),
                        majorTickLines: const MajorTickLines(size: 0),
                        
                      ),
                    ),
                  ),


                  //Checkbox logic
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Show Red Counts'),
                    Checkbox(
                      value: showRedCountGraph,
                      onChanged: (value) {
                        setState(() {
                          showRedCountGraph = value ?? true;
                          // reset the controller when toggling the grap
                          _RedCountSeriesController = null;
                        });
                      },
                    ),
                  ],
                ),

                
                //Plot data if graph toggle is set to true
                  if (showRedCountGraph)   // Show red coount graph
                  Container(
                    height: chartHeight,
                    child: SfCartesianChart(
                      series: <LineSeries<LiveData, double>>[
                        LineSeries<LiveData, double>(
                          onRendererCreated: (ChartSeriesController controller) {
                            _RedCountSeriesController = controller;
                          },
                          dataSource: redCountChartData,
                          xValueMapper: (LiveData data, _) => data.time,
                          yValueMapper: (LiveData data, _) => data.redCount,
                        ),
                      ],
                      primaryXAxis: NumericAxis(
                        majorGridLines: const MajorGridLines(width: 0),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        interval: 1, // set the interval to 1 for whole numbers
                      ),
                      primaryYAxis: NumericAxis(
                        axisLine: const AxisLine(width: 0),
                        majorTickLines: const MajorTickLines(size: 0),
                      ),
                    ),
                  ),


                  
                const SizedBox(height: 16),
                // Checkbox to toggle Activity graph
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Show Activity Graph'),
                    Checkbox(
                      value: showActivityGraph,
                      onChanged: (value) {
                        setState(() {
                          showActivityGraph = value ?? true;
                          // Reset the controller when toggling the graph
                          _activityChartSeriesController = null;
                        });
                      },
                    ),
                  ],
                ),

                
                //Plot data if graph toggle is set to true
                if (showActivityGraph)
                  Container(
                    height: chartHeight,
                    child: SfCartesianChart(
                      series: <LineSeries<LiveData, double>>[
                        LineSeries<LiveData, double>(
                          onRendererCreated: (ChartSeriesController controller) {
                            _activityChartSeriesController = controller;
                          },
                          dataSource: activityChartData,
                          xValueMapper: (LiveData data, _) => data.time,
                          yValueMapper: (LiveData data, _) => data.activity,
                        ),
                      ],
                      primaryXAxis: NumericAxis(
                        majorGridLines: const MajorGridLines(width: 0),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        interval: 1, // Set the interval to 1 for whole numbers
                      ),
                      primaryYAxis: NumericAxis(
                        axisLine: const AxisLine(width: 0),
                        majorTickLines: const MajorTickLines(size: 0),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      // FloatingActionButton for cool looking play btn
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (isRecording) {
              // Stop recording
              _timer?.cancel();
              isRecording = false;
            } else {
              // Start recording
              _initializeData();
              isRecording = true;
            }
          });
        },
        child: Icon(isRecording ? Icons.stop : Icons.play_arrow),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// Class for holding the data to be graphed - can add additional variables for display
class LiveData {
  final double time;
  final int irCount;
  final int ecg;
  final int activity;
  final int redCount;

  LiveData(this.time, this.irCount, this.ecg, this.activity, this.redCount);
}