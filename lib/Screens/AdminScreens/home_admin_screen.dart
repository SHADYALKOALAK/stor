import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:store/Screens/AdminScreens/bestSell_view_admin.dart';
import 'package:store/Screens/AdminScreens/category_view_admin.dart';
import 'package:store/Screens/AdminScreens/offer_view_admin.dart';
import 'package:store/Screens/AdminScreens/pupuler_view_admin.dart';

class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({Key? key}) : super(key: key);

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  int selectedIndex = 0;

  AppLocalizations get localizations => AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Icon(
          Icons.logout_outlined,
          color: Theme.of(context).primaryColor,
          size: 20.h,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsetsDirectional.only(bottom: 3.h),
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            setState(() => selectedIndex = value);
          },
          currentIndex: selectedIndex,
          showUnselectedLabels: true,
          unselectedItemColor: const Color(0xff9098B1),
          unselectedLabelStyle: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.w100),
          selectedItemColor: Theme.of(context).primaryColor,
          selectedLabelStyle: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold),
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/offer.svg',
                    color: selectedIndex == 0
                        ? Theme.of(context).primaryColor
                        : const Color(0xff9098B1)),
                label: localizations.offer),
            BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined,
                    color: selectedIndex == 1
                        ? Theme.of(context).primaryColor
                        : const Color(0xff9098B1)),
                label: localizations.category),
            BottomNavigationBarItem(
                icon: Icon(Icons.backup_outlined,
                    color: selectedIndex == 2
                        ? Theme.of(context).primaryColor
                        : const Color(0xff9098B1)),
                label: localizations.purpler),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined,
                    color: selectedIndex == 3
                        ? Theme.of(context).primaryColor
                        : const Color(0xff9098B1)),
                label: localizations.bestSeller),
          ],
        ),
      ),
      body: [
        const OfferViewAdmin(),
        const CategoryViewAdmin(),
        const PurplerViewAdmin(),
        const BestSellViewAdmin(),
      ][selectedIndex],
    );
  }
}
