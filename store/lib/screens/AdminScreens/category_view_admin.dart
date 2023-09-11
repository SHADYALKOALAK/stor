import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store/FireBase/Models/category_model.dart';
import 'package:store/FireBase/fb_admin_product_category_controller.dart';
import 'package:store/FireBase/fb_storeg_controller.dart';
import 'package:store/Helbers/chickDataHelber.dart';
import 'package:store/Helbers/image_picker.dart';
import 'package:store/Witgets/my_button.dart';
import 'package:store/Witgets/my_text_filed.dart';
import 'package:store/helbers/cach_net_work_helper.dart';
import 'package:store/helbers/converter_helper.dart';
import 'package:uuid/uuid.dart';

class CategoryViewAdmin extends StatefulWidget {
  final CategoryModel? categoryModel;

  const CategoryViewAdmin({
    Key? key,
    this.categoryModel,
  }) : super(key: key);

  @override
  State<CategoryViewAdmin> createState() => _CategoryViewAdminState();
}

class _CategoryViewAdminState extends State<CategoryViewAdmin>
    with ChickData, ImagePikerHelper, ConverterHelper, CacheNetWorkImageHelper {
  AppLocalizations get localizations => AppLocalizations.of(context)!;
  late TextEditingController nameEditingController;

  @override
  void initState() {
    super.initState();
    nameEditingController =
        TextEditingController(text: widget.categoryModel?.name ?? '');
    if (widget.categoryModel != null) {
      intImage();
    }
  }

  @override
  void dispose() {
    nameEditingController.dispose();
    super.dispose();
  }

  bool convertLoader = false;

  Future<void> intImage() async {
    try {
      setState(() => convertLoader = true);
      var file =
          await convertLinkToFile(widget.categoryModel?.image?.link ?? '');
      setState(() => imageFile = file);
      setState(() => convertLoader = false);
    } catch (e) {
      ///
    }
  }

  bool loader = false;
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.categoryModel == null
              ? localizations.addCategory.toUpperCase()
              : localizations.editCategory.toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Stack(
                clipBehavior: Clip.antiAlias,
                children: [
                  convertLoader
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
                              ? Image.file(imageFile!, fit: BoxFit.cover)
                              : const SizedBox.shrink(),
                        ),
                  PositionedDirectional(
                    end: 0,
                    top: 70,
                    bottom: 0,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 16.r,
                      child: Center(
                        child: IconButton(
                          padding:
                              EdgeInsetsDirectional.only(start: 2.w, top: 2.h),
                          onPressed: () async {
                            var image = await choseImage(ImageSource.gallery);
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
                editingController: nameEditingController,
                hint: localizations.pleaseEnterTheCategoryName,
                isFocus: false,
                colorHint: const Color(0xff9098B1),
                isBorderStyle: true,
                onSubmit: (p0) async => await addCategory(),
              ),
              SizedBox(height: 20.h),
              MyButton(
                onTap: () async => await addCategory(),
                loader: loader,
                colorButton: Theme.of(context).primaryColor,
                text: widget.categoryModel?.name == null
                    ? localizations.addCategory
                    : localizations.editCategory,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addCategory() async {
    String? id = widget.categoryModel == null
        ? const Uuid().v4()
        : widget.categoryModel?.id;
    String name = nameEditingController.text.trim();
    if (imageFile == null) {
      showSnackBar(context, localizations.chooseAtLeastOnePhoto, true);
    } else if (name.isEmpty) {
      showSnackBar(context, localizations.pleaseEnterTheProductName, true);
    } else {
      setState(() => loader = true);
      var image = await FbStorageController().insertFile(id!, imageFile!);
      var data = widget.categoryModel == null
          ? await FbAdminProductCategoryController()
              .insertCategory(CategoryModel(
              id: id,
              image: image,
              name: name,
            ))
          : await FbAdminProductCategoryController().upDate(CategoryModel(
              id: id,
              image: image,
              name: name,
            ));
      if (context.mounted) {
        Navigator.pop(context);
      }
      setState(() => loader = false);
    }
  }
}
