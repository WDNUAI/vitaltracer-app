import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

/// A class that manages a rolling file system for storing health data.
class RollingFileSystem {
  /// Prefix for all health data files.
  static const String FILE_PREFIX = 'health_datasession';
  /// File extension for health data files.
  static const String FILE_EXTENSION = '.csv';

  late Directory _directory;
  File? _currentFile;
  DateTime? _sessionStartTime;
  int _sessionCounter = 0;
  double? _lastTemperature;
  int? _lastStepCount;
  int? _lastSpO2;

  RollingFileSystem();

  /// Initializes the file system and retrieves the latest session number.
  Future<void> initialize() async {
    _directory = await getApplicationDocumentsDirectory();
    _sessionCounter = await _getLatestSessionNumber();
    print("Initialized RollingFileSystem. Latest session number: $_sessionCounter");
  }

  /// Retrieves the latest session number from existing files.
  Future<int> _getLatestSessionNumber() async {
    List<FileSystemEntity> files = _directory.listSync();
    int latestSession = 0;
    for (var file in files) {
      if (file is File && file.path.contains(FILE_PREFIX)) {
        String fileName = file.path.split('/').last;
        int? sessionNumber = int.tryParse(fileName.split('')[3].split('.')[0]);
        if (sessionNumber != null && sessionNumber > latestSession) {
          latestSession = sessionNumber;
        }
      }
    }
    return latestSession;
  }

  /// Starts a new data recording session.
  Future<void> startNewSession() async {
    _sessionStartTime = DateTime.now();
    _sessionCounter++;
    await _createNewSessionFile();
    print("New session $_sessionCounter started at $_sessionStartTime");
  }

  /// Ends the current data recording session.
  Future<void> endSession() async {
    if (_currentFile != null) {
      print("Ending session $_sessionCounter");
      await _currentFile!.writeAsString('\nSession ended: ${DateTime.now()}', mode: FileMode.append);
    }
    _currentFile = null;
    _sessionStartTime = null;
    print("Session ended");
  }

  /// Creates a new file for the current session.
  Future<void> _createNewSessionFile() async {
    String fileName = _getFileNameForSession(_sessionStartTime!);
    _currentFile = File('${_directory.path}/$fileName');

    try {
      await _currentFile!.create();
      await _writeHeader(_currentFile!);
      print("New file created: ${_currentFile!.path}");
    } catch (e) {
      print("Error creating new session file: $e");
    }
  }

  /// Generates a filename for the current session.
  String _getFileNameForSession(DateTime sessionStart) {
    // Format the date as: yyyy-MM-dd-HH_mm_ss
    String formattedDate = DateFormat('yyyy-MM-dd-HH_mm_ss').format(sessionStart);
    return 'health_datasession${formattedDate}.csv';
  }

  /// Appends health data to the current session file.
  Future<void> appendData({
    required DateTime timestamp,
    double? temperature,
    List<int>? ecgData,
    int? stepCount,
    int? spO2Data,
  }) async {
    try {
      if (_currentFile == null || _sessionStartTime == null) {
        throw Exception("No active session. Call startNewSession() first.");
      }

      // Update last known values if new data is available
      _lastTemperature = temperature ?? _lastTemperature;
      _lastStepCount = stepCount ?? _lastStepCount;
      _lastSpO2 = spO2Data ?? _lastSpO2;

      String csvLine = _convertToCsvLine(
        timestamp, 
        _lastTemperature, 
        ecgData, 
        _lastStepCount, 
        _lastSpO2
      );
      print("Appending data: $csvLine");

      await _currentFile!.writeAsString('$csvLine\n', mode: FileMode.append);
      print("Data appended successfully to ${_currentFile!.path}");
    } catch (e) {
      print("Error appending data: $e");
    }
  }

  /// Converts health data to a CSV line format.
  String _convertToCsvLine(DateTime timestamp, double? temperature, List<int>? ecgData, int? stepCount, int? spO2Data) {
    String formattedTimestamp = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(timestamp);
    String ecgValue = ecgData != null && ecgData.isNotEmpty ? ecgData[0].toString() : '';
    return '$formattedTimestamp,$temperature,$ecgValue,$stepCount,$spO2Data';
  }

  /// Retrieves recent health data files.
  Future<List<File>> getRecentFiles({int days = 1}) async {
    List<File> recentFiles = [];
    List<FileSystemEntity> entities = _directory.listSync();

    for (var entity in entities) {
      if (entity is File && entity.path.contains(FILE_PREFIX)) {
        recentFiles.add(entity);
      }
    }

    recentFiles.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    print("Found ${recentFiles.length} files");
    return recentFiles;
  }

  /// Extracts the date from a filename.
  DateTime? _getDateFromFileName(String filePath) {
    try {
      String fileName = filePath.split('/').last;  // Extract only the filename

      String dateString = fileName.replaceAll('health_datasession', '').replaceAll('.csv', '');

      return DateFormat('yyyy-MM-dd-HH_mm_ss').parse(dateString);
    } catch (e) {
      print("Error parsing date from filename: $e");
      return null;
    }
  }

  /// Writes the header information to a new session file.
  Future<void> _writeHeader(File file) async {
    String header = '''File Type,real-time,,
File version,1,,
User ID,${await _getUserId()},,
Date,${DateFormat('dd/MM/yyyy').format(_sessionStartTime!)},,
Time,${DateFormat('HH:mm:ss').format(_sessionStartTime!)},,
Position of sensor,Back,,
User state,Walking,,
Sample Rate,250,,
Firmware version,1,,
Device serial number,${await _getDeviceSerialNumber()},,
,,,
Timestamp,Temperature (°C),ECG (uv),Step Count,spO2 
''';
    await file.writeAsString(header);
  }

  /// Retrieves the user ID (placeholder implementation).
  Future<String> _getUserId() async {
    return '050';  // replace with actual user ID retrieval
  }

  /// Retrieves the device serial number (placeholder implementation).
  Future<String> _getDeviceSerialNumber() async {
    return '00-00-00-00-00-00-e8-9f-6d-25-6f-6a';  // replace with actual device serial number retrieval
  }
}