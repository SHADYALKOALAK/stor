import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:store/Screens/AdminScreens/all_products.dart';
import 'package:store/Screens/AdminScreens/category_view_admin.dart';
import 'package:store/Screens/AdminScreens/offer_view_admin.dart';
import 'package:store/Screens/splash_screen.dart';
import 'package:store/cache/cache_controller.dart';
import 'package:store/enums/enums.dart';
import 'package:store/screens/AdminScreens/add_products_view_admin.dart';
import '../../Helbers/nav_helber.dart';

class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({Key? key}) : super(key: key);

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> with NavHelper {
  int selectedIndex = 0;

  AppLocalizations get localizations => AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            jump(context, const SplashScreen(), true);
            CacheController().setter(CacheKeys.loggedIn, false);
          },
          child: Icon(
            Icons.logout_outlined,
            color: Theme.of(context).primaryColor,
            size: 20.h,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: GridView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.h,
            mainAxisSpacing: 10.w,
          ),
          children: [
            buildContainerGridView(
                onTape: () => jump(context, const OfferViewAdmin(), false),
                icon: Icons.local_offer_outlined,
                text: localizations.offer),
            buildContainerGridView(
                onTape: () => jump(context, const CategoryViewAdmin(), false),
                icon: Icons.category_outlined,
                text: localizations.category),
            buildContainerGridView(
                onTape: () => jump(context, const AddProducts(), false),
                icon: Icons.shopping_cart_outlined,
                text: localizations.addProduct),
            buildContainerGridView(
                onTape: () => jump(context, const AllProductsAdmin(), false),
                icon: Icons.all_inclusive,
                text: localizations.allProducts),
          ],
        ),
      ),
    );
  }

  Widget buildContainerGridView(
      {required Function() onTape, required IconData icon, String? text}) {
    return InkWell(
      onTap: onTape,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(10.r),
            color: Colors.white,
            border: Border.all(
                width: 1, color: const Color(0xff9098B1).withOpacity(.5))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 40.h,
            ),
            SizedBox(height: 10.h),
            Text(
              text ?? '',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
