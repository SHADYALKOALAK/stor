import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginWith extends StatelessWidget {
  final String text;
  final String icon;

  const LoginWith({
    required this.text,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 57.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: Colors.white,
        border: Border.all(width: 1.w, color: const Color(0xffEBF0FF)),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.symmetric(
                vertical: 16.h, horizontal: 16.w),
            child: SvgPicture.asset(
              icon,
              height: 24.h,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: const Color(0xff9098B1)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
