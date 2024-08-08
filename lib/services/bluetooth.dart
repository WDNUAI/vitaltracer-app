import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as blc;
import 'package:permission_handler/permission_handler.dart';
import '../screens/ble-connections-screen.dart';


/// Searches for nearby BLE bluetooth devices.
/// Uses State<BluetoothConnectionsScreen> [screen] to tell the page to update
/// it's screen every time we find a new device while scanning.
Future<List<BluetoothDevice>> searchBle(State<BluetoothConnectionsScreen> screen) async {
  List<BluetoothDevice> devices = [];
  // Check if bluetooth is supported on this device.
  if (await FlutterBluePlus.isSupported == false) {
    log("Bluetooth not supported by this device");
    screen.setState(() {});
    return Future<List<BluetoothDevice>>.error(Exception("Bluetooth not supported"));
  }
  // Request to turn on bluetooth. (if it's already on nothing will happen)
  FlutterBluePlus.turnOn();

  if (!FlutterBluePlus.isScanningNow) {
    // For now, we don't provide any search criteria and
    // just search for any nearby BLE devices to test.
    await FlutterBluePlus.startScan(
        timeout: Duration(seconds: 15));
    // uncomment: withNames:["TBD_NAME_OF_VT"]
    // Eventually our search will be limited to VT devices.
  }
  // Listen to our scan results
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devices.contains(result.device)) {
          // Make sure our device is not null and for now ignore any devices
          // without a proper platform name.
          if (result.device.platformName.length > 1) {
            devices.add(result.device);
            // Call setState every time we add a new device to the list.
            screen.setState(() {});
          }
        }
      }
    });

  return devices;
}

/// Searches for nearby bluetooth classic devices.
/// Uses State<BluetoothConnectionsScreen> [screen] to tell the page to update
/// it's screen every time we find a new device while scanning.
Future<List<blc.BluetoothDevice>> searchBlc(State<BluetoothConnectionsScreen> screen) async {
  List<blc.BluetoothDevice> devices = [];
  await Permission.locationWhenInUse.request();
  if (await Permission.locationWhenInUse.isDenied){
    return Future<List<blc.BluetoothDevice>>.error(Exception("Bluetooth not supported"));
  }
  blc.FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      devices.add(r.device);
      screen.setState(() {});
  });
  return devices;
}
