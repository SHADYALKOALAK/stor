import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:store/FireBase/Models/category_model.dart';
import 'package:store/FireBase/Models/product_model.dart';
import 'package:store/FireBase/fb_product_controller.dart';
import 'package:store/Helbers/nav_helber.dart';
import 'package:store/Screens/product_details.dart';
import 'package:store/Witgets/product_item.dart';

class CategoryScreen extends StatefulWidget {
  final CategoryModel model;

  const CategoryScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with NavHelper {
  AppLocalizations get localizations => AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.model.name ?? ''),
      ),
      body: Padding(
          padding:
              EdgeInsetsDirectional.symmetric(vertical: 16.h, horizontal: 16.w),
          child: StreamBuilder(
            stream: FbProductController()
                .getAllCategoryFromId(widget.model.id ?? ''),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor));
              } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                List<ProductModel> list =
                    snapshot.data!.docs.map((e) => e.data()).toList();
                return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: list.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.h,
                      mainAxisExtent: 220.h,
                      mainAxisSpacing: 10.w),
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
                      child: ProductItem(model: list[index])
                    );
                  },
                );
              } else {
                return buildCenterChick();
              }
            },
          )),
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
}
