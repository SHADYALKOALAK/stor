// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, unrelated_type_equality_checks
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:store/FireBase/Models/user_model.dart';
import 'package:store/FireBase/fb_add_to_favorite_controller.dart';
import 'package:store/FireBase/fb_auth.dart';
import 'package:store/FireBase/fb_cart_controller.dart';
import 'package:store/FireBase/fb_signun_controller.dart';
import 'package:store/FireBase/users_fb_controller.dart';
import 'package:store/Helbers/chickDataHelber.dart';
import 'package:store/Helbers/nav_helber.dart';
import 'package:store/Screens/home_page.dart';
import 'package:store/Screens/sign_up_screen.dart';
import 'package:store/Witgets/containr_login.dart';
import 'package:store/Witgets/my_button.dart';
import 'package:store/Witgets/my_text_filed.dart';
import 'package:store/Witgets/row_divider.dart';
import 'package:store/cache/cache_controller.dart';
import 'package:store/enums/enums.dart';
import 'package:store/providers/auth_provider.dart';
import 'package:store/providers/card_provider.dart';
import 'package:store/providers/favorite_provider.dart';
import 'package:store/screens/AdminScreens/home_admin_screen.dart';
import 'package:store/screens/foregot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with NavHelper, ChickData {
  AppLocalizations get localizations => AppLocalizations.of(context)!;
  late TextEditingController emailEditingController;
  late TextEditingController passwordEditingController;

  @override
  void initState() {
    super.initState();
    emailEditingController = TextEditingController();
    passwordEditingController = TextEditingController();
  }

  @override
  void dispose() {
    emailEditingController.dispose();
    passwordEditingController.dispose();
    super.dispose();
  }

  bool loaderBtn = false;
  bool loaderG = false;
  bool loaderGust = false;
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding:
              EdgeInsetsDirectional.only(top: 90.h, start: 16.w, end: 16.w),
          child: Column(
            children: [
              Center(
                  child: SvgPicture.asset(
                'assets/images/icon.svg',
                height: 72.h,
              )),
              SizedBox(height: 16.h),
              Text(
                localizations.welcomeToLafyuu,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 8.h),
              Text(
                localizations.signInToContinue,
                style: TextStyle(
                    color: const Color(0xff9098B1),
                    fontWeight: FontWeight.w300,
                    fontSize: 12.sp),
              ),
              SizedBox(height: 18.h),
              MyTextField(
                editingController: emailEditingController,
                iconData: Icons.email_outlined,
                hint: localizations.yourEmail,
                iSPrefixIcon: true,
                focsNods: true,
                inputType: TextInputType.emailAddress,
                colorHint: const Color(0xff9098B1),
                isBorderStyle: true,
              ),
              SizedBox(height: 8.h),
              MyTextField(
                editingController: passwordEditingController,
                iconData: Icons.lock_open,
                hint: localizations.password,
                iSPrefixIcon: true,
                isPassword: true,
                obscure: obscure,
                inputType: TextInputType.visiblePassword,
                obscureCallBack: (_) => setState(() => obscure = _),
                colorHint: const Color(0xff9098B1),
                isBorderStyle: true,
                onSubmit: (p0) async => await chickData(),
                focsNods: true,
              ),
              SizedBox(height: 16.h),
              MyButton(
                fontWeight: FontWeight.bold,
                text: localizations.signIn,
                colorButton: Theme.of(context).primaryColor,
                sizeText: 14.sp,
                loader: loaderBtn,
                onTap: () async => await chickData(),
              ),
              SizedBox(height: 21.h),
              RowDivider(text: localizations.or),
              SizedBox(height: 16.h),
              loaderG == true
                  ? CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    )
                  : InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      // onTap: () async => await signGoogle(),
                      child: LoginWith(
                          text: localizations.loginWithGoogle,
                          icon: 'assets/icons/googel.svg'),
                    ),
              SizedBox(height: 8.h),
              LoginWith(
                  text: localizations.loginWithFacebook,
                  icon: 'assets/icons/facebook.svg'),
              SizedBox(height: 16.h),
              loaderGust == true
                  ? CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    )
                  : InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () =>
                          jump(context, const ForeGotPasswordScreen(), false),
                      child: Text(
                        localizations.forgotPassword,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizations.dontHaveAccount,
                    style: TextStyle(
                        color: const Color(0xff9098B1),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w200),
                  ),
                  SizedBox(width: 5.w),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () => jump(context, const SignUpScreen(), false),
                    child: Text(
                      localizations.register,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> chickData() async {
    String email = emailEditingController.text.trim();
    String password = passwordEditingController.text.trim();
    if (email.isEmpty) {
      showSnackBar(context, localizations.pleaseEnterYourEmail, true);
    } else if (password.isEmpty) {
      showSnackBar(context, localizations.pleaseEnterYourPassword, true);
    } else {
      try {
        setState(() => loaderBtn = true);
        var userStat = await FbAuth().login(email, password);
        if (userStat == null) throw Exception('Auth Error!');

        /// Save Login
        await CacheController().setter(CacheKeys.loggedIn, true);
        await CacheController().setter(CacheKeys.email, email);
        await CacheController().setter(CacheKeys.password, password);
        await CacheController().setter(CacheKeys.id, userStat.user?.uid);

        /// Get User by Email from Firestore
        var user = await UsersFbController().show(emailEditingController.text);

        if (user == null) throw Exception('User Not Found!');
        var fcm = await FirebaseMessaging.instance.getToken();
        await UsersFbController().update(UserModel(fcm: fcm ?? ''));
        Provider.of<AuthProvider>(context, listen: false).user = user;

        /// getAllFav
        await _fav;

        /// getAllCard
        await _card;
        jump(
            context,
            user.permission == AppPermission.admin.name
                ? const HomeAdminScreen()
                : const HomePage(),
            true);
        showSnackBar(context, localizations.successfullyRegistered, false);
      } catch (e) {
        showSnackBar(context, localizations.accountNotFound, true);
        setState(() => loaderBtn = false);
      }
    }
  }

  Future<void> signGoogle() async {
    await FbSignInController().signInWithGoogle();
    setState(() => loaderG = true);
    jump(context, const HomePage(), true);
    showSnackBar(context, localizations.successfullyRegistered, false);
    setState(() => loaderG = false);
  }

  FavoriteProvider get fav =>
      Provider.of<FavoriteProvider>(context, listen: false);

  CartProvider get card => Provider.of<CartProvider>(context, listen: false);

  Future<void> get _fav async {
    try {
      var data = await FbAddToFavoriteController().getAllFavorite();
      fav.favorites = data;
    } catch (e) {
      ///
    }
  }

  Future<void> get _card async {
    try {
      var data = await FbCartController().getAllCartProduct();
      card.carts = data;
    } catch (e) {
      ///
    }
  }
}
