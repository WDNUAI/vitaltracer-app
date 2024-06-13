import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HealthDataTile extends StatelessWidget {
  final String label;
  final String value;
  final String imagePath;
  final VoidCallback onTap;

  const HealthDataTile({
    super.key,
    required this.label,
    required this.value,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150.w,
        height: 150.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5.r,
              blurRadius: 7.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        padding:  EdgeInsets.all(16.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ Expanded(
            child: Image.asset(
              imagePath,
              height: 100.h,
              width: 100.w,
            ),
          ),
             SizedBox(height: 8.h),
            Text(
              label,
              style:  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 4.h),
            Text(
              value,
              style:  TextStyle(fontSize: 16.sp),
            ),
          ],
        ),
      ),
    );
  }
}
