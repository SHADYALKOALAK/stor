// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:store/FireBase/Models/images_model.dart';
import 'package:store/FireBase/Models/product_model.dart';
import 'package:store/FireBase/fb_admin_product_bestSell_controller.dart';
import 'package:store/FireBase/fb_storeg_controller.dart';
import 'package:store/Helbers/chickDataHelber.dart';
import 'package:store/Helbers/image_picker.dart';
import 'package:store/Witgets/my_button.dart';
import 'package:store/Witgets/my_text_filed.dart';
import 'package:uuid/uuid.dart';

class BestSellViewAdmin extends StatefulWidget {
  const BestSellViewAdmin({Key? key}) : super(key: key);

  @override
  State<BestSellViewAdmin> createState() => _BestSellViewAdminState();
}

class _BestSellViewAdminState extends State<BestSellViewAdmin>
    with ChickData, ImagePikerHelper {
  AppLocalizations get localizations => AppLocalizations.of(context)!;
  late TextEditingController titleEditingController;
  late TextEditingController priceEditingController;
  late TextEditingController oldPriceEditingController;
  late TextEditingController offerEditingController;
  late TextEditingController descriptionEditingController;

  @override
  void initState() {
    titleEditingController = TextEditingController();
    priceEditingController = TextEditingController();
    oldPriceEditingController = TextEditingController();
    offerEditingController = TextEditingController();
    descriptionEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    titleEditingController.dispose();
    priceEditingController.dispose();
    oldPriceEditingController.dispose();
    offerEditingController.dispose();
    descriptionEditingController.dispose();
    super.dispose();
  }

  List<File> images = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding:
            EdgeInsetsDirectional.symmetric(vertical: 20.h, horizontal: 20.w),
        child: Column(children: [
          Text(
            localizations.addProduct.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 30.sp),
          ),
          SizedBox(height: 10.h),
          InkWell(
            onTap: () async {
              var image = await choseMaltyImage();
              images.addAll(image);
              setState(() {});
            },
            child: Container(
              width: double.infinity,
              height: 80.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 1),
              ),
              child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 10.w, vertical: 10.h),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          width: 80.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: Colors.grey.shade400),
                          clipBehavior: Clip.antiAlias,
                          child: images != null
                              ? Image.file(File(images[index].path),
                                  fit: BoxFit.cover)
                              : null,
                        ),
                        PositionedDirectional(
                          end: -10,
                          top: 1,
                          bottom: -40,
                          child: IconButton(
                            onPressed: () =>
                                setState(() => images.remove(images[index])),
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(width: 10.w),
                  itemCount: images.length),
            ),
          ),
          SizedBox(height: 10.h),
          MyTextField(
            editingController: titleEditingController,
            colorHint: const Color(0xff9098B1),
            hint: localizations.pleaseEnterTheProductName,
            isFocus: false,
            isBorderStyle: true,
          ),
          SizedBox(
            height: 10.h,
          ),
          MyTextField(
            editingController: priceEditingController,
            colorHint: const Color(0xff9098B1),
            hint: localizations.pleaseEnterThePrice,
            isFocus: false,
            phoneText: true,
            isBorderStyle: true,
          ),
          SizedBox(height: 10.h),
          MyTextField(
            editingController: oldPriceEditingController,
            colorHint: const Color(0xff9098B1),
            phoneText: true,
            hint: localizations.pleaseEnterTheOldPrice,
            isFocus: false,
            isBorderStyle: true,
          ),
          SizedBox(
            height: 20.h,
          ),
          MyTextField(
            editingController: offerEditingController,
            colorHint: const Color(0xff9098B1),
            hint: localizations.pleaseEnterTheOffer,
            isFocus: false,
            isBorderStyle: true,
          ),
          SizedBox(height: 10.h),
          MyTextField(
            editingController: descriptionEditingController,
            colorHint: const Color(0xff9098B1),
            hint: localizations.pleaseEnterTheDescription,
            isFocus: false,
            lines: 5,
            isBorderStyle: true,
          ),
          SizedBox(height: 10.h),
          loader == true
              ? CircularProgressIndicator(color: Theme.of(context).primaryColor)
              : InkWell(
                  onTap: () async => await chickData(),
                  child: MyButton(
                    text: localizations.addProduct,
                    sizeText: 15.sp,
                    colorButton: Theme.of(context).primaryColor,
                  ),
                ),
        ]),
      ),
    );
  }

  bool loader = false;

  Future<void> chickData() async {
    String id = const Uuid().v4();
    String title = titleEditingController.text.trim();
    String price = priceEditingController.text.trim();
    String oldPrice = oldPriceEditingController.text.trim();
    String offer = offerEditingController.text.trim();
    String description = descriptionEditingController.text.trim();
    List<ImagesModel> imagesLinks = [];
    if (title.isEmpty) {
      showSnackBar(
          context, localizations.pleaseEnterTheProductName, Colors.red);
    } else if (price.isEmpty) {
      showSnackBar(context, localizations.pleaseEnterThePrice, Colors.red);
    } else if (oldPrice.isEmpty) {
      showSnackBar(context, localizations.pleaseEnterTheOldPrice, Colors.red);
    } else if (offer.isEmpty) {
      showSnackBar(context, localizations.pleaseEnterTheOffer, Colors.red);
    } else if (description.isEmpty) {
      showSnackBar(
          context, localizations.pleaseEnterTheDescription, Colors.red);
    } else {
      setState(() => loader = true);
      for (File item in images) {
        var link =
        await FbStorageController().insertFile('imageProduct/$id', item);
        if (link != null) {
          imagesLinks.add(link);
        }
      }
      await FbAdminProductBestSellerController().insert(
        ProductModel(
            id: id,
            titel: title,
            offer: offer,
            oldPrice: oldPrice,
            price: price,
            images: imagesLinks,
            description: description
        ),
      );
      setState(() => loader = false);
      setState(() {
        titleEditingController.text = '';
        priceEditingController.text = '';
        oldPriceEditingController.text = '';
        offerEditingController.text = '';
        descriptionEditingController.text = '';
        images.clear();
      });
    }
  }
}
