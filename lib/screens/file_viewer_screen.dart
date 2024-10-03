import 'dart:io';
import 'package:flutter/material.dart';

/// A screen that displays the contents of a file.
class FileViewerScreen extends StatelessWidget {
  /// The file to be displayed.
  final File file;

  /// Constructs a FileViewerScreen.
  ///
  /// The [file] parameter is required and represents the file to be displayed.
  const FileViewerScreen({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Set the app bar title to the file name
        title: Text(file.path.split('/').last),
      ),
      body: FutureBuilder<String>(
        // Asynchronously read the file contents
        future: file.readAsString(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the file has been read
            if (snapshot.hasError) {
              // Display an error message if reading failed
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            // Display the file contents in a scrollable view
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(snapshot.data ?? 'No data'),
              ),
            );
          } else {
            // Show a loading indicator while the file is being read
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}