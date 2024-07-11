import 'package:flutter/material.dart';
import 'hamburger.dart';
import '../services/bluetooth.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothConnectionsScreen extends StatefulWidget {
  const BluetoothConnectionsScreen({super.key});

  @override
  State<BluetoothConnectionsScreen> createState() =>
      _BluetoothConnectionsScreenState();
}

class _BluetoothConnectionsScreenState
    extends State<BluetoothConnectionsScreen> {
  Future<List<BluetoothDevice>>? devices;
  int previousDeviceCount = 0;

  @override
  Widget build(BuildContext context) {
    return ScreenContent(context);
  }

  Scaffold ScreenContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vital Tracer Home'),
        //Create Hamburger Menu
        leading: Builder(
          builder: (context) => HamburgerMenu(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: HamburgerMenu(
        onPressed: () {},
        //When Icon is pressed, call Builddrawer() within hamburger class
      ).buildDrawer(context),
      body: Container(
          margin: const EdgeInsets.only(bottom: 20, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Select a VT device:",
                      style: TextStyle(fontSize: 30)),
                  const Spacer(),
                  SingleChildScrollView(
                    child: getDevices(context),
                  ),
                  const Spacer(),
                  // 'Search' Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        devices = searchBle(this);
                      });
                    },
                    child: const Padding(
                        padding: EdgeInsets.all(20.0), child: Text("Search")),
                  ),
                ],
              )
            ],
          )),
    );
  }

  /// Returns a list of Cards representing the discovered vitaltracer devices.
  /// TODO: Make this content scrollable.
  Widget getDevices(BuildContext context) {
    // Handle the current state of the devices list.
    return FutureBuilder(
        future: devices,
        builder:
            (BuildContext c, AsyncSnapshot<List<BluetoothDevice>> snapshot) {
          if (snapshot.data != null) {
            List<Widget> cards = [];
            // Create a list of cards that reflects the current state of our scan.
            for (int i = 0; i < snapshot.data!.length; i++) {
              cards.add(deviceCard(snapshot.data![i].platformName,
                  snapshot.data![i].remoteId.toString(), context));
            }
            return Column(children: cards);
          } else if (snapshot.hasError) {
            return Text(
                'An Error has occured while attempting to search for bluetooth devices.\nError: ${snapshot.error}');
          } else {
            return const Text('No devices found.');
          }
        });
  }
}

/// Returns a Card representing a discovered vitaltracer device.
/// Uses the [titleText] and [subHeading] to build the card.
Card deviceCard(String titleText, String subHeading, BuildContext context) {
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;
  return Card(
      // clipBehavior is necessary because, without it, the InkWell's animation
      // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
      clipBehavior: Clip.hardEdge,
      child: InkWell(
          splashColor: const Color.fromARGB(255, 199, 214, 226).withAlpha(30),
          onTap: () {
            // TODO: device pairing functionality
          },
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.2, vertical: height * .03),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titleText),
                    Text(subHeading),
                  ],
                ),
              )
            ],
          )));
}
