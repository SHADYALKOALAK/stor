// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store/FireBase/Models/user_model.dart';
import 'package:store/FireBase/fb_auth.dart';
import 'package:store/FireBase/users_fb_controller.dart';
import 'package:store/Helbers/chickDataHelber.dart';
import 'package:store/Witgets/my_button.dart';
import 'package:store/Witgets/my_text_filed.dart';
import 'package:store/enums/enums.dart';
import 'package:store/helbers/reg_exp.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with ChickData, ChickValidData {
  AppLocalizations get localizations => AppLocalizations.of(context)!;
  late TextEditingController fullNameEditingController;
  late TextEditingController emailEditingController;
  late TextEditingController passwordEditingController;
  late TextEditingController cPasswordEditingController;

  @override
  void initState() {
    super.initState();
    fullNameEditingController = TextEditingController();
    emailEditingController = TextEditingController();
    passwordEditingController = TextEditingController();
    cPasswordEditingController = TextEditingController();
  }

  @override
  void dispose() {
    fullNameEditingController.dispose();
    emailEditingController.dispose();
    passwordEditingController.dispose();
    cPasswordEditingController.dispose();
    super.dispose();
  }

  bool loader = false;
  bool obscure = false;
  bool obscure2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsetsDirectional.only(top: 90.h, start: 16.w, end: 16.w),
        child: Column(
          children: [
            Center(
                child: SvgPicture.asset(
              'assets/images/icon.svg',
              height: 72.h,
            )),
            SizedBox(height: 16.h),
            Text(
              localizations.letGetStarted,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 8.h),
            Text(
              localizations.createAnNewAccount,
              style: TextStyle(
                  color: const Color(0xff9098B1),
                  fontWeight: FontWeight.w300,
                  fontSize: 12.sp),
            ),
            SizedBox(height: 28.h),
            MyTextField(
              editingController: fullNameEditingController,
              iconData: Icons.person_outline_outlined,
              hint: localizations.fullName,
              iSPrefixIcon: true,
              fontWeight: FontWeight.w100,
              colorHint: const Color(0xff9098B1),
              isBorderStyle: true,
              inputType: TextInputType.name,
            ),
            SizedBox(height: 8.h),
            MyTextField(
              editingController: emailEditingController,
              iconData: Icons.email_outlined,
              hint: localizations.yourEmail,
              iSPrefixIcon: true,
              colorHint: const Color(0xff9098B1),
              isBorderStyle: true,
              fontWeight: FontWeight.w100,
              inputType: TextInputType.emailAddress,
            ),
            SizedBox(height: 8.h),
            MyTextField(
              editingController: passwordEditingController,
              iconData: Icons.lock_open,
              hint: localizations.password,
              iSPrefixIcon: true,
              fontWeight: FontWeight.w100,
              colorHint: const Color(0xff9098B1),
              isPassword: true,
              inputType: TextInputType.visiblePassword,
              obscure: obscure,
              obscureCallBack: (_) => setState(() => obscure = _),
              isBorderStyle: true,
            ),
            SizedBox(height: 8.h),
            MyTextField(
              editingController: cPasswordEditingController,
              iconData: Icons.lock_open,
              hint: localizations.passwordAgain,
              iSPrefixIcon: true,
              fontWeight: FontWeight.w100,
              colorHint: const Color(0xff9098B1),
              isPassword: true,
              inputType: TextInputType.visiblePassword,
              obscure: obscure2,
              onSubmit: (p0) async => await chickData(),
              obscureCallBack: (_) => setState(() => obscure2 = _),
              isBorderStyle: true,
            ),
            SizedBox(
              height: 20.h,
            ),
            MyButton(
              text: localizations.signUp,
              colorButton: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              sizeText: 14.sp,
              loader: loader,
              onTap: () async => await chickData(),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  localizations.haveAccount,
                  style: TextStyle(
                      color: const Color(0xff9098B1),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w200),
                ),
                SizedBox(width: 5.w),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    localizations.signIn,
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
    ));
  }

  Future<void> chickData() async {
    String fullName = fullNameEditingController.text.trim();
    String email = emailEditingController.text.trim();
    String password = passwordEditingController.text.trim();
    String cPassword = cPasswordEditingController.text.trim();
    if (fullName.isEmpty) {
      showSnackBar(context, localizations.pleaseEnterYourFullName, true);
    } else if (email.isEmpty) {
      showSnackBar(context, localizations.pleaseEnterYourEmail, true);
    } else if (password.isEmpty) {
      showSnackBar(context, localizations.pleaseEnterYourPassword, true);
    } else if (cPassword.isEmpty) {
      showSnackBar(context, localizations.pleaseEnterYourConfirmPassword, true);
    } else if (cPassword != password) {
      showSnackBar(context, localizations.makeSureThePasswordMatches, true);
    } else if (!isValidEmail(email)) {
      showSnackBar(context, localizations.pleaseEnterCorrectEmail, true);
    } else if (password.length < 6) {
      showSnackBar(
          context, localizations.passwordMusterLongerThanCharacters, true);
    } else {
      setState(() => loader = true);
      var user = await FbAuth().createUser(email, password);
      if (user != null) {
        await UsersFbController().create(
          UserModel(
            id: user.user?.uid,
            fullName: fullName,
            email: email,
            password: password,
            permission: AppPermission.user.name,
          ),
        );
        Navigator.pop(context);
        setState(() => loader = false);
      } else {
        showSnackBar(context, localizations.theAccountAlreadyExists, true);
        setState(() => loader = false);
      }
    }
  }
}
