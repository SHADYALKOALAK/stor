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
import 'package:uuid/uuid.dart';

class CategoryViewAdmin extends StatefulWidget {
  const CategoryViewAdmin({Key? key}) : super(key: key);

  @override
  State<CategoryViewAdmin> createState() => _CategoryViewAdminState();
}

class _CategoryViewAdminState extends State<CategoryViewAdmin>
    with ChickData, ImagePikerHelper {
  AppLocalizations get localizations => AppLocalizations.of(context)!;
  late TextEditingController nameEditingController;

  @override
  void initState() {
    nameEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameEditingController.dispose();
    super.dispose();
  }

  bool loader = false;
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Text(
              localizations.addCategory.toUpperCase(),
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
                      ? Image.file(imageFile!, fit: BoxFit.cover)
                      : const SizedBox.shrink(),
                ),
                PositionedDirectional(
                  end: 0,
                  top: 80,
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
            ),
            SizedBox(height: 20.h),
            loader == true
                ? CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  )
                : InkWell(
                    onTap: () async => await addCategory(),
                    child: MyButton(
                      colorButton: Theme.of(context).primaryColor,
                      text: localizations.addCategory,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> addCategory() async {
    String id = const Uuid().v4();
    String name = nameEditingController.text.trim();
    if (name.isEmpty) {
      showSnackBar(
          context, localizations.pleaseEnterTheProductName, Colors.red);
    } else {
      setState(() => loader = true);
      var image = await FbStorageController().insertFile(id, imageFile!);
      var data =
          await FbAdminProductCategoryController().insertCategory(CategoryModel(
        id: id,
        image: image,
        name: name,
      ));
      setState(() => loader = false);
      setState(() {
        nameEditingController.text = '';
        imageFile!.stat();
      });
    }
  }
}
