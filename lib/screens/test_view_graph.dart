import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'parseCsv.dart';

//Methods inspired by example code for using syncfusion for live recording::https://github.com/SyncfusionExamples/how-to-create-a-real-time-flutter-chart-in-10-minutes/blob/main/lib/main.dart

class TestViewGraph extends StatefulWidget {
  const TestViewGraph({Key? key}) : super(key: key);

  @override
  _TestViewGraphState createState() => _TestViewGraphState();
}

class _TestViewGraphState extends State<TestViewGraph> {
  // Define chart data and controller and set boolean for recording session
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    chartData = []; // Initialize chart data list
  }

  // Initialize data retrieval and start data updates
  void _initializeData() async {
    List<FlSpot> initialSpots = await ParseCSV.getSpotsFromCSV();
    setState(() {
      // Set initial chart data from CSV spots
      chartData = initialSpots
          .map((spot) => LiveData(spot.x.toInt(), spot.y.toInt()))
          .toList();
    });
    _startDataUpdate(); // Start data updates
  }

  // Method for starting periodic data updates - first 150 rows have bad data - discuss with Luca on if they want to remove calibration view
  void _startDataUpdate() {
    const int updateIntervalSeconds = 1;
    const int dataPointsToRemove = 150;

    // Use Timer to trigger data updates at set intervals
    Timer.periodic(const Duration(milliseconds: updateIntervalSeconds),
        (timer) async {
      List<FlSpot> newSpots = await ParseCSV.getSpotsFromCSV();
      setState(() {
        chartData
            .add(LiveData(newSpots.last.x.toInt(), newSpots.last.y.toInt()));
        if (chartData.length > dataPointsToRemove) {
          chartData.removeRange(0, chartData.length - dataPointsToRemove);
        }
      });
      // Update chart data source
      if (_chartSeriesController != null) {
        _chartSeriesController.updateDataSource(
          addedDataIndex: chartData.length - 1,
          removedDataIndex: chartData.length - 1 - dataPointsToRemove,
        );
      }
    });
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
                Text(
                  'Live Recording of Data',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 300,
                  child: SfCartesianChart(
                    primaryXAxis: NumericAxis(
                      majorGridLines: MajorGridLines(width: 1),
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      interval: 20,
                    ),
                    primaryYAxis: NumericAxis(
                      axisLine: AxisLine(width: 1),
                      majorTickLines: MajorTickLines(size: 10),
                    ),
                    series: <LineSeries<LiveData, int>>[
                      LineSeries<LiveData, int>(
                        dataSource: chartData,
                        xValueMapper: (LiveData data, _) => data.time,
                        yValueMapper: (LiveData data, _) => data.irCount,
                        onRendererCreated: (ChartSeriesController controller) {
                          _chartSeriesController = controller;
                        },
                      ),
                    ],
                  ),
                ),
                // Button to start/stop recording
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      //invert state of recording on press
                      isRecording = !isRecording;
                      if (isRecording) {
                        //init data for graphing
                        _initializeData(); // Start recording data
                      }
                    });
                  },
                  //Recording Button for staring live record session to be saved and later extractable
                  child:
                      Text(isRecording ? 'Stop Recording' : 'Start Recording'),
                ),
              ],
            ),

            SizedBox(height: 32),

            // Existing graph section for historical data
            Column(
              children: [
                Text(
                  'ECG Data Session 2024-06-04',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 300,
                  child: FutureBuilder(
                    future: ParseCSV.getSpotsFromCSV(),
                    builder: (context, snapshot) {
                      // if (snapshot.connectionState == ConnectionState.waiting) {
                      // return CircularProgressIndicator();
                      if (snapshot.hasError) {
                        return Text(
                            'Error: ${snapshot.error}'); // Show error message if data fetching fails
                      } else if (snapshot.hasData) {
                        return LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: snapshot
                                    .data!, // Display historical data using FL Chart
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Text(
                            'No data'); // Show message if no data available
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Modelling time and ir count, can add remaining columns as unique color
class LiveData {
  final int time;
  final int irCount;

  LiveData(this.time, this.irCount);
}
