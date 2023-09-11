import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:store/FireBase/Models/ads_model.dart';
import 'package:store/FireBase/Models/category_model.dart';
import 'package:store/FireBase/fb_product_controller.dart';
import 'package:store/FireBase/fb_admin_product_category_controller.dart';
import 'package:store/FireBase/fb_admin_product_ads_controller.dart';
import 'package:store/FireBase/Models/product_model.dart';
import 'package:store/Helbers/nav_helber.dart';
import 'package:store/Screens/more_purpler_screen.dart';
import 'package:store/Screens/product_details.dart';
import 'package:store/Witgets/custom_app_bar.dart';
import 'package:store/Witgets/custom_row.dart';
import 'package:store/Witgets/product_item.dart';
import 'package:store/screens/category_screen.dart';
import 'package:store/screens/more_bestSell_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with NavHelper {
  AppLocalizations get localizations => AppLocalizations.of(context)!;
  late TextEditingController searchEditingController;
  late PageController controller;
  int _currentPage = 0;
  late List<AdsModel> list = [];
  late final int _totalPages = list.length;

  @override
  void initState() {
    super.initState();
    searchEditingController = TextEditingController();
    controller = PageController(initialPage: 0);
    timerSlider;
    chickIntranet();
  }

  void chickIntranet() async {
    try {
      var data = await Connectivity().checkConnectivity();
    } catch (e) {
      ///
    }
  }

  void get timerSlider {
    try {
      Timer.periodic(const Duration(seconds: 2), (Timer timer) {
        if (_currentPage < _totalPages - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      });
    } catch (e) {
      ///
    }
  }

  @override
  void dispose() {
    searchEditingController.dispose();
    controller.dispose();
    chickIntranet();
    super.dispose();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        return snapshot.data != ConnectivityResult.none
            ? Column(
                children: [
                  /// App Bar
                  Padding(
                    padding: EdgeInsetsDirectional.only(top: 40.h),
                    child: CustomAppBar(
                      editingController: searchEditingController,
                      icon: 'assets/icons/notification.svg',
                      edHint: localizations.searchProduct,
                      iconEditText: Icons.search_rounded,
                      notifications: false,
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Column(
                          children: [
                            /// page view
                            buildPageView(),

                            /// Category
                            buildCategory(),

                            /// Products Purpler
                            buildPurpler(),

                            /// best Sell
                            buildBestSell(),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )
            : Center(child: Lottie.asset('assets/anims/no_intranet.json'));
      },
    );
  }

  Widget buildBestSell() {
    return Column(
      children: [
        /// Custom Row Title
        CustomRowTitle(
          rText: localizations.bestSeller,
          lText: localizations.seeMore,
          onTap: () => jump(context, const MoreBestSellScreen(), false),
        ),
        SizedBox(
          width: double.infinity,
          height: 220.h,
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
            child: StreamBuilder(
              stream: FbProductController().reedCategory('bestSellProducts'),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  List<ProductModel> list =
                      snapshot.data!.docs.map((e) => e.data()).toList();
                  return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () => jump(context,
                              ProductDetails(model: list[index]), false),
                          child: ProductItem(model: list[index]),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 16.w),
                      itemCount: list.length);
                } else {
                  return _empty;
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPurpler() {
    return Column(
      children: [
        /// custom Row Title
        CustomRowTitle(
          rText: localizations.purpler,
          lText: localizations.seeMore,
          onTap: () => jump(context, const MorePurplerScreen(), false),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: StreamBuilder(
              stream: FbProductController().reedCategory('purplerProducts'),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  List<ProductModel> list =
                      snapshot.data!.docs.map((e) => e.data()).toList();
                  return SizedBox(
                    width: double.infinity,
                    height: 220.h,
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        // shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () => jump(context, ProductDetails(model: list[index]), false),
                            child: ProductItem(model: list[index]),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 16.w),
                        itemCount: list.length),
                  );
                } else {
                  return _empty;
                }
              },
            )),
      ],
    );
  }

  Widget buildCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// custom Row Title
        CustomRowTitle(
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
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => jump(
                            context, CategoryScreen(model: list[index]), false),
                        child: Column(
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
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(width: 12.w),
                  );
                } else {
                  return _empty;
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPageView() {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 16.w,
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 200.h,
            child: StreamBuilder(
              stream: FbAdminProductAdsController().read(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  list = snapshot.data!.docs.map((e) => e.data()).toList();
                  return PageView.builder(
                    controller: controller,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (value) =>
                        setState(() => selectedIndex = value),
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsetsDirectional.only(end: 5.w),
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
                                : _empty,
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
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return _empty;
                }
              },
            ),
          ),
          SizedBox(
            height: 16.h,
            width: double.infinity,
          ),
          list.isNotEmpty
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
                          itemCount: list.length),
                    ),
                  ],
                )
              : _empty
        ],
      ),
    );
  }

  Widget buildCenterChick() {
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

  SizedBox get _empty => const SizedBox.shrink();
}
