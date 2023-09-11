import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:store/FireBase/Models/product_model.dart';
import 'package:store/FireBase/fb_add_to_favorite_controller.dart';
import 'package:store/FireBase/fb_cart_controller.dart';
import 'package:store/FireBase/fb_product_controller.dart';
import 'package:store/Helbers/chickDataHelber.dart';
import 'package:store/Helbers/nav_helber.dart';
import 'package:store/Screens/view_product_mage.dart';
import 'package:store/Witgets/my_button.dart';
import 'package:store/cache/cache_controller.dart';
import 'package:store/enums/enums.dart';
import 'package:store/fireBase/Models/cart_model.dart';
import 'package:store/fireBase/Models/favorite+model.dart';
import 'package:store/providers/auth_provider.dart';
import 'package:store/providers/favorite_provider.dart';
import 'package:uuid/uuid.dart';


class ProductDetails extends StatefulWidget {
  final ProductModel model;

  const ProductDetails({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails>
    with NavHelper, ChickData {
  AppLocalizations get localizations => AppLocalizations.of(context)!;
  int counter = 1;

  AuthProvider get auth => Provider.of<AuthProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, FavoriteProvider>(
      builder: (context, value, fav, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_sharp),
              color: const Color(0xff9098B1),
            ),
            title: Text(
              widget.model.titel ?? '',
              style: TextStyle(
                  color: const Color(0xff223263),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  textBaseline: TextBaseline.alphabetic,
                  fontSize: 16.sp),
              textAlign: TextAlign.center,
            ),
          ),
          body: Padding(
            padding: EdgeInsetsDirectional.symmetric(
                vertical: 16.h, horizontal: 16.w),
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [buildListProducts(fav)],
            ),
          ),
        );
      },
    );
  }

  Widget buildListProducts(FavoriteProvider favoriteProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.model.images?.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10.w, crossAxisSpacing: 10.h, crossAxisCount: 2),
          itemBuilder: (context, index) {
            return widget.model.images == null
                ? CircularProgressIndicator(
                    color: Theme.of(context).primaryColor)
                : InkWell(
                    onTap: () => jump(
                        context,
                        ViewProductImage(
                            image: widget.model.images?[index].link),
                        false),
                    child: Container(
                        clipBehavior: Clip.antiAlias,
                        width: double.infinity,
                        height: 200.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(
                              color: const Color(0xff9098B1).withOpacity(0.5),
                              strokeAlign: 0.5),
                        ),
                        child: widget.model.images?[index].link != null
                            ? Padding(
                                padding: EdgeInsetsDirectional.all(5.r),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      widget.model.images?[index].link ?? '',
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const SizedBox.shrink()),
                  );
          },
        ),
        SizedBox(height: 40.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(widget.model.titel!,
                  style: TextStyle(
                      color: const Color(0xff223263),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      textBaseline: TextBaseline.ideographic,
                      fontSize: 22.sp)),
            ),
            IconButton(
              onPressed: () async {
                var status = await FbAddToFavoriteController().toggle(
                    context,
                    FavoriteModel(
                      id: const Uuid().v4(),
                      idUser: CacheController().getter(CacheKeys.id),
                      productModel: widget.model,
                      timestamp: Timestamp.now(),
                    ));
                if (status && context.mounted) {
                  showSnackBar(
                      context,
                      localizations.theOperationWasCompletedSuccessfully,
                      false);
                }
              },
              icon: Icon(
                favoriteProvider.checkFavorite(widget.model)
                    ? Icons.favorite
                    : Icons.favorite_outline,
                color: favoriteProvider.checkFavorite(widget.model)
                    ? Colors.red
                    : Colors.grey,
              ),
            )
          ],
        ),
        Container(
          padding:
              EdgeInsetsDirectional.symmetric(horizontal: 2.w, vertical: 2.h),
          width: 105.w,
          height: 24.h,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1.w, color: const Color(0xff9098B1).withOpacity(.2)),
              borderRadius: BorderRadiusDirectional.circular(5.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 20.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(5.r),
                    color: const Color(0xff9098B1).withOpacity(.5)),
                child: InkWell(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () => add(),
                  child: const Center(child: Text('+')),
                ),
              ),
              Text(
                counter.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    color: Colors.black),
              ),
              Container(
                width: 20.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(5.r),
                    color: const Color(0xff9098B1).withOpacity(.5)),
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () => subtract(),
                  child: const Center(child: Text('-')),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Text(localizations.theNewPrice,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    textBaseline: TextBaseline.ideographic,
                    fontSize: 25.sp)),
            SizedBox(width: 10.h),
            Text(': \$${widget.model.price!}',
                style: TextStyle(
                    color: const Color(0xff223263),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    textBaseline: TextBaseline.ideographic,
                    fontSize: 25.sp)),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Text(localizations.oldPrice,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    textBaseline: TextBaseline.ideographic,
                    fontSize: 25.sp)),
            SizedBox(width: 10.h),
            Text(': \$${widget.model.oldPrice!}',
                style: TextStyle(
                    color: const Color(0xff223263),
                    fontWeight: FontWeight.bold,
                    textBaseline: TextBaseline.ideographic,
                    fontFamily: 'Poppins',
                    fontSize: 25.sp)),
          ],
        ),
        Text('${localizations.description} :',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                textBaseline: TextBaseline.ideographic,
                fontSize: 22.sp)),
        SizedBox(height: 10.h),
        Container(
          padding:
              EdgeInsetsDirectional.symmetric(vertical: 10.h, horizontal: 10.w),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(
                color: const Color(0xff9098B1).withOpacity(0.5),
                strokeAlign: 0.5),
          ),
          child: Text(widget.model.description ?? '',
              style: TextStyle(
                  color: const Color(0xff9098B1),
                  fontWeight: FontWeight.bold,
                  textBaseline: TextBaseline.ideographic,
                  fontSize: 18.sp),
              textAlign: TextAlign.start),
        ),
        SizedBox(height: 20.h),
        MyButton(
            text: localizations.addToCart,
            onTap: () async => await addToCart(widget.model.count!),
            loader: loader,
            colorButton: Theme.of(context).primaryColor),
      ],
    );
  }

  bool loader = false;

  Future<void> addToCart(int count) async {
    if (count < 1 || counter > count) {
      showSnackBar(
          context, localizations.thereIsNotEnoughQuantityOfThisProduct, true);
    } else {
      ProductModel model = ProductModel(
          titel: widget.model.titel,
          price: widget.model.price,
          images: widget.model.images,
          offer: widget.model.offer,
          description: widget.model.description,
          idCategory: widget.model.idCategory,
          isCategory: widget.model.isCategory,
          oldPrice: widget.model.offer,
          id: widget.model.id,
          count: counter);
      setState(() => loader = true);
      var data = await FbCartController().insert(
          context,
          CartModel(
            timestamp: Timestamp.now(),
            id: const Uuid().v4(),
            idUser: CacheController().getter(CacheKeys.id),
            model: model,
            qyn: counter
          ));
      int updateCount = widget.model.count! - counter;
      await FbProductController().upDate(ProductModel(
          titel: widget.model.titel,
          price: widget.model.price,
          images: widget.model.images,
          offer: widget.model.offer,
          description: widget.model.description,
          idCategory: widget.model.idCategory,
          isCategory: widget.model.isCategory,
          oldPrice: widget.model.offer,
          id: widget.model.id,
          count: updateCount));
      setState(() => loader = false);

      if (data && context.mounted) {
        showSnackBar(
            context, localizations.operationAccomplishedSuccessfully, false);
        Navigator.pop(context);
      }
    }
  }

  void subtract() {
    if (counter > 1) {
      setState(() {
        counter--;
      });
    }
  }

  void add() {
    setState(() {
      counter++;
    });
  }
}
