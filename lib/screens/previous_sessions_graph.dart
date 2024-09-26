import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as sf;
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'ParseCsv.dart';

class PreviousSessionsGraph extends StatefulWidget {
  const PreviousSessionsGraph({Key? key}) : super(key: key);

  @override
  _PreviousSessionsGraph createState() => _PreviousSessionsGraph();
}

class _PreviousSessionsGraph extends State<PreviousSessionsGraph> {
  List<RecordedData> ecgSpots = [];
  //List<RecordedData> irSpots = [];
  //double xScaleFactor = 1000.0; // Scale factor to convert ms to seconds
  late sf.TooltipBehavior _tooltipBehavior = sf.TooltipBehavior(enable: true);
  late sf.ZoomPanBehavior _zoomPanBehavior = sf.ZoomPanBehavior(
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
    //List<FlSpot> irSpot =await ParseCSV.getSpotsFromCSV(2); // Column 2 is for IR

    //setState(() {
    ecgSpots =
        ecgSpot.map((spot) => RecordedData(spot.x, spot.y.toInt())).toList();

    //});
  }

  void _resetZoom() {
    _zoomPanBehavior.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Previous Sessions Graph"),
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
            //const SizedBox(height: 50),
            Container(
                height: 400,
                child: sf.SfCartesianChart(
                    tooltipBehavior: _tooltipBehavior,
                    zoomPanBehavior: _zoomPanBehavior,
                    primaryXAxis: const sf.NumericAxis(
                        majorGridLines: sf.MajorGridLines(width: 1),
                        edgeLabelPlacement: sf.EdgeLabelPlacement.shift,
                        interval: 1, // Adjusted interval for better readability
                        title: sf.AxisTitle(text: 'Time (ms)')),

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
                          xValueMapper: (RecordedData data, _) => data.time,
                          yValueMapper: (RecordedData data, _) =>
                              data.ecg.toDouble(),
                          enableTooltip: true)
                    ])),
          ],
        )));
  }
}

class RecordedData {
  final double time;
  final int ecg;

  RecordedData(this.time, this.ecg);
}
