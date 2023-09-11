import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:store/FireBase/users_fb_controller.dart';
import 'package:store/Helbers/nav_helber.dart';
import 'package:store/Screens/home_page.dart';
import 'package:store/Screens/login_screen.dart';
import 'package:store/cache/cache_controller.dart';
import 'package:store/enums.dart';
import 'package:store/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with NavHelper {
  @override
  void initState() {
    super.initState();
    init;
  }

  Future<void> get init async {
    bool loggedIn = CacheController().getter(CacheKeys.loggedIn) ?? false;

    if (loggedIn) {
      var user = await UsersFbController()
          .show(CacheController().getter(CacheKeys.email));

      if (context.mounted) {
        Provider.of<AuthProvider>(context, listen: false).user = user;
      }
    }
    Future.delayed(
      const Duration(seconds: 3),
      () => jump(
          context, loggedIn ? const HomePage() : const LoginScreen(), true),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SvgPicture.asset(
          'assets/images/icon.svg',
        ),
      ),
    );
  }
}
