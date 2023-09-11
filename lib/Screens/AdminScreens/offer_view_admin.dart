import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store/FireBase/Models/ads_model.dart';
import 'package:store/FireBase/fb_admin_product_ads_controller.dart';
import 'package:store/FireBase/fb_storeg_controller.dart';
import 'package:store/Helbers/chickDataHelber.dart';
import 'package:store/Helbers/image_picker.dart';
import 'package:store/Witgets/my_button.dart';
import 'package:store/Witgets/my_text_filed.dart';
import 'package:uuid/uuid.dart';

class OfferViewAdmin extends StatefulWidget {
  const OfferViewAdmin({Key? key}) : super(key: key);

  @override
  State<OfferViewAdmin> createState() => _OfferViewAdminState();
}

class _OfferViewAdminState extends State<OfferViewAdmin>
    with ChickData, ImagePikerHelper {
  AppLocalizations get localizations => AppLocalizations.of(context)!;
  late TextEditingController titleEditingController;
  late TextEditingController timeEditingController;

  @override
  void initState() {
    titleEditingController = TextEditingController();
    timeEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    titleEditingController.dispose();
    timeEditingController.dispose();
    super.dispose();
  }

  File? imageFile;
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.symmetric(
                vertical: 20.h, horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    localizations.addOffers.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 30.sp),
                  ),
                  SizedBox(height: 20.h),
                  Stack(
                    clipBehavior: Clip.antiAlias,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        width: 100.h,
                        height: 100.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                        ),
                        child: imageFile != null
                            ? Image.file(
                                imageFile!,
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      PositionedDirectional(
                        end: 0,
                        top: 80,
                        bottom: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.orange,
                          radius: 16.r,
                          child: Center(
                            child: IconButton(
                              padding: EdgeInsetsDirectional.only(
                                  start: 2.w, top: 2.h),
                              onPressed: () async {
                                var image =
                                    await choseImage(ImageSource.gallery);
                                imageFile = image;
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  MyTextField(
                    editingController: titleEditingController,
                    hint: localizations.pleaseEnterTheDisplayName,
                    isFocus: false,
                    colorHint: const Color(0xff9098B1),
                    isBorderStyle: true,
                  ),
                  SizedBox(height: 20.h),
                  MyTextField(
                    editingController: timeEditingController,
                    colorHint: const Color(0xff9098B1),
                    hint: localizations.pleaseEnterTheTimeDisplay,
                    isFocus: false,
                    isBorderStyle: true,
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(height: 20.h),
                  loader == true
                      ? CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        )
                      : InkWell(
                          onTap: () async => await addAds(),
                          child: MyButton(
                            colorButton: Theme.of(context).primaryColor,
                            text: localizations.addOffers,
                          ),
                        ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> addAds() async {
    String id = const Uuid().v4();
    String titel = titleEditingController.text.trim();
    String time = timeEditingController.text.trim();
    if (titel.isEmpty) {
      showSnackBar(context, localizations.pleaseEnterTheOffer, Colors.red);
    } else if (time.isEmpty) {
      showSnackBar(
          context, localizations.pleaseEnterTheTimeDisplay, Colors.red);
    } else {
      setState(() => loader = true);
      var image = await FbStorageController().insertFile(id, imageFile!);
      var data = await FbAdminProductAdsController().insertAds(AdsModel(
        id: id,
        titel: titel,
        time: time,
        image: image,
      ));
      setState(() => loader = false);
    }
  }
}
