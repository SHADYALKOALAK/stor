import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:store/FireBase/Models/product_model.dart';
import 'package:store/FireBase/fb_add_to_favorite_controller.dart';
import 'package:store/FireBase/fb_cart_controller.dart';
import 'package:store/FireBase/fb_product_controller.dart';
import 'package:store/Helbers/nav_helber.dart';
import 'package:store/Screens/product_details.dart';
import 'package:store/Witgets/my_button.dart';
import 'package:store/cache/cache_controller.dart';
import 'package:store/enums/enums.dart';
import 'package:store/fireBase/Models/cart_model.dart';
import 'package:store/fireBase/Models/favorite+model.dart';
import 'package:store/helbers/cach_net_work_helper.dart';
import 'package:store/providers/card_provider.dart';
import 'package:store/providers/favorite_provider.dart';
import 'package:uuid/uuid.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView>
    with NavHelper, CacheNetWorkImageHelper {
  AppLocalizations get localizations => AppLocalizations.of(context)!;
  int counter = 1;

  @override
  Widget build(BuildContext context) {
    return Consumer2<CartProvider, FavoriteProvider>(
      builder: (context, cards, fav, child) {
        return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                localizations.cart,
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
            body: Padding(
              padding: EdgeInsetsDirectional.symmetric(
                  vertical: 16.h, horizontal: 16.w),
              child: cards.carts.isNotEmpty
                  ? buildContainerCart(cards, fav)
                  : buildCenterChick(),
            ));
      },
    );
  }

  Widget buildContainerCart(
      CartProvider cart, FavoriteProvider favoriteProvider) {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: cart.carts.length,
        itemBuilder: (context, index) {
          /// cart View
          return InkWell(
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () => jump(context,
                ProductDetails(model: cart.carts[index].model!), false),
            child: Container(
              width: double.infinity,
              height: 110.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(5.r),
                  border: Border.all(
                      width: 1.w,
                      color: const Color(0xff9098B1).withOpacity(.2))),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.symmetric(
                          vertical: 16.h, horizontal: 16.w),
                      child: Container(
                        width: 72.h,
                        height: 72.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.circular(5.r),
                            color: Colors.grey.shade200),
                        child: cacheImage(
                            cart.carts[index].model?.images?.first.link ?? ''),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(top: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 160.w,
                              child: Text(
                                cart.carts[index].model?.titel ?? '',
                                style: TextStyle(
                                  color: const Color(0xFF223263),
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  height: 1.50,
                                  letterSpacing: 0.50,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await FbAddToFavoriteController().toggle(
                                    context,
                                    FavoriteModel(
                                      timestamp: Timestamp.now(),
                                      id: const Uuid().v4(),
                                      idUser: CacheController()
                                          .getter(CacheKeys.id),
                                      productModel: cart.carts[index].model,
                                    ));
                              },
                              icon: Icon(
                                favoriteProvider
                                        .checkFavorite(cart.carts[index].model)
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                color: favoriteProvider
                                        .checkFavorite(cart.carts[index].model)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            SizedBox(
                              width: 30.w,
                              child: IconButton(
                                  onPressed: () async {
                                    await FbCartController().delete(
                                        context,
                                        CartModel(
                                          model: cart.carts[index].model,
                                          idUser: CacheController()
                                              .getter(CacheKeys.id),
                                          id: const Uuid().v4(),
                                          timestamp: Timestamp.now(),
                                        ));
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Color(0xff9098B1),
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            SizedBox(
                              width: 120.w,
                              child: Text(
                                '\$${cart.carts[index].model?.price ?? ''}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  height: 1.50,
                                  letterSpacing: 0.50,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 16.h));
  }

  Widget buildCenterChick() {
    return Center(
      child: Lottie.asset('assets/anims/no_data.json'),
      // child: Lottie.network('https://lottie.host/793866b2-cee0-4558-8203-83076e0885ec/61K2FaCCyd.json'),
    );
  }
}
