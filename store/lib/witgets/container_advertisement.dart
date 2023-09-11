import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContainerAdvertisement extends StatelessWidget {
  final String? text;

  const ContainerAdvertisement({
    super.key,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 150.w,
        height: 40.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          color: Colors.white.withOpacity(0.5),
        ),
        child: Center(
            child: Text(
              text ?? '',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp),
            )));
  }
}