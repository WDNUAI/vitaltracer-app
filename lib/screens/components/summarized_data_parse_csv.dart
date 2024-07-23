import 'package:csv/csv.dart' as csv;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

class SummarizedDataParseCsv {
  //Read CSV file from assets
  static Future<List<List<String>>> parseSummarizedDataCSV() async {
    String summarizedData =
        await rootBundle.loadString('lib/Data/R-2024-05-18-14_15_13.csv');

    // Parse CSV data
    List<List<dynamic>> csvFileList =
        csv.CsvToListConverter().convert(summarizedData);
    List<List<String>> dataCSV = csvFileList
        .map((row) => row.map((cell) => cell.toString()).toList())
        .toList();
    return dataCSV;
  }

  static Future<Map<String, String>> getTemperatureAndDateFromCSV() async {
    List<List<String>> dataCSVTable = await parseSummarizedDataCSV();
    String date = "_";
    String time = "_";
    String temperature = "_";
    String bloodPressure = "_";

    int found = 0;

    for (var row in dataCSVTable) {
      print('Processing row: $row');
      if (row.isNotEmpty) {
        if (row[0] == 'Date') {
          date = row[1];
          found++;
        } else if (row[0] == 'Time') {
          time = row[1];
          found++;
        } else if (row[0] == 'Temperature') {
          temperature = row[1];
          found++;
        } else if (row[0] == 'SYS pressure') {
          bloodPressure = row[1];
          found++;
        }

        if (found == 4) {
          break;
        }
      }
    }

    return {
      'time': time,
      'date': date,
      'temperature': temperature,
      'bloodPressure': bloodPressure,
    };
  }
}
