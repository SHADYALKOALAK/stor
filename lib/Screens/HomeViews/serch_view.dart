import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store/FireBase/Models/product_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:store/FireBase/fb_admin_product_pupuler_controller.dart';
import 'package:store/Witgets/my_text_filed.dart';

import '../../Witgets/custom_app_bar.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late TextEditingController searchEditingController;

  @override
  void initState() {
    super.initState();
    searchEditingController = TextEditingController();
  }

  @override
  void dispose() {
    searchEditingController.dispose();
    super.dispose();
  }

  AppLocalizations get localizations => AppLocalizations.of(context)!;
  List list = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 40.h),
      child: Column(
        children: [
          Container(
            padding: EdgeInsetsDirectional.zero,
            width: double.infinity,
            height: 80.h,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1.w,
                  color: const Color(0xff9098B1).withOpacity(0.10)),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                      child: MyTextField(
                    editingController: searchEditingController,
                    iconData: Icons.search_rounded,
                    hint: localizations.searchProduct,
                    iSPrefixIcon: true,
                    isFocus: false,
                    onChange: (p0) {
                      searchView(p0);
                    },
                    onSubmit: (p0) => searchView(p0),
                    inputAction: TextInputAction.search,
                    inputType: TextInputType.text,
                    colorHint: const Color(0xff9098B1),
                    isBorderStyle: true,
                  )),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 16.w, vertical: 16.h),
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    height: 70.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(
                          width: 1.w,
                          color: const Color(0xff9098B1).withOpacity(0.5),
                          strokeAlign: 0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 80.w,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(
                                width: 1.w,
                                color: const Color(0xff9098B1).withOpacity(0.5),
                                strokeAlign: 0.5),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: CachedNetworkImage(
                              imageUrl: list[index].images?.first.link,
                              fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.all(8.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                list[index].titel ?? '',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                list[index].price ?? '',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 8.h),
                itemCount: list.length),
          )
        ],
      ),
    );
  }

  void searchView(String query) async {
    var data = await FirebaseFirestore.instance
        .collection('PurplerTable')
        .where('titel', isEqualTo: query)
        .get();
    setState(() {
      list = data.docs.map((e) => e.data()).toList();
    });
  }

  Column buildCenterChick() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/icons/icon_not_found.svg',
          height: 72.h,
          width: 72.w,
        ),
        Text(
          localizations.productNotFound,
          style: TextStyle(
            color: const Color(0xff223263),
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        )
      ],
    );
  }
}
