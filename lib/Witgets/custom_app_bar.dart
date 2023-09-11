import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store/Witgets/my_text_filed.dart';

class CustomAppBar extends StatelessWidget {
  final String? edHint;
  final String? icon1;
  final String? icon2;
  final IconData? iconEditText;
  final bool? notifications;
  final TextEditingController editingController;

  const CustomAppBar({
    super.key,
    this.edHint,
    this.icon1,
    this.iconEditText,
    this.notifications,
    required this.editingController,
    this.icon2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.zero,
      width: double.infinity,
      height: 80.h,
      decoration: BoxDecoration(
        border: Border.all(
            width: 1.w, color: const Color(0xff9098B1).withOpacity(0.10)),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Expanded(
                child: MyTextField(
                  editingController: editingController,
                  iconData: Icons.search_rounded,
                  hint: edHint ?? '',
                  iSPrefixIcon: true,
                  isFocus: false,
                  inputAction: TextInputAction.search,
                  inputType: TextInputType.text,
                  colorHint: const Color(0xff9098B1),
                  isBorderStyle: true,
                )),
            SizedBox(width: 18.w),
            SvgPicture.asset(icon1 ?? ''),
            SizedBox(width: 20.w),
            Stack(
              children: [
                PositionedDirectional(child: SvgPicture.asset(icon2 ?? '')),
                notifications == true
                    ? CircleAvatar(
                  radius: 5.r,
                  backgroundColor: const Color(0xffFB7181),
                )
                    : const SizedBox.shrink()
              ],
            ),
          ],
        ),
      ),
    );
  }
}