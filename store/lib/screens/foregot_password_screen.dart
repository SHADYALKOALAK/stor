import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:store/FireBase/fb_auth.dart';
import 'package:store/Helbers/chickDataHelber.dart';
import 'package:store/Witgets/my_button.dart';
import 'package:store/Witgets/my_text_filed.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:store/helbers/reg_exp.dart';

class ForeGotPasswordScreen extends StatefulWidget {
  const ForeGotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForeGotPasswordScreen> createState() => _ForeGotPasswordScreenState();
}

class _ForeGotPasswordScreenState extends State<ForeGotPasswordScreen>
    with ChickData, ChickValidData {
  late TextEditingController emailEditingController;

  AppLocalizations get localizations => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    emailEditingController = TextEditingController();
  }

  @override
  void deactivate() {
    emailEditingController.dispose();
    super.deactivate();
  }

  bool loader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsetsDirectional.only(start: 20.w, end: 20.w, top: 100.h),
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Text(
            localizations.pleaseEnterYourEmailSoPassword,
            style: TextStyle(
                color: const Color(0xff9098B1),
                fontSize: 18.sp,
                fontWeight: FontWeight.w200),
          ),
          SizedBox(height: 20.h),
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
          SizedBox(height: 20.h),
          MyButton(
            fontWeight: FontWeight.bold,
            text: localizations.forgotPassword,
            colorButton: Theme.of(context).primaryColor,
            loader: loader,
            sizeText: 14.sp,
            onTap: () async => await foreGotPassword(),
            // loader: loaderBtn,
          ),
        ],
      ),
    );
  }

  Future<void> foreGotPassword() async {
    if (emailEditingController.text.isEmpty) {
      showSnackBar(context, localizations.pleaseEnterYourEmail, true);
    } else if (!isValidEmail(emailEditingController.text)) {
      showSnackBar(context, localizations.pleaseEnterCorrectEmail, true);
    } else {
      try {
        setState(() => loader = true);
        await FbAuth()
            .foreGetPassword(email: emailEditingController.text.trim());
        setState(() => loader = false);
        if (context.mounted) {
          Navigator.pop(context);
          showSnackBar(
              context, localizations.checkYourGmail,
              false);
        }
      } catch (e) {
        ///
      }
    }
    setState(() => loader = false);
  }
}
