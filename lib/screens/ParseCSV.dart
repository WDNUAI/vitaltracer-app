import 'package:csv/csv.dart' as csv;
import 'package:flutter/services.dart' show rootBundle;
import 'package:fl_chart/fl_chart.dart';

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
  static List<FlSpot> _generateDataPoints(List<List<String>> data, int column) {
    //parse time and indicated column ( 1 = ECG , 2 = IR)
    List<FlSpot> spots = [];
    for (var row in data.skip(20)) {
      try {
        double xValue = double.parse(row[0]);
        double yValue = double.parse(row[column]);
        spots.add(FlSpot(xValue, yValue));
      } catch (e) {
        print('Error parsing row: $row');
        print('Error: $e');
      }
    }
    return spots;
  }

  // Combine reading and parsing the CSV data into FlSpot objects
  static Future<List<FlSpot>> getSpotsFromCSV(int column) async {
    List<List<String>> data = await getDataFromCSV();
    return _generateDataPoints(data, column);
  }
}
