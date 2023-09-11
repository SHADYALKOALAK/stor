import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:store/FireBase/Models/product_model.dart';
import 'package:store/FireBase/fb_add_to_favorite_controller.dart';
import 'package:store/Helbers/nav_helber.dart';
import 'package:store/Screens/product_details.dart';
import 'package:store/cache/cache_controller.dart';
import 'package:store/enums/enums.dart';
import 'package:store/fireBase/Models/favorite+model.dart';
import 'package:store/helbers/cach_net_work_helper.dart';
import 'package:uuid/uuid.dart';

class ProductItem extends StatefulWidget {
  final ProductModel model;
  final bool showIconDelete;

  const ProductItem({
    Key? key,
    this.showIconDelete = false,
    required this.model,
  }) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem>
    with NavHelper, CacheNetWorkImageHelper {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240.h,
      width: 140.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(5.r),
          border: Border.all(
            width: 1.w,
            color: const Color(0xff9098B1).withOpacity(.2),
          )),
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: 10.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(
                  top: 16.h, end: 16.w, bottom: 8.h),
              child: Container(
                clipBehavior: Clip.antiAlias,
                height: 110.h,
                width: 110.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(5.r),
                ),
                child: cacheImage(widget.model.images?.first.link ?? ''),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.model.titel ?? '',
                    style: const TextStyle(
                      color: Color(0xFF223263),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      height: 1.50,
                      letterSpacing: 0.50,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "\$${widget.model.price ?? ''}",
                    style: const TextStyle(
                      color: Color(0xFF40BFFF),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      height: 1.80,
                      letterSpacing: 0.50,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.model.oldPrice ?? '',
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
                              widget.model.offer ?? '',
                              style: TextStyle(
                                color: const Color(0xFFFB7181),
                                fontSize: 10.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                height: 1.50,
                                letterSpacing: 0.50,
                              ),
                            ),
                          ],
                        ),
                        widget.showIconDelete
                            ? IconButton(
                                onPressed: () async {
                                  await FbAddToFavoriteController().toggle(
                                      context,
                                      FavoriteModel(
                                        idUser: CacheController()
                                            .getter(CacheKeys.id),
                                        id: const Uuid().v4(),
                                        timestamp: Timestamp.now(),
                                        productModel: widget.model,
                                      ));
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Color(0xff9098B1),
                                ))
                            : const SizedBox.shrink()
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
