import 'package:flutter/material.dart';
import 'hamburger.dart';

class BlueoothConnectionsScreen extends StatefulWidget {
  const BlueoothConnectionsScreen({super.key});

  @override
  State<BlueoothConnectionsScreen> createState() =>
      _BlueoothConnectionsScreenState();
}

class _BlueoothConnectionsScreenState extends State<BlueoothConnectionsScreen> {
  Widget build(BuildContext context) {
    return ScreenContent(context);
  }

  MaterialApp ScreenContent(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
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
          margin: EdgeInsets.only(bottom: 20, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Select a VT device:", style: TextStyle(fontSize: 30)),
                  Spacer(),
                  getDevices(context),
                  Spacer(),
                  // 'Search' Button
                  ElevatedButton(
                    onPressed: () {
                      /*TODO: Implement search functionality*/
                    },
                    child: Padding(
                        padding: EdgeInsets.all(20.0), child: Text("Search")),
                  ),
                ],
              )
            ],
          )),
    ));
  }

  /* TODO: Refactor getDevices() to implement functionality to display nearby avaliable vitaltracers. */
  Widget getDevices(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    List<Widget> cards = [
      Card(
          // clipBehavior is necessary because, without it, the InkWell's animation
          // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
          clipBehavior: Clip.hardEdge,
          child: InkWell(
              splashColor:
                  const Color.fromARGB(255, 199, 214, 226).withAlpha(30),
              onTap: () {
                // TODO: device pairing functionality
              },
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.1, vertical: height * .09),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('VT-Patch-0'),
                        Text('XX:XX:XX:XX:XX:XX'),
                      ],
                    ),
                  )
                ],
              ))),
    ];
    return Column(children: cards);
  }
}
