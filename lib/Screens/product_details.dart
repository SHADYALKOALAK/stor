import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:store/FireBase/Models/product_model.dart';
import 'package:store/FireBase/fb_add_to_cart_controller.dart';
import 'package:store/FireBase/fb_add_to_favorite_controller.dart';
import 'package:store/Helbers/chickDataHelber.dart';
import 'package:store/Helbers/nav_helber.dart';
import 'package:store/Screens/view_product_mage.dart';
import 'package:store/Witgets/my_button.dart';
import 'package:store/cache/cache_controller.dart';
import 'package:store/enums.dart';
import 'package:store/providers/auth_provider.dart';

class ProductDetails extends StatefulWidget {
  final List<dynamic>? list;
  final String? titel;
  final String? price;
  final String? oldPrice;
  final String? offer;
  final String? description;
  final String? id;

  const ProductDetails({
    Key? key,
    this.titel,
    this.price,
    this.list,
    this.oldPrice,
    this.description,
    required this.offer,
    this.id,
  }) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails>
    with NavHelper, ChickData {
  AppLocalizations get localizations => AppLocalizations.of(context)!;
  bool fav = false;

  AuthProvider get _auth => Provider.of<AuthProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
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
          widget.titel ?? '',
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
        padding:
            EdgeInsetsDirectional.symmetric(vertical: 16.h, horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.builder(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.list!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10.w,
                    crossAxisSpacing: 10.h,
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return widget.list == null
                      ? CircularProgressIndicator(
                          color: Theme.of(context).primaryColor)
                      : InkWell(
                          onTap: () => jump(
                              context,
                              ViewProductImage(image: widget.list?[index].link),
                              false),
                          child: Container(
                              clipBehavior: Clip.antiAlias,
                              width: double.infinity,
                              height: 200.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(
                                    color: const Color(0xff9098B1)
                                        .withOpacity(0.5),
                                    strokeAlign: 0.5),
                              ),
                              child: widget.list?[index].link != null
                                  ? Padding(
                                      padding: EdgeInsetsDirectional.all(5.r),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            widget.list?[index].link ?? '',
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
                    child: Text(widget.titel!,
                        style: TextStyle(
                            color: const Color(0xff223263),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            textBaseline: TextBaseline.ideographic,
                            fontSize: 22.sp)),
                  ),
                  IconButton(
                      onPressed: () {
                        fav == false
                            ? setState(() => fav = true)
                            : setState(() => fav = false);
                        if (fav == true) {
                          addToFav();
                        } else {
                          FbAddToFavoriteController().delete(ProductModel(
                            images: widget.list!,
                            price: widget.price,
                            id: widget.id,
                            titel: widget.titel,
                          ));
                          showSnackBar(context,
                              localizations.removedFromFavourites, Colors.red);
                        }
                      },
                      icon: Icon(fav == true
                          ? Icons.favorite_outlined
                          : Icons.favorite_outline),
                      color: fav == true
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).primaryColor)
                ],
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
                  Text(': \$${widget.price!}',
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
                  Text(': \$${widget.oldPrice!}',
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
                padding: EdgeInsetsDirectional.symmetric(
                    vertical: 10.h, horizontal: 10.w),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  border: Border.all(
                      color: const Color(0xff9098B1).withOpacity(0.5),
                      strokeAlign: 0.5),
                ),
                child: Text(widget.description ?? '',
                    style: TextStyle(
                        color: const Color(0xff9098B1),
                        fontWeight: FontWeight.bold,
                        textBaseline: TextBaseline.ideographic,
                        fontSize: 18.sp),
                    textAlign: TextAlign.start),
              ),
              SizedBox(height: 20.h),
              loader == true
                  ? Center(
                      child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor),
                    )
                  : InkWell(
                      onTap: () async => await addToCart(),
                      child: MyButton(
                          text: localizations.addToCart,
                          colorButton: Theme.of(context).primaryColor),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  bool loader = false;
  var id = CacheController().getter(CacheKeys.id);

  Future<void> addToCart() async {
    setState(() => loader = true);
    await FbAddToCartController().insert(ProductModel(
        images: widget.list!,
        price: widget.price,
        id: widget.id,
        titel: widget.titel,
        idUser: _auth.user?.id
    ));

    if (context.mounted) {
      showSnackBar(
          context,
          localizations.theProductHasBeenAddedToTheCartSuccessfully,
          Theme.of(context).primaryColor);
    }
    setState(() => loader = false);
  }

  Future<void> addToFav() async {
    await FbAddToFavoriteController().insert(ProductModel(
      images: widget.list!,
      price: widget.price,
      id: widget.id,
      titel: widget.titel,
    ));
    if (context.mounted) {
      showSnackBar(context, localizations.addedToFavoritesSuccessfully,
          Theme.of(context).primaryColor);
    }
  }
}
