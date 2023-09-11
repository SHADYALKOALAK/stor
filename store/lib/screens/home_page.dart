import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:store/Screens/HomeViews/cart_view.dart';
import 'package:store/Screens/HomeViews/home_view.dart';
import 'package:store/Screens/HomeViews/favorite_view.dart';
import 'package:store/Screens/HomeViews/profile_view.dart';
import 'package:store/Screens/HomeViews/serch_view.dart';
import 'package:store/providers/favorite_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppLocalizations get localizations => AppLocalizations.of(context)!;
  int selectedIndex = 0;

  FavoriteProvider get favoriteProvider =>
      Provider.of<FavoriteProvider>(context, listen: false);

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
                icon: SvgPicture.asset('assets/icons/home.svg',
                    color: selectedIndex == 0
                        ? Theme.of(context).primaryColor
                        : const Color(0xff9098B1)),
                label: localizations.home),
            BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/search.svg',
                    color: selectedIndex == 1
                        ? Theme.of(context).primaryColor
                        : const Color(0xff9098B1)),
                label: localizations.explore),
            BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/cart.svg',
                    color: selectedIndex == 2
                        ? Theme.of(context).primaryColor
                        : const Color(0xff9098B1)),
                label: localizations.cart),
            BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    SvgPicture.asset('assets/icons/fav.svg',
                        color: selectedIndex == 3
                            ? Theme.of(context).primaryColor
                            : const Color(0xff9098B1)),
                    favoriteProvider.favorites.isNotEmpty
                        ? PositionedDirectional(
                            start: 0,
                            end: 10.w,
                            bottom: 7.h,
                            child: Container(
                              width: 14.h,
                              height: 14.h,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffFB7181)),
                              child: Center(
                                child: Text(
                                  favoriteProvider.favorites.length.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    height: 1.50.h,
                                    letterSpacing: 0.50,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
                label: localizations.favorite),
            BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/icons/user.svg',
                    color: selectedIndex == 4
                        ? Theme.of(context).primaryColor
                        : const Color(0xff9098B1)),
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
