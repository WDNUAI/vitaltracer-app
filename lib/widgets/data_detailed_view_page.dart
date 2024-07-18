import 'package:flutter/material.dart';

class DataDetailedViewPage extends StatelessWidget {
  final String datatypeTitle;
  final String dataGraph;

  const DataDetailedViewPage(
      {super.key, required this.datatypeTitle, required this.dataGraph});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(datatypeTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Hourly'),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Daily'),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Weekly'),
                ),
              ],
            ),
            Center(
              child: Image.asset(dataGraph),
            ),
          ],
        ),
      ),
    );
  }
}
