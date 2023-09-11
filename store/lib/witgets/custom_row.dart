import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRowTitle extends StatefulWidget {
  final String? rText;
  final String? lText;
  final Function()? onTap;

  const CustomRowTitle({
    this.rText,
    this.lText,
    this.onTap,
    super.key,
  });

  @override
  State<CustomRowTitle> createState() => _CustomRowTitleState();
}

class _CustomRowTitleState extends State<CustomRowTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsetsDirectional.symmetric(vertical: 10.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.rText ?? '',
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xff223263)),
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: widget.onTap,
            child: Text(
              widget.lText ?? '',
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
