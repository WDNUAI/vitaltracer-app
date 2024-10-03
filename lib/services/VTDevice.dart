

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


/// The VTDevice Class
/// All patch related communication is done here. This class is a singleton,
/// so one instance is shared across the entire app because only one patch should be
/// connected at a time.
class VTDevice {
  BluetoothConnection? connection_;
  String? macAddress_;
  String? name_;

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

  // Setup this class to be static, we want to be able to reference the patch currently in use
  // from anywhere in the application.
  static final VTDevice _singleton = VTDevice._internal();

  factory VTDevice() {
    return _singleton;
  }

  VTDevice._internal();


  Future<bool> sendMessage(String command) async {
    if (connection_ == null) {
      return false;
    }
    connection_!.output.add(utf8.encode(command + "\r\n"));
    await connection_!.output.allSent;
    return true;
  }

  void pair() async {
    // we must have setup a mac address to pair to.
    if (macAddress_ == null) {
      return;
    }
    log('here');
    try {
      connection_ = await BluetoothConnection.toAddress(macAddress_);
      log("Connected to the device");
      connection_?.input?.listen((data) {
        print('Data incoming: ' + data.toString());
      }).onDone(() {
        print('Disconnected!');
      });
      //connection.output.add(test);
    }
    catch (exception) {
      print(exception.toString());
      print('Cannot connect, exception occured');
    }
  }
}