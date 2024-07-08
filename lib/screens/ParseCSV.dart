import 'package:csv/csv.dart' as csv;
import 'package:flutter/services.dart' show rootBundle;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

//https://pub.dev/documentation/csv/latest/csv/CsvToListConverter-class.html   Methods
//https://pub.dev/packages/csv      Usage of csv import

//resource for exporting file collected and creating csv from data read from session: https://stackoverflow.com/questions/65472270/how-to-create-and-export-csv-file-in-flutter

class ParseCSV {
  // Read CSV file from Folder - In future after a connection is made to a patch, we need to store the CSV file in Data folder and dynamically search for it before below statement
  static Future<List<List<String>>> getDataFromCSV() async {
    // Read CSV file from assets
    String csvData =
        await rootBundle.loadString('lib/Data/R-2024-05-18-14_15_13.csv');

    // Parse CSV data - Below method in link mentioned above. convert data into a list of Lists.
    List<List<dynamic>> csvTable = csv.CsvToListConverter().convert(csvData);
    List<List<String>> data = csvTable
        .map((row) => row.map((cell) => cell.toString()).toList())
        .toList();

    return data;
  }

  // First column is time.  Will need to create distinct methods for each stream of data ( time vs IR counts  &&  time vs RedCounts  && time vs Activty?)
  static List<FlSpot> _generateDataPoints(List<List<String>> data) {
    return data
        .skip(
            20) // Skip first 20 rows to get to data. Not sure how this will look when data is flowing in dynamically
        .map((row) => FlSpot(
              double.parse(row[0]), // Parse time
              double.parse(row[1]), // Parse IR Counts
            ))
        .toList();
  }

  // Combine reading and parsing the CSV data into FlSpot objects
  static Future<List<FlSpot>> getSpotsFromCSV() async {
    List<List<String>> data = await getDataFromCSV();
    return _generateDataPoints(data);
  }
}

class LineChartWidget extends StatelessWidget {
  final Future<List<FlSpot>> spotsFuture;

  LineChartWidget({required this.spotsFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FlSpot>>(
      future: spotsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Error message
        } else if (snapshot.hasData) {
          return LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: snapshot.data!, // Use the loaded data
                ),
              ],
            ),
          );
        } else {
          return Text('No data'); // No data message
        }
      },
    );
  }
}
