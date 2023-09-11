// ignore_for_file: unnecessary_null_comparison
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:store/FireBase/Models/category_model.dart';
import 'package:store/FireBase/Models/images_model.dart';
import 'package:store/FireBase/Models/product_model.dart';
import 'package:store/FireBase/fb_product_controller.dart';
import 'package:store/FireBase/fb_admin_product_category_controller.dart';
import 'package:store/FireBase/fb_storeg_controller.dart';
import 'package:store/Helbers/chickDataHelber.dart';
import 'package:store/Helbers/image_picker.dart';
import 'package:store/Witgets/my_button.dart';
import 'package:store/Witgets/my_text_filed.dart';
import 'package:store/helbers/cach_net_work_helper.dart';
import 'package:store/helbers/converter_helper.dart';
import 'package:store/helbers/my_drop_don.dart';
import 'package:uuid/uuid.dart';

class AddProducts extends StatefulWidget {
  final ProductModel? model;
  final bool? checkBoxBestSell;
  final bool? checkBoxPurpler;

  const AddProducts({
    Key? key,
    this.model,
    this.checkBoxBestSell,
    this.checkBoxPurpler,
  }) : super(key: key);

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts>
    with ChickData, ImagePikerHelper, ConverterHelper, CacheNetWorkImageHelper {
  AppLocalizations get localizations => AppLocalizations.of(context)!;
  late TextEditingController titleEditingController;
  late TextEditingController priceEditingController;
  late TextEditingController oldPriceEditingController;
  late TextEditingController offerEditingController;
  late TextEditingController countEditingController;
  late TextEditingController descriptionEditingController;

  List<CategoryModel>? category = [];

  @override
  void initState() {
    super.initState();
    titleEditingController =
        TextEditingController(text: widget.model?.titel ?? '');
    priceEditingController =
        TextEditingController(text: widget.model?.price ?? '');
    oldPriceEditingController =
        TextEditingController(text: widget.model?.oldPrice ?? '');
    offerEditingController =
        TextEditingController(text: widget.model?.offer ?? '');
    descriptionEditingController =
        TextEditingController(text: widget.model?.description ?? '');
    countEditingController =
        TextEditingController(text: widget.model?.count.toString() ?? '');
    _getCategory;
    if (widget.model != null) {
      intImages();
    }
  }

  List<File> images = [];
  bool convertImages = false;
  CategoryModel? selectedCategoryModel;

  Future<void> intImages() async {
    try {
      setState(() => convertImages = true);
      for (var item in widget.model!.images!) {
        var image = await convertLinkToFile(item.link);
        setState(() {
          images.add(image);
        });
        setState(() => convertImages = false);
      }
    } catch (e) {
      ///
    }
  }

  Future<void> get _getCategory async {
    try {
      var data = await FbAdminProductCategoryController().get();
      category = data;

      selectedCategoryModel = widget.model == null
          ? null
          : (category ?? [])
              .firstWhere((element) => element.id == widget.model?.idCategory);
    } catch (e) {
      category = [];
    }
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.model == null
              ? localizations.addProduct.toUpperCase()
              : localizations.editProduct.toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20.sp),
        ),
      ),
      body: Padding(
        padding:
            EdgeInsetsDirectional.symmetric(vertical: 20.h, horizontal: 20.w),
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: [
            Column(children: [
              SizedBox(height: 10.h),
              InkWell(
                  onTap: () async {
                    var image = await choseMaltyImage();
                    images.addAll(image);
                    setState(() {});
                  },
                  child: convertImages
                      ? LinearProgressIndicator(
                          color: Theme.of(context).primaryColor)
                      : Container(
                          width: double.infinity,
                          height: 90.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1),
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
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          color: Colors.grey.shade400),
                                      clipBehavior: Clip.antiAlias,
                                      child: images != null
                                          ? Image.file(File(images[index].path),
                                              fit: BoxFit.cover)
                                          : widget.model == null
                                              ? widget.model?.images != null
                                                  ? cacheImage(widget.model
                                                      ?.images?[index].link)
                                                  : null
                                              : const CircularProgressIndicator(),
                                    ),
                                    PositionedDirectional(
                                      end: -10,
                                      top: 1,
                                      bottom: -40,
                                      child: IconButton(
                                        onPressed: () => setState(
                                            () => images.remove(images[index])),
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 10.w),
                              itemCount: images.length),
                        )),
              SizedBox(height: 10.h),
              MyTextField(
                editingController: titleEditingController,
                colorHint: const Color(0xff9098B1),
                hint: localizations.pleaseEnterTheProductName,
                isFocus: false,
                isBorderStyle: true,
              ),
              SizedBox(height: 10.h),
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
                height: 10.h,
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
                editingController: countEditingController,
                colorHint: const Color(0xff9098B1),
                hint: localizations.enterTheProductQuantity,
                isFocus: false,
                phoneText: true,
                inputType: TextInputType.number,
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
              MyDropDon(
                value: selectedCategoryModel,
                hint: localizations.category,
                list: category,
                callBack: (_) => setState(() => selectedCategoryModel = _),
              ),
              Row(
                children: [
                  Checkbox(
                    value: widget.checkBoxPurpler == true ? true : check,
                    onChanged: (value) =>
                        setState(() => check = value ?? false),
                  ),
                  Text(localizations.purpler),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value:
                        widget.checkBoxBestSell == true ? true : checkBestSell,
                    onChanged: (value) =>
                        setState(() => checkBestSell = value ?? false),
                  ),
                  Text(localizations.bestSeller),
                ],
              ),
              MyButton(
                text: widget.model == null
                    ? localizations.addProduct
                    : localizations.editProduct,
                onTap: () async => await chickData(),
                sizeText: 15.sp,
                loader: loader,
                colorButton: Theme.of(context).primaryColor,
              ),
            ])
          ],
        ),
      ),
    );
  }

  bool check = false;
  bool checkBestSell = false;
  bool loader = false;

  Future<void> chickData() async {
    String? id = widget.model == null ? const Uuid().v4() : widget.model?.id;
    String title = titleEditingController.text.trim();
    String price = priceEditingController.text.trim();
    String oldPrice = oldPriceEditingController.text.trim();
    String offer = offerEditingController.text.trim();
    String count = countEditingController.text.trim();
    String description = descriptionEditingController.text.trim();
    List<ImagesModel> imagesLinks = [];
    if (images.isEmpty) {
      showSnackBar(context, localizations.chooseAtLeastOnePhoto, true);
    } else if (title.isEmpty) {
      showSnackBar(context, localizations.pleaseEnterTheProductName, true);
    } else if (price.isEmpty) {
      showSnackBar(context, localizations.pleaseEnterThePrice, true);
    } else if (oldPrice.isEmpty) {
      showSnackBar(context, localizations.pleaseEnterTheOldPrice, true);
    } else if (offer.isEmpty) {
      showSnackBar(context, localizations.pleaseEnterTheOffer, true);
    } else if (count.isEmpty) {
      showSnackBar(context, localizations.enterTheProductQuantity, true);
    } else if (description.isEmpty) {
      showSnackBar(context, localizations.pleaseEnterTheDescription, true);
    } else if (selectedCategoryModel == null) {
      showSnackBar(context, localizations.selectTheCategory, true);
    } else {
      setState(() => loader = true);
      for (File item in images) {
        var link =
            await FbStorageController().insertFile('imageProduct/$id', item);
        if (link != null) {
          imagesLinks.add(link);
        }
      }
      widget.model == null
          ? await FbProductController().insert(
              ProductModel(
                id: id,
                titel: title,
                offer: offer,
                oldPrice: oldPrice,
                price: price,
                images: imagesLinks,
                count: int.parse(count),
                idCategory: selectedCategoryModel?.id ?? '',
                isCategory: await isCategoryProducts,
                description: description,
              ),
            )
          : await FbProductController().upDate(ProductModel(
              id: id,
              titel: title,
              offer: offer,
              oldPrice: oldPrice,
              price: price,
              count: int.parse(count),
              images: imagesLinks,
              isCategory: widget.checkBoxPurpler == true
                  ? 'purplerProducts'
                  : 'bestSellProducts',
              idCategory: selectedCategoryModel?.id ?? '',
              description: description,
            ));
      setState(() => loader = false);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<String> get isCategoryProducts async {
    String isCategory = '';
    if (checkBestSell == true) {
      isCategory = 'bestSellProducts';
      return isCategory;
    } else {
      return isCategory = 'purplerProducts';
    }
  }
}
