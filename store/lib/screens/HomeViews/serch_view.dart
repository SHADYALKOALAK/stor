import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:store/FireBase/Models/product_model.dart';
import 'package:store/FireBase/fb_product_controller.dart';
import 'package:store/Helbers/nav_helber.dart';
import 'package:store/Screens/product_details.dart';
import 'package:store/Witgets/my_text_filed.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with NavHelper {
  late TextEditingController searchEditingController;
  List<ProductModel> searchList = [];
  List<ProductModel> products = [];

  List<ProductModel> get list =>
      searchEditingController.text.isEmpty ? products : searchList;

  @override
  void initState() {
    super.initState();
    searchEditingController = TextEditingController();
    chickIntranet();
  }

  void chickIntranet() async {
    try {
      var data = await Connectivity().checkConnectivity();
    } catch (e) {
      ///
    }
  }

  @override
  void dispose() {
    searchEditingController.dispose();
    super.dispose();
  }

  AppLocalizations get localizations => AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        return snapshot.data != ConnectivityResult.none
            ? Column(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                        start: 20.w, end: 20.w, top: 60.h),
                    child: MyTextField(
                      editingController: searchEditingController,
                      iconData: Icons.search_rounded,
                      hint: localizations.searchProduct,
                      iSPrefixIcon: true,
                      isFocus: false,
                      onChange: (title) {
                        setState(() {
                          searchList.clear();
                          for (var item in products) {
                            if (item.titel!
                                .toLowerCase()
                                .contains(title.toLowerCase())) {
                              searchList.add(item);
                            }
                          }
                        });
                      },
                      inputAction: TextInputAction.search,
                      inputType: TextInputType.text,
                      colorHint: const Color(0xff9098B1),
                      isBorderStyle: true,
                    ),
                  ),
                  StreamBuilder(
                    stream: FbProductController().read(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        );
                      } else if (snapshot.hasData &&
                          snapshot.data!.docs.isNotEmpty) {
                        products =
                            snapshot.data!.docs.map((e) => e.data()).toList();
                        return Expanded(
                          child: list.isNotEmpty
                              ? ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  padding: EdgeInsetsDirectional.symmetric(
                                      horizontal: 16.w, vertical: 16.h),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        jump(
                                            context,
                                            ProductDetails(
                                              model: list[index],
                                            ),
                                            false);
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 90.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          border: Border.all(
                                              width: 1.w,
                                              color: const Color(0xff9098B1)
                                                  .withOpacity(0.5),
                                              strokeAlign: 0.5),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 80.w,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                border: Border.all(
                                                    width: 1.w,
                                                    color:
                                                        const Color(0xff9098B1)
                                                            .withOpacity(0.5),
                                                    strokeAlign: 0.5),
                                              ),
                                              clipBehavior: Clip.antiAlias,
                                              child: CachedNetworkImage(
                                                  imageUrl: list[index]
                                                      .images
                                                      ?.first
                                                      .link,
                                                  fit: BoxFit.cover),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    EdgeInsetsDirectional.all(
                                                        8.h),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        list[index].titel ?? '',
                                                        style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    Expanded(
                                                      child: Text(
                                                        list[index].price ?? '',
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 8.h),
                                  itemCount: list.length)
                              : buildCenterChick(),
                        );
                      } else {
                        return buildCenterChick(); //buildCenterChick();
                      }
                    },
                  )
                ],
              )
            : Center(child: Lottie.asset('assets/anims/no_intranet.json'));
      },
    );
  }

  Widget buildCenterChick() {
    return Center(
      child: Lottie.network(
          'https://lottie.host/8a909e33-845f-46ad-acce-d0f9b990f9e1/M2zhmcUxNj.json'),
    );
  }
}
