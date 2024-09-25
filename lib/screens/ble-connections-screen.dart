import 'dart:async'; // Import for asynchronous programming.
import 'package:flutter/material.dart'; // Import for Flutter material widgets.
import 'package:flutter_blue_plus/flutter_blue_plus.dart'; // Import for Flutter Bluetooth library.
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import for screen utility package for responsive UI.
import '../services/bluetooth_service.dart'; // Import custom Bluetooth service.
import 'hamburger.dart'; // Import custom hamburger menu.

class BluetoothConnectionsScreen extends StatefulWidget {
  const BluetoothConnectionsScreen({Key? key}) : super(key: key);

  @override
  State<BluetoothConnectionsScreen> createState() =>
      _BluetoothConnectionsScreenState();
}

class _BluetoothConnectionsScreenState
    extends State<BluetoothConnectionsScreen> {
  Future<List<BluetoothDevice>>?
      devices; // Future holding the list of discovered devices.
  StreamSubscription<BluetoothConnectionState>?
      _connectionStateSubscription; // Subscription for connection state changes.
  BluetoothDevice? selectedDevice; // Currently selected Bluetooth device.

  @override
  void initState() {
    super.initState();
    _initializeBluetoothService(); // Initialize Bluetooth service callbacks.
    _startBleScan(); // Start scanning for BLE devices.
  }

  // Initialize Bluetooth service and set up callbacks.
  void _initializeBluetoothService() {
    // Callback for connection state changes.
    VTBluetoothService.onConnectionChanged = (state) {
      setState(() {
        if (state == BluetoothConnectionState.disconnected) {
          VTBluetoothService.connectedDevice = null;
          selectedDevice = null;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Device disconnected')));
        }
      });
    };

    // Callback for data received from the device.
    VTBluetoothService.onDataReceived = (data) {
      // Handle data received from the device
      print("Data received: $data");
    };

    // Callback for handling errors.
    VTBluetoothService.onError = (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${error.toString()}')));
    };
  }

  // Start scanning for BLE devices.
  void _startBleScan() {
    devices = VTBluetoothService.searchBle(); // Initiate BLE scan.
    devices?.then((_) {
      setState(() {}); // Update UI after scan results are available.
    });
  }

  @override
  void dispose() {
    VTBluetoothService.dispose(); // Dispose of the Bluetooth service.
    _connectionStateSubscription
        ?.cancel(); // Cancel connection state subscription.
    super.dispose();
  }

  // Connect to a Bluetooth device.
  void _connectToDevice(BuildContext context, BluetoothDevice device) async {
    if (VTBluetoothService.connectedDevice == device) {
      // Double click detected, disconnect device.
      await _disconnectDevice(context);
    } else {
      try {
        // Attempt to connect to the device.
        bool connected = await VTBluetoothService.connectToDevice(device);
        if (!connected) {
          // If initial connection fails, reset Bluetooth and try again.
          connected = await VTBluetoothService.connectToDevice(device);
        }

        if (connected) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Connected successfully')));
          setState(() {
            selectedDevice = device; // Update selected device.
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Connection failed after multiple attempts')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error during connection: $e')));
      }
      setState(() {});
    }
  }

  // Disconnect the currently connected Bluetooth device.
  Future<void> _disconnectDevice(BuildContext context) async {
    await VTBluetoothService.disconnectDevice(); // Disconnect device.
    setState(() {
      selectedDevice = null; // Clear selected device.
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Device disconnected')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vital Tracer Home'),
        leading: Builder(
          // Create Hamburger Menu
          builder: (context) => HamburgerMenu(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: HamburgerMenu(
        onPressed: () {},
        // When Icon is pressed, call buildDrawer() within Hamburger class
      ).buildDrawer(context),
      body: Container(
        margin: EdgeInsets.only(bottom: 20.h, top: 20.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Select a VT device:", style: TextStyle(fontSize: 30.sp)),
                Spacer(),
                SingleChildScrollView(
                  child: getDevices(context), // Display list of devices.
                ),
                Spacer(),
                // 'Search' Button
                ElevatedButton(
                  onPressed: () {
                    _startBleScan(); // Restart BLE scan on button press.
                  },
                  child: Padding(
                    padding: EdgeInsets.all(20.0.w),
                    child: Text("Search"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Returns a list of Cards representing the discovered vital tracer devices.
  Widget getDevices(BuildContext context) {
    // Handle the current state of the devices list.
    return FutureBuilder<List<BluetoothDevice>>(
      future: devices,
      builder: (BuildContext context,
          AsyncSnapshot<List<BluetoothDevice>> snapshot) {
        if (snapshot.hasData) {
          List<Widget> cards = [];
          // If a device is connected, show the connected device card.
          if (VTBluetoothService.connectedDevice != null) {
            cards.add(connectedDeviceCard(
                VTBluetoothService.connectedDevice!, context));
          } else {
            // Otherwise, show the list of discovered devices.
            for (var device in snapshot.data!) {
              cards.add(deviceCard(device.platformName ?? "Unknown",
                  device.remoteId.toString(), context, device));
            }
          }
          return Column(children: cards);
        } else if (snapshot.hasError) {
          return Text(
              'An Error has occurred while attempting to search for bluetooth devices.\nError: ${snapshot.error}');
        } else {
          return Text('No devices found.');
        }
      },
    );
  }

  // Widget for displaying the connected device card.
  Widget connectedDeviceCard(BluetoothDevice device, BuildContext context) {
    return Card(
      color: Colors.green[100],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: InkWell(
          onTap: () {
            _connectToDevice(context, device); // Connect or disconnect on tap.
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Connected: ${device.platformName}",
                style: TextStyle(fontSize: 14.sp),
              ),
              Text(
                "ID: ${device.remoteId}",
                style: TextStyle(fontSize: 12.sp),
              ),
              Text(
                "Tap twice to disconnect",
                style: TextStyle(fontSize: 12.sp, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns a Card representing a discovered vitaltracer device.
  /// Uses the [titleText] and [subHeading] to build the card.
  Widget deviceCard(String titleText, String subHeading, BuildContext context,
      BluetoothDevice device) {
    return Card(
      // clipBehavior is necessary because, without it, the InkWell's animation
      // will extend beyond the rounded edges of the Card (see https://github.com/flutter/flutter/issues/109776)
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: const Color.fromARGB(255, 199, 214, 226).withAlpha(30),
        onTap: () {
          _connectToDevice(context, device); // Connect to device on tap.
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titleText, style: TextStyle(fontSize: 14.sp)),
                  Text(subHeading, style: TextStyle(fontSize: 12.sp)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
