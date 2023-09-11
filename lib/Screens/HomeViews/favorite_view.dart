import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:store/FireBase/Models/product_model.dart';
import 'package:store/FireBase/fb_add_to_favorite_controller.dart';
class FavoriteView extends StatefulWidget {
  const FavoriteView({Key? key}) : super(key: key);

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  AppLocalizations get localizations => AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
      stream: FbAddToFavoriteController().read(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor));
        } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          List<ProductModel> list =
          snapshot.data!.docs.map((e) => e.data()).toList();
          return Padding(
            padding: EdgeInsetsDirectional.symmetric(vertical: 16.h,horizontal: 16.w),
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return Container(
                    clipBehavior: Clip.antiAlias,
                    width: double.infinity,
                    height: 80.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          strokeAlign: 0.5,
                          color: const Color(0xff9098B1).withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5.h),
                          child: Container(
                            width: 70.w,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: CachedNetworkImage(
                                imageUrl: list[index].images?.first.link,
                                fit: BoxFit.cover),
                          ),
                        ),
                        Expanded(
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
                        Padding(
                          padding: EdgeInsets.all(8.0.h),
                          child: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: IconButton(
                                  onPressed: () async =>
                                  await deleteItem(list[index]),
                                  icon:
                                  const Icon(Icons.delete_outline_outlined),
                                  color: Colors.red)),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 10.h),
                itemCount: list.length),
          );
        } else {
          return buildCenterChick(context);
        }
      },
    );
  }
  Future<void> deleteItem(ProductModel model) async {
    await FbAddToFavoriteController().delete(model);
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
