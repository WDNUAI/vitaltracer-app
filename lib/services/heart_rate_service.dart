import 'dart:async';
import '../services/bluetooth_service.dart';

/// A class that calculates heart rate from ECG data.
class HeartRateCalculator {
  /// Stores the ECG data points for plotting.
  static List<LiveData> ecgChartData = [];

  /// Subscription to the ECG data stream.
  static StreamSubscription<List<int>>? ecgSubscription;

  /// The start time of the ECG recording.
  static double startTime = 0;

  /// Scale factor for the x-axis (time axis) of the ECG plot.
  static double xScaleFactor = 250.0;

  /// Maximum number of data points to keep in memory.
  static int maxDataPoints = 1000;

  /// The current calculated heart rate.
  static int _currentHeartRate = 0;

  /// Getter for the current heart rate.
  static int get currentHeartRate => _currentHeartRate;

  /// Starts the heart rate calculation process.
  static void startCalculation() {
    startTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
    ecgSubscription = VTBluetoothService.ecgStream.listen(_addEcgData);
  }

  /// Stops the heart rate calculation process.
  static void stopCalculation() {
    ecgSubscription?.cancel();
  }

  /// Processes incoming ECG data.
  ///
  /// This method is called for each chunk of ECG data received from the Bluetooth service.
  static void _addEcgData(List<int> ecgData) {
    final currentTime = DateTime.now().millisecondsSinceEpoch / 1000.0;
    for (int i = 0; i < ecgData.length; i += 2) {
      // Combine two bytes into a single ECG value
      int value = (ecgData[i + 1] << 8) | ecgData[i];
      double time = currentTime - startTime + (i / 2) / xScaleFactor;
      ecgChartData.add(LiveData(time, value));
    }

    // Maintain a maximum number of data points
    while (ecgChartData.length > maxDataPoints) {
      ecgChartData.removeAt(0);
    }

    // Calculate the current heart rate
    _currentHeartRate = _calculateHeartRate();
  }

  /// Calculates the heart rate based on the last second of ECG data.
  ///
  /// This method counts the number of peaks in the ECG data that exceed a certain threshold.
  /// The heart rate is then calculated by multiplying the number of peaks by 60 (to get beats per minute).
  static int _calculateHeartRate() {
    if (ecgChartData.length < 500) return 0;

    // Get the last second of data (assuming 250 Hz sampling rate)
    List<double> lastSecondData = ecgChartData
        .sublist(ecgChartData.length - 250)
        .map((e) => e.ecg.toDouble())
        .toList();

    int peakCount = 0;
    for (int i = 1; i < lastSecondData.length - 1; i++) {
      // Check if this point is a peak (higher than both neighbors) and exceeds the threshold
      if (lastSecondData[i] > lastSecondData[i - 1] &&
          lastSecondData[i] > lastSecondData[i + 1] &&
          lastSecondData[i] > 200) {
        peakCount++;
      }
    }
    
    // Convert peak count to beats per minute
    return peakCount * 60;
  }
}

/// A class representing a single data point in the ECG chart.
class LiveData {
  /// The time of this data point, in seconds since the start of recording.
  final double time;

  /// The ECG value at this time point.
  final int ecg;

  /// Constructs a LiveData object.
  ///
  /// [time] is the time of the data point in seconds.
  /// [ecg] is the ECG value at that time.
  LiveData(this.time, this.ecg);
}