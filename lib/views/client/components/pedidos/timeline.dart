import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget timeline() {
  return Row(
    children: [
      SizedBox(
        width: 3.w,
      ),
      Container(
        width: 5.w,
        height: 5.w,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 36, 50, 204),
            borderRadius: BorderRadius.circular(50.r)),
      ),
      SizedBox(
        width: 3.w,
      ),
    ],
  );
}
