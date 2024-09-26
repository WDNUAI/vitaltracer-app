import 'package:flutter/material.dart';

class DetailedViewScreen extends StatelessWidget {
  const DetailedViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed View'),
      ),

      //Add image to Page for now- Will need to create way to generate table from csv data
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Give Title above picture
          const Text(
            'ECG Data Session 2024-06-04',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          //Add Image - needs to be removed in future
          const SizedBox(
              height: 16), // Add space between the title and the image
          //Place Image in center of scrren
          Center(
            child: Image.asset('lib/images/ECGData.png'),
          ),

          //Create Title for Previous Sessions
          const SizedBox(height: 16),
          const Text(
            'Previous Sessions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          //Create another buttom below graph for older sessions
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              //When this is clicked. ECG Data from this session needs to populate a graph
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Session 2024-06-01',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
