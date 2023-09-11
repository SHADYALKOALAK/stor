import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:store/FireBase/fb_add_to_favorite_controller.dart';
import 'package:store/FireBase/fb_cart_controller.dart';
import 'package:store/FireBase/users_fb_controller.dart';
import 'package:store/Helbers/nav_helber.dart';
import 'package:store/Screens/home_page.dart';
import 'package:store/Screens/login_screen.dart';
import 'package:store/cache/cache_controller.dart';
import 'package:store/enums/enums.dart';
import 'package:store/providers/auth_provider.dart';
import 'package:store/providers/card_provider.dart';
import 'package:store/providers/favorite_provider.dart';
import 'package:store/screens/AdminScreens/home_admin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with NavHelper {
  AuthProvider get _auth => Provider.of<AuthProvider>(context, listen: false);

  FavoriteProvider get favP =>
      Provider.of<FavoriteProvider>(context, listen: false);
  CartProvider get cardP =>
      Provider.of<CartProvider>(context, listen: false);


  @override
  void initState() {
    super.initState();
    init;
  }

  Future<void> get init async {
    bool loggedIn = CacheController().getter(CacheKeys.loggedIn) ?? false;

    if (loggedIn) {
      var user = await UsersFbController().show(CacheController().getter(CacheKeys.email));
      if (context.mounted) {
        Provider.of<AuthProvider>(context, listen: false).user = user;
      }
      await _fav;
      await _card;
    }
    Future.delayed(
      const Duration(seconds: 2),
      () => jump(
          context,
          loggedIn
              ? _auth.user?.permission == AppPermission.admin.name
                  ? const HomeAdminScreen()
                  : const HomePage()
              : const LoginScreen(),
          true),
    );
  }

  Future<void> get _fav async {
    try {
      var data = await FbAddToFavoriteController().getAllFavorite();
      favP.favorites = data;
    } catch (e) {
      ///
    }
  }
  Future<void> get _card async {
    try {
      var data = await FbCartController().getAllCartProduct();
      cardP.carts = data;
    } catch (e) {
      ///
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child:
        SvgPicture.asset(
          'assets/images/icon.svg',
        ),
      ),
    );
  }
}
