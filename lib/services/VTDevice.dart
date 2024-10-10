

import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


/// Class to represent the relevant information about the patch.
/// TODO: Eventually I think we should have every relevant piece of data
/// TODO: accessible in this class (i.e ECG, PPG, etc)
/// TODO: but for now the data is just list of ints.
class VTResponse {
  Uint8List data = Uint8List(0);
  Timestamp timestamp = Timestamp.now();
}

const DEFAULT_INTERVAL = 1;
const String GET_DATA = "@h#";


/// The VTDevice Class
/// All patch related communication is done here. This class is a singleton,
/// so one instance is shared across the entire app because only one patch should be
/// connected at a time.
class VTDevice {
  // the connection status of the patch wrapped in a ValueNotifier. This allows
  // us to attach event listeners to this variable and update the UI accordingly
  ValueNotifier<BluetoothConnection?> connection_ = ValueNotifier<BluetoothConnection?>(null);

  String? macAddress_;
  String? name_;
  bool isRecording = false;

  // the current recording interval in seconds
  int interval_ = DEFAULT_INTERVAL;
  // the most recent response from the patch.
  VTResponse? response;

  // temporary StreamController for ECG demo
  StreamController<List<int>> controller = StreamController<List<int>>.broadcast();

  VTDevice._privateConstructor();
  // Setup this class to be static, we want to be able to reference the patch currently in use
  // from anywhere in the application.
  static final VTDevice _instance = VTDevice._privateConstructor();

  factory VTDevice() {
    return _instance;
  }

  // Getters and setters
  setMacAddress(String? macAddr) {
    this.macAddress_ = macAddr;
  }

  setName(String name) {
    this.name_ = name;
  }

  String? getName() {
    if (name_ == null) {
      return "";
    }
    return name_;
  }

  int getInterval() {
    return interval_;
  }

  // Returns the status of the connection.
  bool isConnected() {
    // idk if there's a better way to do this in flutter.
    if (connection_.value != null) {
      if (connection_.value?.isConnected == false) {
        return false;
      } else if (connection_.value?.isConnected == true) {
        return true;
      }
    }
    // connection or .isConnected is null
    return false;
  }


  // Attaches an event listener to the connection variable.
  void onConnectionStatusChange(void Function() listener) {
    connection_.addListener(listener);
  }

  // Attempts to send a message to the patch.
  Future<bool> sendMessage(String command) async {
    if (connection_ == null) {
      return false;
    }
    print("Sending message: " + command);
    connection_.value!.output.add(utf8.encode(command + "\r\n"));
    await connection_.value!.output.allSent;
    return true;
  }

  // Attempt to pair to the specified mac address.
  void pair() async {
    // we must have setup a mac address to pair to.
    if (macAddress_ == null || name_ == null) {
      print("Attempted to pair without assigning values to macAddress and name!");
      return;
    }
    try {
      connection_.value = await BluetoothConnection.toAddress(macAddress_);
      print("Connected to the device");
    }
    catch (exception) {
      print(exception.toString());
      print('Cannot connect, exception occured');
    }
    // Setup our event handlers for when we receive data from the patch
    _HandleConnection();
  }

  // Deals with sending/receiving data from the patch
  void _HandleConnection() {
    // Handle receiving data from the patch.
    connection_.value?.input?.listen((data) async {
      print('Data incoming: ' + data.toString());
      controller.add([data[3]]);
      // initialize our response data
      response?.data = data;
      response?.timestamp = Timestamp.now();
      if (isRecording) {
        await Future.delayed(Duration(seconds: VTDevice().getInterval()), (){
          sendMessage(GET_DATA);
        });
      }

    }).onDone(() {
      // We've disconnected from the patch. (either we've disconnected or the
      // patch has disconnected.)
      print('Disconnected!');
      close();
    });
  }

  void startRecording() {
    isRecording = true;
    sendMessage("@h#");
  }

  void stopRecording() {
    isRecording = false;
  }

  // Closes the connection
  void close() {
    if (connection_.value != null) {
      connection_.value?.close();
      connection_.value?.dispose();
      macAddress_ = null;
      name_ = null;
      isRecording = false;

    }

  }

}


