import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:store/FireBase/Models/ads_model.dart';
import 'package:store/FireBase/Models/category_model.dart';
import 'package:store/FireBase/Models/images_model.dart';
import 'package:store/FireBase/Models/product_model.dart';
import 'package:store/FireBase/fb_admin_product_ads_controller.dart';
import 'package:store/FireBase/fb_product_controller.dart';
import 'package:store/FireBase/fb_admin_product_category_controller.dart';
import 'package:store/FireBase/fb_storeg_controller.dart';
import 'package:store/Helbers/nav_helber.dart';
import 'package:store/Screens/AdminScreens/category_view_admin.dart';
import 'package:store/Screens/AdminScreens/offer_view_admin.dart';
import 'package:store/Witgets/container_advertisement.dart';
import 'package:store/Witgets/custom_row.dart';
import 'package:store/Witgets/product_item.dart';
import 'package:store/screens/AdminScreens/add_products_view_admin.dart';

class AllProductsAdmin extends StatefulWidget {
  const AllProductsAdmin({Key? key}) : super(key: key);

  @override
  State<AllProductsAdmin> createState() => _AllProductsAdminState();
}

class _AllProductsAdminState extends State<AllProductsAdmin> with NavHelper {
  AppLocalizations get localizations => AppLocalizations.of(context)!;
  List<AdsModel> ads = [];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          localizations.allProducts.toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20.sp),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        // physics: const BouncingScrollPhysics(),
        children: [
          /// buildPageView
          buildPageView(),

          /// buildCategory
          buildCategory(),

          /// buildBestSell
          buildBestSell(),

          /// buildPurpler
          buildPurpler(),
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

  Widget buildPageView() {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 20.h),
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
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (value) =>
                        setState(() => selectedIndex = value),
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => jump(
                            context, OfferViewAdmin(model: list[index]), false),
                        child: Stack(
                          children: [
                            Container(
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
                                ],
                              ),
                            ),
                            PositionedDirectional(
                              start: 0,
                              bottom: 0,
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  FbAdminProductAdsController()
                                      .delete(list[index]);
                                  FbStorageController()
                                      .delete(list[index].image!.path!);
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      child: const Icon(
                                          Icons.delete_outline_outlined,
                                          color: Colors.red),
                                    )),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return buildCenterChick();
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
      ],
    );
  }

  Widget buildCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => jump(
                            context,
                            CategoryViewAdmin(categoryModel: list[index]),
                            false),
                        child: Column(
                          children: [
                            Stack(
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
                                        borderRadius:
                                            BorderRadius.circular(50.r),
                                      ),
                                    ),
                                    child: list[index].image?.link != null
                                        ? CachedNetworkImage(
                                            imageUrl: list[index].image!.link!,
                                            fit: BoxFit.cover)
                                        : null),
                                PositionedDirectional(
                                  bottom: 0,
                                  start: 0,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      FbAdminProductCategoryController()
                                          .delete(list[index]);
                                      FbStorageController()
                                          .delete(list[index].image!.path!);
                                    },
                                    child: const Icon(
                                        Icons.delete_outline_outlined,
                                        color: Colors.red),
                                  ),
                                )
                              ],
                            ),
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
                  return buildCenterChick();
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBestSell() {
    return Column(
      children: [
        CustomRowTitle(
            rText: localizations.bestSeller, lText: localizations.seeMore),
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
                        return Stack(
                          children: [
                            InkWell(
                              onTap: () => jump(
                                  context,
                                  AddProducts(
                                      model: list[index],
                                      checkBoxBestSell: true),
                                  false),
                              child: ProductItem(model: list[index]),
                            ),
                            PositionedDirectional(
                                top: 10,
                                start: 10.w,
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    FbProductController().delete(list[index]);
                                    for (ImagesModel item
                                        in list[index].images!) {
                                      FbStorageController().delete(item.path!);
                                    }
                                  },
                                  child: const Icon(
                                      Icons.delete_outline_outlined,
                                      color: Colors.red),
                                ))
                          ],
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 16.w),
                      itemCount: list.length);
                } else {
                  return buildCenterChick();
                }
              },
            ),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget buildPurpler() {
    return Column(
      children: [
        CustomRowTitle(
            rText: localizations.purpler, lText: localizations.seeMore),
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
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              InkWell(
                                onTap: () => jump(
                                    context,
                                    AddProducts(
                                        model: list[index],
                                        checkBoxPurpler: true),
                                    false),
                                child: ProductItem(model: list[index]),
                              ),
                              PositionedDirectional(
                                  top: 10.h,
                                  start: 10.w,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      FbProductController().delete(list[index]);
                                      for (ImagesModel item
                                          in list[index].images!) {
                                        FbStorageController()
                                            .delete(item.path!);
                                      }
                                    },
                                    child: const Icon(
                                        Icons.delete_outline_outlined,
                                        color: Colors.red),
                                  ))
                            ],
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 16.w),
                        itemCount: list.length),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            )),
      ],
    );
  }
}
