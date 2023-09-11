import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:store/FireBase/Models/ads_model.dart';
import 'package:store/FireBase/Models/category_model.dart';
import 'package:store/FireBase/fb_admin_product_bestSell_controller.dart';
import 'package:store/FireBase/fb_admin_product_category_controller.dart';
import 'package:store/FireBase/fb_admin_product_ads_controller.dart';
import 'package:store/FireBase/Models/product_model.dart';
import 'package:store/FireBase/fb_admin_product_pupuler_controller.dart';
import 'package:store/Helbers/nav_helber.dart';
import 'package:store/Screens/more_purpler_screen.dart';
import 'package:store/Screens/product_details.dart';
import 'package:store/Witgets/container_advertisement.dart';
import 'package:store/Witgets/custom_app_bar.dart';
import 'package:store/Witgets/custom_row.dart';
import 'package:store/Witgets/product_displaying.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with NavHelper {
  AppLocalizations get localizations => AppLocalizations.of(context)!;
  late TextEditingController searchEditingController;
  late PageController controller;

  List<AdsModel> ads = [];

  @override
  void initState() {
    super.initState();
    searchEditingController = TextEditingController();
    controller = PageController();
  }

  @override
  void dispose() {
    searchEditingController.dispose();
    controller.dispose();
    super.dispose();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(top: 40.h, bottom: 16.h),
            child: CustomAppBar(
              editingController: searchEditingController,
              icon1: 'assets/icons/fav.svg',
              icon2: 'assets/icons/notification.svg',
              edHint: localizations.searchProduct,
              iconEditText: Icons.search_rounded,
              notifications: true,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 16.w,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 200.h,
              child: StreamBuilder(
                stream: FbAdminProductAdsController().read(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    List<AdsModel> list =
                        snapshot.data!.docs.map((e) => e.data()).toList();
                    ads = list;
                    return PageView.builder(
                      controller: controller,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (value) =>
                          setState(() => selectedIndex = value),
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Container(
                          clipBehavior: Clip.antiAlias,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: Colors.grey.shade300,
                          ),
                          child: Stack(
                            children: [
                              list[index].image?.link != null
                                  ? CachedNetworkImage(
                                      imageUrl: list[index].image!.link!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                  : const SizedBox.shrink(),
                              PositionedDirectional(
                                top: 20,
                                start: 20,
                                child: Text(
                                  list[index].titel ?? '',
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              PositionedDirectional(
                                bottom: 0,
                                top: 70,
                                start: 20,
                                child: Row(
                                  children: [
                                    ContainerAdvertisement(
                                        text: list[index].time ?? ''),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return buildCenterChick(context);
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: 16.h,
            width: double.infinity,
          ),
          ads.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10.h,
                      child: ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              height: 10.h,
                              width: selectedIndex == index ? 10.w : 8.h,
                              decoration: BoxDecoration(
                                color: selectedIndex == index
                                    ? Theme.of(context).primaryColor
                                    : const Color(0xffEBF0FF),
                                shape: selectedIndex == index
                                    ? BoxShape.rectangle
                                    : BoxShape.circle,
                                borderRadius: selectedIndex == index
                                    ? BorderRadius.circular(50.r)
                                    : null,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 8.w);
                          },
                          itemCount: ads.length),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          CustomRow(
              rText: localizations.category, lText: localizations.moreCategory),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
            child: SizedBox(
              height: 100.h,
              child: StreamBuilder(
                stream: FbAdminProductCategoryController().read(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    List<CategoryModel> list =
                        snapshot.data!.docs.map((e) => e.data()).toList();
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                                clipBehavior: Clip.antiAlias,
                                width: 70,
                                height: 70,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1, color: Color(0xFFEAEFFF)),
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                ),
                                child: list[index].image?.link != null
                                    ? CachedNetworkImage(
                                        imageUrl: list[index].image!.link!,
                                        fit: BoxFit.cover)
                                    : null),
                            SizedBox(height: 8.h),
                            Expanded(
                                child: Text(
                              list[index].name ?? '',
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w100,
                                  color: const Color(0xff9098B1)),
                            )),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 12.w),
                    );
                  } else {
                    return buildCenterChick(context);
                  }
                },
              ),
            ),
          ),
          InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => jump(context, const MorePurplerScreen(), false),
              child: CustomRow(
                  rText: localizations.purpler, lText: localizations.seeMore)),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: StreamBuilder(
                stream: FbAdminProductPurplerController().read(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                        color: Theme.of(context).primaryColor);
                  } else if (snapshot.hasData &&
                      snapshot.data!.docs.isNotEmpty) {
                    List<ProductModel> list =
                        snapshot.data!.docs.map((e) => e.data()).toList();
                    return SizedBox(
                      width: double.infinity,
                      height: 200.h,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                jump(
                                    context,
                                    ProductDetails(
                                      list: list[index].images,
                                      offer: list[index].offer,
                                      titel: list[index].titel,
                                      price: list[index].price,
                                      oldPrice: list[index].oldPrice,
                                      description: list[index].description,
                                      id: list[index].id,
                                    ),
                                    false);
                              },
                              child: Products(
                                image: list[index].images!.first.link,
                                offer: list[index].offer,
                                oldPrice: list[index].oldPrice,
                                price: list[index].price,
                                titel: list[index].titel,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 16.w),
                          itemCount: list.length),
                    );
                  } else {
                    return buildCenterChick(context);
                  }
                },
              )),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => jump(context, const MorePurplerScreen(), false),
            child: CustomRow(
                rText: localizations.bestSeller, lText: localizations.seeMore),
          ),
          SizedBox(
            width: double.infinity,
            height: 200.h,
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
              child: StreamBuilder(
                stream: FbAdminProductBestSellerController().read(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                        color: Theme.of(context).primaryColor);
                  } else if (snapshot.hasData &&
                      snapshot.data!.docs.isNotEmpty) {
                    List<ProductModel> list =
                        snapshot.data!.docs.map((e) => e.data()).toList();
                    return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              jump(
                                  context,
                                  ProductDetails(
                                    list: list[index].images,
                                    offer: list[index].offer,
                                    titel: list[index].titel,
                                    price: list[index].price,
                                    oldPrice: list[index].oldPrice,
                                    description: list[index].description,
                                    id: list[index].id,
                                  ),
                                  false);
                            },
                            child: Products(
                              image: list[index].images?.first.link,
                              offer: list[index].offer,
                              oldPrice: list[index].oldPrice,
                              price: list[index].price,
                              titel: list[index].titel,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 16.w),
                        itemCount: list.length);
                  } else {
                    return buildCenterChick(context);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Center buildCenterChick(BuildContext context) {
    return Center(
      child: Text(
        localizations.noData,
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 30.sp,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
