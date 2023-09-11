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
import 'package:store/helbers/cach_net_work_helper.dart';
import 'package:store/helbers/converter_helper.dart';
import 'package:uuid/uuid.dart';

class OfferViewAdmin extends StatefulWidget {
  final AdsModel? model;

  const OfferViewAdmin({
    Key? key,
    this.model,
  }) : super(key: key);

  @override
  State<OfferViewAdmin> createState() => _OfferViewAdminState();
}

class _OfferViewAdminState extends State<OfferViewAdmin>
    with ChickData, ImagePikerHelper, CacheNetWorkImageHelper, ConverterHelper {
  AppLocalizations get localizations => AppLocalizations.of(context)!;
  late TextEditingController titleEditingController;
  late TextEditingController timeEditingController;

  @override
  void initState() {
    super.initState();
    titleEditingController =
        TextEditingController(text: widget.model?.titel ?? '');
    timeEditingController =
        TextEditingController(text: widget.model?.time ?? '');
    if (widget.model != null) {
      intImage();
    }
  }

  bool convertImage = false;

  Future<void> intImage() async {
    try {
      setState(() => convertImage = true);
      var file = await convertLinkToFile(widget.model?.image?.link ?? '');
      setState(() {
        imageFile = file;
      });
      setState(() => convertImage = false);
    } catch (e) {
      ///
    }
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.model == null
              ? localizations.addOffers.toUpperCase()
              : localizations.editOffer.toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20.sp),
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.symmetric(
                    vertical: 20.h, horizontal: 20.w),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Stack(
                        clipBehavior: Clip.antiAlias,
                        children: [
                          convertImage
                              ? LinearProgressIndicator(
                                  color: Theme.of(context).primaryColor)
                              : Container(
                                  clipBehavior: Clip.antiAlias,
                                  width: 100.h,
                                  height: 100.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.shade300,
                                  ),
                                  child: imageFile != null
                                      ? Image.file(imageFile!,
                                          fit: BoxFit.cover)
                                      : null),
                          PositionedDirectional(
                            end: 0,
                            top: 70,
                            bottom: 0,
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
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
                      MyButton(
                        colorButton: Theme.of(context).primaryColor,
                        text: widget.model == null
                            ? localizations.addOffers
                            : localizations.editOffer,
                        loader: loader,
                        onTap: () async => await addAds(),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> addAds() async {
    String? id = widget.model == null ? const Uuid().v4() : widget.model?.id;
    String titel = titleEditingController.text.trim();
    String time = timeEditingController.text.trim();
    if (imageFile == null) {
      showSnackBar(context, localizations.chooseAtLeastOnePhoto, true);
    } else if (titel.isEmpty) {
      showSnackBar(context, localizations.pleaseEnterTheOffer, true);
    } else if (time.isEmpty) {
      showSnackBar(context, localizations.pleaseEnterTheTimeDisplay, true);
    } else {
      setState(() => loader = true);
      var image = await FbStorageController().insertFile(id!, imageFile!);
      var data = widget.model == null
          ? await FbAdminProductAdsController().insertAds(AdsModel(
              id: id,
              titel: titel,
              time: time,
              image: image,
            ))
          : await FbAdminProductAdsController().upDate(AdsModel(
              id: id,
              titel: titel,
              time: time,
              image: image,
            ));
      setState(() => loader = false);

      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}
