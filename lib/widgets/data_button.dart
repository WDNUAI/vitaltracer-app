import 'package:flutter/material.dart';

class DataButton extends StatelessWidget {
  final String buttonIconImage;
  final String buttonData;
  final VoidCallback onTap;
  const DataButton(
      {super.key,
      required this.buttonIconImage,
      required this.buttonData,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 8.0,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 60.0,
            width: 300.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Container(
                  height: 60.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Image.asset(
                    buttonIconImage,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Text(
                    buttonData,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
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
