import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store/Helbers/nav_helber.dart';
import 'package:store/Witgets/my_text_filed.dart';
import 'package:store/screens/notifications_screen.dart';

class CustomAppBar extends StatefulWidget {
  final String? edHint;
  final String? icon;
  final IconData? iconEditText;
  final bool? notifications;
  final TextEditingController editingController;

  const CustomAppBar({
    Key? key,
    this.edHint,
    this.iconEditText,
    this.notifications,
    required this.editingController,
    this.icon,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> with NavHelper {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void deactivate() {
    controller.dispose();
    super.deactivate();
  }

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
              editingController: controller,
              iconData: Icons.search_rounded,
              hint: widget.edHint ?? '',
              iSPrefixIcon: true,
              isFocus: false,
              inputAction: TextInputAction.search,
              inputType: TextInputType.text,
              colorHint: const Color(0xff9098B1),
              isBorderStyle: true,
            )),
            SizedBox(width: 8.w),
            InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () => jump(context, NotificationsScreen(), false),
                child: Stack(
                  children: [
                    PositionedDirectional(
                        child: SvgPicture.asset(widget.icon ?? '')),
                    widget.notifications == true
                        ? PositionedDirectional(
                            start: 0,
                            child: CircleAvatar(
                              radius: 5.r,
                              backgroundColor: const Color(0xffFB7181),
                            ))
                        : const SizedBox.shrink(),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
