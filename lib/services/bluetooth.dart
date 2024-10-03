import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import '../screens/bluetooth-connections-screen.dart';


/// Searches for nearby bluetooth classic devices.
/// Uses State<BluetoothConnectionsScreen> [screen] to tell the page to update
/// it's screen every time we find a new device while scanning.
Future<List<BluetoothDevice>> search(State<ClassicConnectionsScreen> screen) async {
  List<BluetoothDevice> devices = [];
  await Permission.locationWhenInUse.request();
  if (await Permission.locationWhenInUse.isDenied){
    return Future<List<BluetoothDevice>>.error(Exception("Bluetooth not supported"));
  }
  FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
    log("found device.");
    devices.add(r.device);
    screen.setState(() {});
  });
  return devices;
}