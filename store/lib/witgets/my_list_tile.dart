import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyListTile extends StatelessWidget {
  final Function()? onTap;
  final IconData icon;
  final String text;
  final Color? iconColor;

  const MyListTile({
    this.onTap,
    required this.icon,
    required this.text,
    this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 25.w,
            color: iconColor ?? Theme.of(context).primaryColor,
          ),
          SizedBox(width: 23.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
