import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../services/bluetooth_service.dart';

class LiveData {
  final double time; // Time in seconds
  final int ecg; // ECG value
  final int irCount; // IR count value
  final int activity; // Activity value
  final int redCount; // Red count value

  LiveData(this.time, this.ecg, this.irCount, this.activity, this.redCount);
}

class TestViewGraph extends StatefulWidget {
  const TestViewGraph({Key? key}) : super(key: key);
  @override
  _ViewGraphState createState() => _ViewGraphState();
}

class _ViewGraphState extends State<TestViewGraph> {
  //init live data chart variables
  List<LiveData> ecgChartData = [];
  List<LiveData> irChartData = [];
  List<LiveData> activityChartData = [];
  List<LiveData> redCountChartData = [];
//init controllers for each chart
  ChartSeriesController? _ecgChartSeriesController;
  ChartSeriesController? _irChartSeriesController;
  ChartSeriesController? _activityChartSeriesController;
  ChartSeriesController? _redCountSeriesController;

  double xScaleFactor =250;
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

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
    _initializeData();

    // Update chart at regular intervals (e.g., every 200 ms)
    _chartUpdateTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          _updateChart();
        });
      }
    });
  }

void _initializeData() {
  
  //init bluetooth services for ecg and activty data - when we figure out how the data looks from Parse the Stream 
  ecgSubscription = VTBluetoothService.ecgStream.listen((ecgData) {
    if (mounted) {
      _addDataInBatch(ecgData, 'ECG');
    }
  });
  activitySubscription = VTBluetoothService.activityStream.listen((activityData) {
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
  int batchSize = 275; // Adjust the batch size to plot more points

  for (int i = 0; i < data.length && i < batchSize * 4; i += 4) {
    double time = currentTime - startTime + (i / 2) / xScaleFactor;

    if (source == 'ECG') {
      int ecgValue = (data[i + 1] << 8) | data[i];
      ecgChartData.add(LiveData(time, ecgValue, 0, 0, 0));
    } else if (source == 'IR') {
      int irValue = (data[i + 1] << 8) | data[i];
      irChartData.add(LiveData(time, 0, irValue, 0, 0));
    } else if (source == 'Activity') {
      int activityValue = (data[i + 1] << 8) | data[i];
      activityValue = activityValue > 0 ? 1 : 0; // Binary transformation - values can only be 1 or zero
      activityChartData.add(LiveData(time, 0, 0, activityValue, 0));
    } else if (source == 'RedCount') {
      int redCountValue = (data[i + 1] << 8) | data[i];
      redCountChartData.add(LiveData(time, 0, 0, 0, redCountValue));
    }
  }
}
void _updateChart() {
  double currentTime = DateTime.now().millisecondsSinceEpoch / 1000.0;

  // Apply zoom factor to extend the time window for data retention - can customative value in expression to change how long x axis will be
  ecgChartData.removeWhere((data) => currentTime - startTime - data.time > 3 * zoomFactor);
  irChartData.removeWhere((data) => currentTime - startTime - data.time > 4 * zoomFactor);
  activityChartData.removeWhere((data) => currentTime - startTime - data.time > 8 * zoomFactor);
  redCountChartData.removeWhere((data) => currentTime - startTime - data.time > 4 * zoomFactor);

  // Update the chart's data source
  _ecgChartSeriesController?.updateDataSource(
    addedDataIndexes: List.generate(ecgChartData.length, (index) => index),
  );
  _irChartSeriesController?.updateDataSource(
    addedDataIndexes: List.generate(irChartData.length, (index) => index),
  );
  _activityChartSeriesController?.updateDataSource(
    addedDataIndexes: List.generate(activityChartData.length, (index) => index),
  );
  _redCountSeriesController?.updateDataSource(
    addedDataIndexes: List.generate(redCountChartData.length, (index) => index),
  );
}


  @override
  void dispose() {
    ecgSubscription.cancel();
    _chartUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //calculate amount of room on screen given the visibility of each graph
    int visibleGraphs = (showIRGraph ? 1 : 0) +
                        (showECGGraph ? 1 : 0) +
                        (showRedCountGraph ? 1 : 0) +
                        (showActivityGraph ? 1 : 0);

    double availableHeight = MediaQuery.of(context).size.height - kToolbarHeight - 80;
    double chartHeight = visibleGraphs > 0 ? availableHeight / visibleGraphs : availableHeight;

    return Scaffold(
      appBar: AppBar(
  title: const Text('Recording'),
  actions: [
    IconButton(
      icon: Icon(zoomFactor == 1.0 ? Icons.zoom_out : Icons.zoom_in),
      onPressed: () {
        setState(() {
          zoomFactor = (zoomFactor == 1.0) ? 2.0 : 1.0; // Toggle zoom factor
        });
      },
    ),
    Container(
      margin: const EdgeInsets.only(right: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        onPressed: () {
          setState(() {
            showIRGraph = true;
            showECGGraph = true;
            showRedCountGraph = true;
            showActivityGraph = true;
          });
        },
        child: const Text(
          'Show All',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  ],
),
//Build chart containers
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
    );
  }Widget _buildGraphContainer(
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
          //Below code fixed lag -using FastLineSeries is optimal for plotting
          series: <FastLineSeries<LiveData, double>>[
            FastLineSeries<LiveData, double>(
              onRendererCreated: (ChartSeriesController chartController) {
                controller = chartController; 
              },
              dataSource: chartData,
              xValueMapper: (LiveData data, _) => data.time,
              yValueMapper: (LiveData data, _) {
                // Adjust the mapping based on the graph title
                if (title == 'Activity') {
                  return data.activity.toDouble(); // Adjusted for binary activity
                } else if (title == 'ECG') {
                  return data.ecg.toDouble();
                } else if (title == 'IR Count') {
                  return data.irCount.toDouble();
                } else if (title == 'Red Count') {
                  return data.redCount.toDouble();
                }
                return 0.0; // Default case
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
            minimum: title == 'Activity' ? -1 : null, // Set minimum for Activity
            maximum: title == 'Activity' ? 2 : null, // Set maximum for Activity
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: IconButton(
            icon: Icon(visibility ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                // Toggle visibility based on the title of the graph
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
}