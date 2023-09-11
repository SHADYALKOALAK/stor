import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:store/Screens/HomeViews/cart_view.dart';
import 'package:store/Screens/HomeViews/home_view.dart';
import 'package:store/Screens/HomeViews/favorite_view.dart';
import 'package:store/Screens/HomeViews/profile_view.dart';
import 'package:store/Screens/HomeViews/serch_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppLocalizations get localizations => AppLocalizations.of(context)!;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                icon: SvgPicture.asset('assets/icons/home.svg',color: selectedIndex==0?Theme.of(context).primaryColor:const Color(0xff9098B1)),
                label: localizations.home),
            BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/search.svg',color: selectedIndex==1?Theme.of(context).primaryColor:const Color(0xff9098B1)),
                label: localizations.explore),
            BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/cart.svg',color: selectedIndex==2?Theme.of(context).primaryColor:const Color(0xff9098B1)),
                label: localizations.cart),
            BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/fav.svg',color: selectedIndex==3?Theme.of(context).primaryColor:const Color(0xff9098B1)),
                label: localizations.favorite),
            BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/user.svg',color: selectedIndex==4?Theme.of(context).primaryColor:const Color(0xff9098B1)),
                label: localizations.account),
          ],
        ),
      ),
      body: [
        const HomeView(),
        const SearchView(),
        const CartView(),
        const FavoriteView(),
        const ProfileView(),
      ][selectedIndex],
    );
  }
}
