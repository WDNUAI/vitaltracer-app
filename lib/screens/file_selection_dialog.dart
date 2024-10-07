import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'file_viewer_screen.dart';

/// A dialog that allows users to select files for sharing or deletion.
class FileSelectionDialog extends StatefulWidget {
  final List<File> availableFiles;

  const FileSelectionDialog({Key? key, required this.availableFiles}) : super(key: key);

  @override
  _FileSelectionDialogState createState() => _FileSelectionDialogState();
}

class _FileSelectionDialogState extends State<FileSelectionDialog> {
  late List<File> sortedFiles;
  String sortCriteria = 'date';
  bool isAscending = false;
  DateTime? startDate;
  DateTime? endDate;
  String searchQuery = '';
  Set<File> selectedFiles = {};
  bool _isTablet = false;
  double appBarFontSize = 16;

  @override
  void initState() {
    super.initState();
    sortedFiles = List.from(widget.availableFiles);
    _sortFiles();
  }

  /// Sorts the files based on the current sort criteria and order.
  void _sortFiles() {
    switch (sortCriteria) {
      case 'date':
        sortedFiles.sort((a, b) => isAscending
            ? a.lastModifiedSync().compareTo(b.lastModifiedSync())
            : b.lastModifiedSync().compareTo(a.lastModifiedSync()));
        break;
      case 'name':
        sortedFiles.sort((a, b) => isAscending
            ? a.path.split('/').last.compareTo(b.path.split('/').last)
            : b.path.split('/').last.compareTo(a.path.split('/').last));
        break;
      case 'size':
        sortedFiles.sort((a, b) => isAscending
            ? a.lengthSync().compareTo(b.lengthSync())
            : b.lengthSync().compareTo(a.lengthSync()));
        break;
    }
  }

  /// Opens a date range picker and updates the start and end dates.
  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: startDate ?? DateTime.now().subtract(Duration(days: 7)),
        end: endDate ?? DateTime.now(),
      ),
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  /// Deletes the selected files after confirmation.
  void _deleteSelectedFiles() async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${selectedFiles.length} file(s)?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm) {
      try {
        for (var file in selectedFiles) {
          await file.delete();
          sortedFiles.remove(file);
        }
        setState(() {
          selectedFiles.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Files deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting files: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the device is a tablet based on screen size and orientation
    if (MediaQuery.of(context).size.shortestSide > 600 && 
        MediaQuery.of(context).orientation == Orientation.landscape) {
      _isTablet = true;
      appBarFontSize = 20;
    } else {
      _isTablet = false;
      appBarFontSize = 16;
    }
   // Filter files based on date range and search query
List<File> filteredFiles = sortedFiles.where((file) {
  bool dateMatch = true;
  if (startDate != null && endDate != null) {
    DateTime fileDate = file.lastModifiedSync();
    if (isSameDay(startDate!, endDate!)) {
      // Check if the file's last modified date is on the same day as startDate
      dateMatch = isSameDay(fileDate, startDate!);
    } else {
      dateMatch = fileDate.isAfter(startDate!) && fileDate.isBefore(endDate!.add(Duration(days: 1)));
    }
  }
  bool searchMatch = searchQuery.isEmpty ||
      file.path.split('/').last.toLowerCase().contains(searchQuery.toLowerCase());
  return dateMatch && searchMatch;
}).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Select File to Share', style: TextStyle(fontSize: appBarFontSize)),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(_isTablet ? 24.0 : 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search files...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_isTablet ? 12.0 : 8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          // Sorting and filtering options
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _isTablet ? 24.0 : 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sort criteria dropdown
                DropdownButton<String>(
                  value: sortCriteria,
                  items: ['date', 'name', 'size'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.capitalize(), style: TextStyle(fontSize: _isTablet ? 18 : 14)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        sortCriteria = newValue;
                        _sortFiles();
                      });
                    }
                  },
                ),
                // Sort order toggle
                IconButton(
                  icon: Icon(isAscending ? Icons.arrow_upward : Icons.arrow_downward),
                  onPressed: () {
                    setState(() {
                      isAscending = !isAscending;
                      _sortFiles();
                    });
                  },
                ),
                // Date range selection
                ElevatedButton(
                  onPressed: () => _selectDateRange(context),
                  child: Text('Date Range', style: TextStyle(fontSize: _isTablet ? 16 : 14)),
                ),
                // Today's files selection
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      startDate = DateTime.now();
                      endDate = DateTime.now();
                    });
                  },
                  child: Text('Today', style: TextStyle(fontSize: _isTablet ? 16 : 14)),
                ),
              ],
            ),
          ),
          // File list
          Expanded(
            child: ListView.builder(
              itemCount: filteredFiles.length,
              itemBuilder: (BuildContext context, int index) {
                File file = filteredFiles[index];
                String fileName = file.path.split('/').last;
                DateTime fileDate = file.lastModifiedSync();
                String formattedDate = DateFormat('yyyy-MM-dd').format(fileDate);
                String fileSize = (file.lengthSync() / 1024).toStringAsFixed(2) + ' KB';

                return CheckboxListTile(
                  value: selectedFiles.contains(file),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedFiles.add(file);
                      } else {
                        selectedFiles.remove(file);
                      }
                    });
                  },
                  title: Text(
                    fileName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: _isTablet ? 18 : 16),
                  ),
                  subtitle: Text('$formattedDate - $fileSize', 
                    style: TextStyle(fontSize: _isTablet ? 16 : 14)),
                  secondary: IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FileViewerScreen(file: file),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Bottom action buttons
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _isTablet ? 24.0 : 16.0, 
            vertical: _isTablet ? 12.0 : 8.0
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Delete selected files button
              ElevatedButton(
                onPressed: selectedFiles.isNotEmpty ? _deleteSelectedFiles : null,
                child: Text('Delete Selected (${selectedFiles.length})', 
                  style: TextStyle(fontSize: _isTablet ? 16 : 14)),
              ),
              // Share selected files button
              ElevatedButton(
                onPressed: selectedFiles.isNotEmpty
                    ? () {
                        Navigator.of(context).pop(selectedFiles.toList());
                      }
                    : null,
                child: Text('Share Selected (${selectedFiles.length})', 
                  style: TextStyle(fontSize: _isTablet ? 16 : 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Extension to capitalize the first letter of a string.
extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + this.substring(1);
  }
}

/// Utility function to check if two dates are on the same day.
bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}