import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Products extends StatelessWidget {
  String? image, price, titel, offer, oldPrice;

  Products({
    super.key,
    this.image,
    this.price,
    this.titel,
    this.offer,
    this.oldPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140.w,
      padding: EdgeInsets.all(16.h),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(
              width: 1.w, color: const Color(0xff9098B1).withOpacity(0.2))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              clipBehavior: Clip.antiAlias,
              width: 140.h,
              height: 110.h,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              child: image != null
                  ? CachedNetworkImage(
                      imageUrl: image!, fit: BoxFit.contain)
                  : const SizedBox.shrink(),
            ),
          ),
          Text(
            titel ?? '',
            style: const TextStyle(
              color: Color(0xFF223263),
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              height: 1.50,
              letterSpacing: 0.50,
            ),
          ),
          Text(
            price ?? '',
            style: const TextStyle(
              color: Color(0xFF40BFFF),
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              height: 1.80,
              letterSpacing: 0.50,
            ),
          ),
          Row(
            children: [
              Text(
                oldPrice ?? '',
                style: const TextStyle(
                  color: Color(0xFF9098B1),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.lineThrough,
                  height: 1.50,
                  letterSpacing: 0.50,
                ),
              ),
              SizedBox(width: 8.h),
              Text(
                offer ?? '',
                style: TextStyle(
                  color: Color(0xFFFB7181),
                  fontSize: 10.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 1.50,
                  letterSpacing: 0.50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
