
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RowDivider extends StatelessWidget {
  final String text;

  const RowDivider({
    required this.text,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.black.withOpacity(0.5),
            endIndent: 10.w,
          ),
        ),
        Text(
          text.toUpperCase(),
          style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xff9098B1),
              fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Divider(
            color: Colors.black.withOpacity(0.5),
            indent: 10.w,
          ),
        ),
      ],
    );
  }
}