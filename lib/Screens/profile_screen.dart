import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:store/FireBase/Models/images_model.dart';
import 'package:store/FireBase/Models/user_model.dart';
import 'package:store/FireBase/fb_storeg_controller.dart';
import 'package:store/FireBase/users_fb_controller.dart';
import 'package:store/Helbers/image_picker.dart';
import 'package:store/Witgets/my_button.dart';
import 'package:store/Witgets/my_text_filed.dart';
import 'package:store/providers/auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with ImagePikerHelper {
  late TextEditingController nameEditingController;
  late TextEditingController emailEditingController;
  late TextEditingController passwordEditingController;

  AuthProvider get _auth => Provider.of<AuthProvider>(context, listen: false);

  AppLocalizations get localizations => AppLocalizations.of(context)!;

  bool obscure1 = false;

  @override
  void initState() {
    super.initState();
    nameEditingController =
        TextEditingController(text: _auth.user?.fullName ?? '');
    emailEditingController =
        TextEditingController(text: _auth.user?.email ?? '');
    passwordEditingController =
        TextEditingController(text: _auth.user?.password ?? '');
  }

  @override
  void dispose() {
    nameEditingController.dispose();
    emailEditingController.dispose();
    passwordEditingController.dispose();
    super.dispose();
  }

  File? profileImage;
  bool obscure = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(localizations.updateProfile.toUpperCase()),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 100.h,
                    width: 100.h,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: profileImage != null
                        ? Image.file(profileImage!, fit: BoxFit.cover)
                        : _auth.user?.image != null
                            ? CachedNetworkImage(
                                imageUrl: _auth.user?.image?.link ?? '',
                                fit: BoxFit.cover,
                              )
                            : const SizedBox.shrink(),
                  ),
                  PositionedDirectional(
                    bottom: 0,
                    end: 0,
                    child: InkWell(
                      onTap: () async {
                        var file = await choseImage(ImageSource.gallery);
                        if (file != null) {
                          setState(() => profileImage = file);
                        }
                      },
                      child: CircleAvatar(
                        radius: 18.h,
                        child: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              MyTextField(
                editingController: nameEditingController,
                iconData: Icons.person_outline_outlined,
                hint: localizations.fullName,
                iSPrefixIcon: true,
                colorHint: const Color(0xff9098B1),
                isBorderStyle: true,
                focsNods: true,
              ),
              SizedBox(height: 20.h),
              MyTextField(
                editingController: emailEditingController,
                iconData: Icons.email_outlined,
                hint: localizations.yourEmail,
                iSPrefixIcon: true,
                colorHint: const Color(0xff9098B1),
                isBorderStyle: true,
                focsNods: true,
              ),
              SizedBox(height: 20.h),
              MyTextField(
                editingController: passwordEditingController,
                iconData: Icons.lock_open,
                hint: localizations.password,
                iSPrefixIcon: true,
                isPassword: true,
                obscure: obscure1,
                obscureCallBack: (_) => setState(() => obscure1 = _),
                colorHint: const Color(0xff9098B1),
                isBorderStyle: true,
                focsNods: true,
              ),
              SizedBox(height: 20.h),
              loading == true
                  ? CircularProgressIndicator(
                      color: Theme.of(context).primaryColor)
                  : InkWell(
                      onTap: () async => await _performUpdate,
                      child: MyButton(
                        text: localizations.updateProfile,
                        colorButton: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  bool loading = false;

  Future<void> get _performUpdate async {
    if (_checkDate) {
      await _update;
    }
  }

  Future<void> get _update async {
    setState(() => loading = true);
    try {
      /// Storage
      var imageModel = await FbStorageController()
          .insertFile('users/${_auth.user?.id}', profileImage!);

      /// Firestore
      var status = await UsersFbController().update(userModel(imageModel));
      _auth.user = userModel(imageModel);

      if (status) {
        if (context.mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      ///
    }
    setState(() => loading = false);
  }

  UserModel userModel(ImagesModel? imageModel) {
    return UserModel(
      email: emailEditingController.text,
      password: passwordEditingController.text,
      fullName: nameEditingController.text,
      id: _auth.user?.id,
      image: imageModel,
    );
  }

  bool get _checkDate {
    return true;
  }
}
