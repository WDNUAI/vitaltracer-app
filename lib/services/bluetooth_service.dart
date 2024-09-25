import 'dart:async'; // Import for asynchronous programming.
import 'dart:developer'; // Import for logging.
import 'package:flutter_blue_plus/flutter_blue_plus.dart'; // Import for Flutter Bluetooth library.


typedef BluetoothConnectionCallback = void Function(
    BluetoothConnectionState state);
typedef BluetoothDataCallback = void Function(List<int> data);
typedef BluetoothErrorCallback = void Function(Exception error);

class VTBluetoothService {
  // The connected Bluetooth device.
  static BluetoothDevice? connectedDevice;

  // Current temperature data.
  static double? currentTemperature;

  // Current ECG data.
  static List<int>? currentEcgData;
    static List<int>? currentActivityData;

  // UUID for temperature service.
  static const String TEMPERATURE_SERVICE_UUID = "1804";

  // UUID for temperature characteristic.
  static const String TEMPERATURE_CHARACTERISTIC_UUID = "2A1E";

  // UUID for ECG service.
  static const String ECG_SERVICE_UUID = "181D";

  // UUID for ECG characteristic.
  static const String ECG_CHARACTERISTIC_UUID = "2A37";

  // UUID for Activity service.
static const String ACTIVITY_SERVICE_UUID = "1809"; 

// UUID for Activity characteristic.
static const String ACTIVITY_CHARACTERISTIC_UUID = "2A1C"; 




  // StreamController for connection state changes, broadcasting the state to multiple listeners.
  static final StreamController<BluetoothConnectionState>
      _connectionStateController =
      StreamController<BluetoothConnectionState>.broadcast();

  // Stream for connection state changes.
  static Stream<BluetoothConnectionState> get connectionStateStream =>
      _connectionStateController.stream;

  // Subscription for scan results.
  static StreamSubscription<List<ScanResult>>? _scanSubscription;

  // Subscription for connection state changes.
  static StreamSubscription<BluetoothConnectionState>?
      _connectionStateSubscription;

      // StreamController for activity data, broadcasting the data to multiple listeners.
static final StreamController<List<int>> _activityController =
    StreamController<List<int>>.broadcast();

// Stream for activity data.
static Stream<List<int>> get activityStream => _activityController.stream;


  // Timer for reconnect attempts.
  static Timer? _reconnectTimer;

  // StreamController for temperature data, broadcasting the data to multiple listeners.
  static final StreamController<double> _temperatureController =
      StreamController<double>.broadcast();

  // Stream for temperature data.
  static Stream<double> get temperatureStream => _temperatureController.stream;

  // StreamController for ECG data, broadcasting the data to multiple listeners.
  static final StreamController<List<int>> _ecgController =
      StreamController<List<int>>.broadcast();

  // Stream for ECG data.
  static Stream<List<int>> get ecgStream => _ecgController.stream;

  // Callbacks for connection changes, data reception, and errors.
  static BluetoothConnectionCallback? onConnectionChanged;
  static BluetoothDataCallback? onDataReceived;
  static BluetoothErrorCallback? onError;

  // Search for BLE devices.
  static Future<List<BluetoothDevice>> searchBle() async {
    List<BluetoothDevice> devices = [];

    // Check if Bluetooth is supported on the device.
    if (await FlutterBluePlus.isSupported == false) {
      _handleError(Exception("Bluetooth not supported"));
      return Future<List<BluetoothDevice>>.error(
          Exception("Bluetooth not supported"));
    }

    // Turn on Bluetooth if it's off.
    await FlutterBluePlus.turnOn();

    // Start scanning if not already scanning.
    if (!FlutterBluePlus.isScanningNow) {
      await FlutterBluePlus.startScan(timeout: Duration(seconds: 15));
    }

    // Listen for scan results.
    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        // Add the device to the list if it's not already in and has a name.
        if (!devices.contains(result.device) && result.device.name.isNotEmpty) {
          devices.add(result.device);
        }
      }
    });

    return devices;
  }

  // Connect to a specified Bluetooth device.
  static Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      // Attempt to connect to the device with a 10-second timeout.
      await device.connect(timeout: Duration(seconds: 10), autoConnect: false);

      // Set the connected device.
      connectedDevice = device;

      // Start listening for data from the device.
      _startListeningForData(device);

      // Setup the connection state listener.
      _setupConnectionStateListener(device);

      // Invoke the connection changed callback with the connected state.
      onConnectionChanged?.call(BluetoothConnectionState.connected);
      return true;
    } catch (e) {
      // Handle connection error and cleanup connection.
      _handleError(Exception("Error connecting to device: $e"));
      _cleanupConnection();
      return false;
    }
  }

  // Disconnect the currently connected device.
  static Future<void> disconnectDevice() async {
    if (connectedDevice != null) {
      try {
        // Attempt to disconnect the device.
        await connectedDevice!.disconnect();

        // Invoke the connection changed callback with the disconnected state.
        onConnectionChanged?.call(BluetoothConnectionState.disconnected);
      } catch (e) {
        // Handle disconnection error.
        _handleError(Exception("Error disconnecting from device: $e"));
      }
    }
    // Cleanup the connection.
    _cleanupConnection();
  }

  // Setup listener for connection state changes.
  static void _setupConnectionStateListener(BluetoothDevice device) {
    // Cancel any existing subscription.
    _connectionStateSubscription?.cancel();

    // Listen for connection state changes.
    _connectionStateSubscription =
        device.connectionState.listen((BluetoothConnectionState state) {
      // Invoke the connection changed callback with the new state.
      onConnectionChanged?.call(state);

      // If the device is disconnected, cleanup the connection.
      if (state == BluetoothConnectionState.disconnected) {
        _cleanupConnection();
      }
    });
  }

  // Cleanup the connection state and subscriptions.
  static void _cleanupConnection() {
    connectedDevice = null;
    currentTemperature = null;
    currentEcgData = null;
    currentActivityData=null;
    _connectionStateSubscription?.cancel();
    _reconnectTimer?.cancel();
  }

  // Start listening for data from the connected device.
  static void _startListeningForData(BluetoothDevice device) async {
    try {
      // Discover services offered by the device.
      List<BluetoothService> services = await device.discoverServices();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          try {
            // Enable notifications for the characteristic.
            await characteristic.setNotifyValue(true);
            characteristic.value.listen((value) {
              // Invoke the data received callback with the new value.
              onDataReceived?.call(value);

              // Process the characteristic value.
              _processCharacteristicValue(
                  characteristic.uuid.toString().toLowerCase(), value);
            });
          } catch (e) {
            // Handle error enabling notifications.
            _handleError(Exception(
                'Failed to set notification for characteristic ${characteristic.uuid}: $e'));
          }
        }
      }
    } catch (e) {
      // Handle error discovering services.
      _handleError(Exception("Error discovering services: $e"));
    }
  }

  // Process received characteristic value based on UUID.
  static void _processCharacteristicValue(String uuid, List<int> value) {
    // Check if the UUID matches the temperature characteristic.
    if (uuid.endsWith(TEMPERATURE_CHARACTERISTIC_UUID.toLowerCase())) {
      // Parse and update the temperature value.
      currentTemperature = _parseTemperature(value);
      _temperatureController.add(currentTemperature!);
      log('Temperature received: $currentTemperature');
    }
    // Check if the UUID matches the ECG characteristic.
    else if (uuid.endsWith(ECG_CHARACTERISTIC_UUID.toLowerCase())) {
      // Update the ECG data.
      currentEcgData = value;
      _ecgController.add(currentEcgData!);
      log('ECG data received: $currentEcgData');
    }else if (uuid.endsWith(ACTIVITY_CHARACTERISTIC_UUID.toLowerCase())) {
    currentActivityData = value;
    _activityController.add(value);
    log('Activity data received: $value');
    
  }
  }

  // Parse temperature value from characteristic.
  static double _parseTemperature(List<int> value) {
    // Ensure the value has at least 2 bytes.
    if (value.length < 2) return 0;

    // Combine the bytes to form the integer value and divide by 100.
    int tempInteger = (value[1] << 8) | value[0];
    return tempInteger / 100.0;
  }

  // Handle errors and invoke the error callback.
  static void _handleError(Exception error) {
    // Invoke the error callback with the error.
    onError?.call(error);

    // Log the error.
    log('Error: $error');
  }

  // Dispose of controllers and subscriptions.
  static void dispose() {
    connectedDevice = null;
    currentTemperature = null;
    currentEcgData = null;
   currentActivityData=null; 
    _connectionStateSubscription?.cancel();
    _reconnectTimer?.cancel();
    _scanSubscription?.cancel();
    _temperatureController.close();
    _ecgController.close();
    _activityController.close(); 
    _connectionStateController.close();
  }
}
