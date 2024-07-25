import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecordedDataSessionTile extends StatelessWidget {
  final String date;
  final String time;
  final String heartRateImagePath;
  final String heartRate;
  final String temperatureImagePath;
  final String temperature;
  final String oxygenRateImagePath;
  final String oxygenRate;
  final String bloodPressureImagePath;
  final String bloodPressure;
  final VoidCallback onTap;

  const RecordedDataSessionTile({
    super.key,
    required this.date,
    required this.time,
    required this.heartRateImagePath,
    required this.heartRate,
    required this.temperatureImagePath,
    required this.temperature,
    required this.oxygenRateImagePath,
    required this.oxygenRate,
    required this.bloodPressureImagePath,
    required this.bloodPressure,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        elevation: 8.0,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 120.0,
            width: 400.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5.r,
                  blurRadius: 7.r,
                  offset: Offset(0, 3.h),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Session',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Text(
                              date,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              time,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              height: 40.0,
                              width: 40.0,
                              child: Image.asset(
                                heartRateImagePath,
                                color: Colors.pink,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              heartRate,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              height: 40.0,
                              width: 40.0,
                              child: Image.asset(
                                temperatureImagePath,
                                color: Colors.yellow,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              temperature,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              height: 40.0,
                              width: 40.0,
                              child: Image.asset(
                                oxygenRateImagePath,
                                color: Colors.orange,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              oxygenRate,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              height: 40.0,
                              width: 40.0,
                              child: Image.asset(
                                bloodPressureImagePath,
                                color: Colors.purple,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              bloodPressure,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
