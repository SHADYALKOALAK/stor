import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewProductImage extends StatefulWidget {
  final String? image;

  const ViewProductImage({
    Key? key,
    this.image,
  }) : super(key: key);

  @override
  State<ViewProductImage> createState() => _ViewProductImageState();
}

class _ViewProductImageState extends State<ViewProductImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding:
            EdgeInsetsDirectional.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Container(
          clipBehavior: Clip.antiAlias,
          padding:
              EdgeInsetsDirectional.symmetric(vertical: 10.h, horizontal: 10.w),
          width: double.infinity,
          height: 400.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(
                color: const Color(0xff9098B1).withOpacity(0.5),
                strokeAlign: 0.5),
          ),
          child: CachedNetworkImage(
            imageUrl: widget.image!,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
