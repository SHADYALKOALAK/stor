import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:store/FireBase/Models/product_model.dart';
import 'package:store/FireBase/fb_admin_product_pupuler_controller.dart';
import 'package:store/Witgets/product_displaying.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MorePurplerScreen extends StatefulWidget {
  const MorePurplerScreen({Key? key}) : super(key: key);

  @override
  State<MorePurplerScreen> createState() => _MorePurplerScreenState();
}

class _MorePurplerScreenState extends State<MorePurplerScreen> {
  AppLocalizations get localizations => AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding:
              EdgeInsetsDirectional.symmetric(vertical: 16.h, horizontal: 16.w),
          child: StreamBuilder(
            stream: FbAdminProductPurplerController().read(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor));
              } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                List<ProductModel> list =
                    snapshot.data!.docs.map((e) => e.data()).toList();
                return GridView.builder(
                  itemCount: list.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.h,
                      mainAxisSpacing: 10.w),
                  itemBuilder: (context, index) {
                    return Products(
                      price: list[index].price,
                      titel: list[index].titel,
                      offer: list[index].offer,
                      oldPrice: list[index].oldPrice,
                      image: list[index].images!.first.link,
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

  Center buildCenterChick() {
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
