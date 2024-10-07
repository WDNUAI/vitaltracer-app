import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as sf;
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'ParseCSV.dart';

class PreviousSessionsGraph extends StatefulWidget {
  const PreviousSessionsGraph({Key? key}) : super(key: key);

  @override
  _PreSessionsHistoryGraph createState() => _PreSessionsHistoryGraph();
}

class _PreSessionsHistoryGraph extends State<PreviousSessionsGraph> {
  List<RecordedData> ecgSpots = [];
  List<RecordedData> irSpots = [];
  List<RecordedData> redSpots = [];
  List<RecordedData> activitySpots = [];

  //double xScaleFactor = 1000.0; // Scale factor to convert ms to seconds
  late sf.TooltipBehavior _tooltipBehavior = sf.TooltipBehavior(enable: true);
  late sf.ZoomPanBehavior _ecgZoomPanBehavior = sf.ZoomPanBehavior(
    enablePinching: true,
    enableDoubleTapZooming: true,
    enablePanning: true,
    zoomMode: sf.ZoomMode.xy, // Enable zooming in both X and Y directions
  );
  late sf.ZoomPanBehavior _irZoomPanBehavior = sf.ZoomPanBehavior(
    enablePinching: true,
    enableDoubleTapZooming: true,
    enablePanning: true,
    zoomMode: sf.ZoomMode.xy, // Enable zooming in both X and Y directions
  );
  late sf.ZoomPanBehavior _redZoomPanBehavior = sf.ZoomPanBehavior(
    enablePinching: true,
    enableDoubleTapZooming: true,
    enablePanning: true,
    zoomMode: sf.ZoomMode.xy, // Enable zooming in both X and Y directions
  );
  late sf.ZoomPanBehavior _activityZoomPanBehavior = sf.ZoomPanBehavior(
    enablePinching: true,
    enableDoubleTapZooming: true,
    enablePanning: true,
    zoomMode: sf.ZoomMode.xy, // Enable zooming in both X and Y directions
  );

  @override
  void initState() {
    super.initState();
    loadECGData(); // Call the function to load the data when the widget is initialized
  }

  // Function to load the ECG data from the CSV
  Future<void> loadECGData() async {
    // Using the ParseCSV.getSpotsFromCSV method to load ECG data
    List<FlSpot> ecgSpot =
        await ParseCSV.getSpotsFromCSV(1); // Column 1 is for ECG
    List<FlSpot> irSpot =
        await ParseCSV.getSpotsFromCSV(2); // Column 2 is for IR
    List<FlSpot> redSpot =
        await ParseCSV.getSpotsFromCSV(3); // Column 3 is for Red
    List<FlSpot> activitySpot =
        await ParseCSV.getSpotsFromCSV(4); // Column 4 is for Motion

    setState(() {
      ecgSpots = ecgSpot
          .map((spot) => RecordedData(spot.x, spot.y.toInt(), 0, 0, 0))
          .toList();
      irSpots = irSpot
          .map((spot) => RecordedData(spot.x, 0, spot.y.toInt(), 0, 0))
          .toList();
      redSpots = redSpot
          .map((spot) => RecordedData(spot.x, 0, 0, spot.y.toInt(), 0))
          .toList();
      activitySpots = activitySpot
          .map((spot) => RecordedData(spot.x, 0, 0, 0, spot.y.toInt()))
          .toList();

      print('ECG Spots: $ecgSpots');
      print('IR Spots: $irSpots');
      print('Red Spots: $redSpots');
      print('Motion Spots: $activitySpots');
    });
  }

  void _resetZoom() {
    _ecgZoomPanBehavior.reset();
    _irZoomPanBehavior.reset();
    _redZoomPanBehavior.reset();
    _activityZoomPanBehavior.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Recorded Session Graph"),
          actions: [
            IconButton(
              icon: Icon(Icons.zoom_out_map), // Icon for zoom reset
              onPressed: _resetZoom, // Call the reset zoom method
            ),
          ],
        ),
        body: Center(
            child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
                height: 150,
                child: sf.SfCartesianChart(
                    tooltipBehavior: _tooltipBehavior,
                    zoomPanBehavior: _ecgZoomPanBehavior,
                    primaryXAxis: const sf.NumericAxis(
                        majorGridLines: sf.MajorGridLines(width: 1),
                        edgeLabelPlacement: sf.EdgeLabelPlacement.shift,
                        interval:
                            10, // Adjusted interval for better readability
                        title: sf.AxisTitle(text: 'Time (s)')),

                    //Adjust Y Axis properties
                    primaryYAxis: const sf.NumericAxis(
                      axisLine: sf.AxisLine(width: 1),
                      majorTickLines: sf.MajorTickLines(size: 10),
                      title: sf.AxisTitle(text: 'ECG (uv)'),
                    ),
                    series: <sf.FastLineSeries<RecordedData, double>>[
                      sf.FastLineSeries<RecordedData, double>(
                          name: 'ECG(uv)',
                          dataSource: ecgSpots,
                          xValueMapper: (RecordedData data, _) =>
                              data.time / 1000,
                          yValueMapper: (RecordedData data, _) =>
                              data.ecg.toDouble(),
                          enableTooltip: true,
                          color: Color.fromARGB(255, 187, 218, 76))
                    ])),
            const SizedBox(height: 10),
            Container(
                height: 150,
                child: sf.SfCartesianChart(
                    tooltipBehavior: _tooltipBehavior,
                    zoomPanBehavior: _irZoomPanBehavior,
                    primaryXAxis: const sf.NumericAxis(
                        majorGridLines: sf.MajorGridLines(width: 1),
                        edgeLabelPlacement: sf.EdgeLabelPlacement.shift,
                        interval:
                            10, // Adjusted interval for better readability
                        title: sf.AxisTitle(text: 'Time (s)')),

                    //Adjust Y Axis properties
                    primaryYAxis: const sf.NumericAxis(
                      axisLine: sf.AxisLine(width: 1),
                      majorTickLines: sf.MajorTickLines(size: 10),
                      title: sf.AxisTitle(text: 'IR (counts)'),
                    ),
                    series: <sf.FastLineSeries<RecordedData, double>>[
                      sf.FastLineSeries<RecordedData, double>(
                          name: 'IR (counts)',
                          dataSource: irSpots,
                          xValueMapper: (RecordedData data, _) =>
                              data.time / 1000,
                          yValueMapper: (RecordedData data, _) =>
                              data.ir.toDouble(),
                          enableTooltip: true,
                          color: Color.fromARGB(255, 70, 167, 173))
                    ])),
            const SizedBox(height: 10),
            Container(
                height: 150,
                child: sf.SfCartesianChart(
                    tooltipBehavior: _tooltipBehavior,
                    zoomPanBehavior: _redZoomPanBehavior,
                    primaryXAxis: const sf.NumericAxis(
                        majorGridLines: sf.MajorGridLines(width: 1),
                        edgeLabelPlacement: sf.EdgeLabelPlacement.shift,
                        interval:
                            10, // Adjusted interval for better readability
                        title: sf.AxisTitle(text: 'Time (s)')),

                    //Adjust Y Axis properties
                    primaryYAxis: const sf.NumericAxis(
                      axisLine: sf.AxisLine(width: 1),
                      majorTickLines: sf.MajorTickLines(size: 10),
                      title: sf.AxisTitle(text: 'Red (counts)'),
                    ),
                    series: <sf.FastLineSeries<RecordedData, double>>[
                      sf.FastLineSeries<RecordedData, double>(
                          name: 'Red (counts)',
                          dataSource: redSpots,
                          xValueMapper: (RecordedData data, _) =>
                              data.time / 1000,
                          yValueMapper: (RecordedData data, _) =>
                              data.red.toDouble(),
                          enableTooltip: true,
                          color: Color.fromARGB(255, 218, 55, 55))
                    ])),
            const SizedBox(height: 10),
            Container(
                height: 150,
                child: sf.SfCartesianChart(
                    tooltipBehavior: _tooltipBehavior,
                    zoomPanBehavior: _activityZoomPanBehavior,
                    primaryXAxis: const sf.NumericAxis(
                        majorGridLines: sf.MajorGridLines(width: 1),
                        edgeLabelPlacement: sf.EdgeLabelPlacement.shift,
                        interval:
                            10, // Adjusted interval for better readability
                        title: sf.AxisTitle(text: 'Time (s)')),

                    //Adjust Y Axis properties
                    primaryYAxis: const sf.NumericAxis(
                      axisLine: sf.AxisLine(width: 1),
                      majorTickLines: sf.MajorTickLines(size: 10),
                      title: sf.AxisTitle(text: 'Activity'),
                    ),
                    series: <sf.FastLineSeries<RecordedData, double>>[
                      sf.FastLineSeries<RecordedData, double>(
                          name: 'Activity',
                          dataSource: activitySpots,
                          xValueMapper: (RecordedData data, _) =>
                              data.time / 1000,
                          yValueMapper: (RecordedData data, _) =>
                              data.activity.toDouble(),
                          enableTooltip: true,
                          color: Color.fromARGB(255, 101, 91, 158))
                    ])),
          ],
        )));
  }
}

class RecordedData {
  final double time;
  final int ecg;
  final int ir;
  final int red;
  final int activity;

  RecordedData(this.time, this.ecg, this.ir, this.red, this.activity);
}
