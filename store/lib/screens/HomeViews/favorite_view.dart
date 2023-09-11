// ignore_for_file: unnecessary_null_comparison
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:store/FireBase/fb_add_to_favorite_controller.dart';
import 'package:store/Helbers/nav_helber.dart';
import 'package:store/Screens/product_details.dart';
import 'package:store/Witgets/custom_app_bar.dart';
import 'package:store/Witgets/product_item.dart';
import 'package:store/cache/cache_controller.dart';
import 'package:store/enums/enums.dart';
import 'package:store/fireBase/Models/favorite+model.dart';
import 'package:store/providers/favorite_provider.dart';
import 'package:uuid/uuid.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({
    Key? key,
  }) : super(key: key);

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> with NavHelper {
  AppLocalizations get localizations => AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          localizations.favorite,
          style: TextStyle(
            color: const Color(0xFF223263),
            fontSize: 16.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            height: 1.50,
            letterSpacing: 0.08,
          ),
        ),
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, fav, child) {
          return Column(
            children: [
              fav.favorites.isNotEmpty
                  ? Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.symmetric(
                            vertical: 20.h, horizontal: 20.w),
                        child: GridView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          itemCount: fav.favorites.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10.w,
                                  crossAxisSpacing: 10.h,
                                  mainAxisExtent: 220.h),
                          itemBuilder: (context, index) {
                            return InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () => jump(context, ProductDetails(model: fav.favorites[index].productModel!), false),
                              child: ProductItem(
                                model: fav.favorites[index].productModel!,
                                showIconDelete: true,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : buildCenterChick(),
            ],
          );
        },
      ),
    );
  }

  Widget buildCenterChick() {
    return Center(
      child: Lottie.asset('assets/anims/no_data.json'),
      // child: Lottie.network('https://lottie.host/793866b2-cee0-4558-8203-83076e0885ec/61K2FaCCyd.json'),
    );
  }
}
