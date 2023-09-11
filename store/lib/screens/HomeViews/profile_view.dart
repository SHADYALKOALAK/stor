// ignore_for_file: unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:store/FireBase/fb_auth.dart';
import 'package:store/Helbers/nav_helber.dart';
import 'package:store/Screens/profile_screen.dart';
import 'package:store/Screens/splash_screen.dart';
import 'package:store/Witgets/my_button.dart';
import 'package:store/Witgets/my_list_tile.dart';
import 'package:store/cache/cache_controller.dart';
import 'package:store/enums/enums.dart';
import 'package:store/providers/auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:store/providers/card_provider.dart';
import 'package:store/providers/favorite_provider.dart';
import 'package:store/providers/language_provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with NavHelper {
  AppLocalizations get localizations => AppLocalizations.of(context)!;

  AuthProvider get _auth => Provider.of<AuthProvider>(context, listen: false);
  bool switchLang = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return Consumer<LanguageProvider>(
          builder: (context, value, child) {
            return Scaffold(
                body: Padding(
              padding: EdgeInsetsDirectional.only(
                  top: 120.h, end: 16.w, start: 16.w),
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  /// image User View
                  Container(
                    height: 100.h,
                    width: 100.h,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: _auth.user?.image != null
                        ? CachedNetworkImage(
                            imageUrl: auth.user?.image?.link ?? '',
                            fit: BoxFit.contain,
                          )
                        : const SizedBox.shrink(),
                  ),
                  SizedBox(height: 40.h),

                  ///
                  ListTile(
                    title: Text(
                      localizations.updateProfile,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    leading: Icon(
                      Icons.person_outline_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    onTap: () => jump(context, const ProfileScreen(), false),
                    trailing: Icon(Icons.arrow_forward_ios,
                        color: Theme.of(context).primaryColor),
                  ),

                  /// Change Lang
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 20.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyListTile(
                            icon: Icons.language,
                            text: localizations.changeLanguage,
                            // onTap: () =>
                          ),
                          Switch(
                            value: switchLang,
                            onChanged: (_) {
                              setState(() => switchLang = _);
                              value.changeLanguage();
                            },
                          )
                        ],
                      )),

                  /// log Out
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () => _showBottomSheet(),
                    child: ListTile(
                        title: Text(
                          localizations.logout,
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.red,
                        )),
                  ),
                ],
              ),
            ));
          },
        );
      },
    );
  }

  FavoriteProvider get fav =>
      Provider.of<FavoriteProvider>(context, listen: false);

  CartProvider get card => Provider.of<CartProvider>(context, listen: false);

  Future<void> get _logout async {
    await FbAuth().logout();
    await CacheController().setter(CacheKeys.loggedIn, false);
    fav.favorites = [];
    card.carts = [];
    if (context.mounted) {
      jump(context, const SplashScreen(), true);
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(maxHeight: 260.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 10.h),
          child: Column(
            children: [
              Divider(
                color: Colors.red,
                height: 20.h,
                thickness: 5,
                endIndent: 150.w,
                indent: 150.w,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                localizations.logout,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold),
              ),
              Divider(
                indent: 20.w,
                endIndent: 20.w,
                height: 20.h,
                thickness: 1,
                color: Colors.grey.shade300,
              ),
              Text(
                localizations.areYouSureToSignOut,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              MyButton(
                text: localizations.yes,
                colorButton: Colors.red,
                onTap: () {
                  FbAuth().logout;
                  _logout;
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              MyButton(
                text: localizations.no,
                colorButton: Theme.of(context).primaryColor,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
