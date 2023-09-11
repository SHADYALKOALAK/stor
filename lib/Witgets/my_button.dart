import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyButton extends StatefulWidget {
  final String text;
  final double width;
  final double height;
  final bool isBorder;
  final double sizeText;
  final Color? colorButton;
  final Function? onTap;
  final FontWeight? fontWeight;

  const MyButton({
    required this.text,
    this.width = double.infinity,
    this.height = 50,
    this.isBorder = false,
    this.sizeText = 18,
    this.fontWeight,
    this.onTap,
    this.colorButton,
    super.key,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width.w,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.isBorder != true ? widget.colorButton : Colors
            .transparent,
        borderRadius: BorderRadius.circular(5),
        border: widget.isBorder == true
            ? Border.all(width: 1, color: Theme
            .of(context)
            .primaryColor)
            : null,
      ),
      child: Center(
        child: Text(
          widget.text,
          style: TextStyle(
              color: widget.isBorder == false ? Colors.white : Colors.green,
              fontSize: widget.sizeText.sp,
              fontWeight: widget.fontWeight),
        ),
      ),
    );
  }
}
