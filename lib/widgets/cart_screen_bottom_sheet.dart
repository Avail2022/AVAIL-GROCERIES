import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:grocery_onlineapp/controllers/cart_controller.dart';
import 'package:grocery_onlineapp/models/businessLayer/global.dart' as global;
import 'package:grocery_onlineapp/widgets/bottom_button.dart';

class CartScreenBottomSheet extends StatefulWidget {
  final CartController cartController;
  final Function onButtonPressed;
  CartScreenBottomSheet({this.onButtonPressed, this.cartController}) : super();

  @override
  _CartScreenBottomSheetState createState() => _CartScreenBottomSheetState(onButtonPressed: onButtonPressed, cartController: cartController);
}

class _CartScreenBottomSheetState extends State<CartScreenBottomSheet> {
  Function onButtonPressed;
  CartController cartController;
  _CartScreenBottomSheetState({this.onButtonPressed, this.cartController});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppLocalizations.of(context).txt_total_price}",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    cartController.cartItemsList != null ? "${global.appInfo.currencySign} ${cartController.cartItemsList.totalMrp}" : "${global.appInfo.currencySign} 0",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppLocalizations.of(context).txt_discount_price}",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    cartController.cartItemsList != null ? "${global.appInfo.currencySign} ${cartController.cartItemsList.discountonmrp}" : "${global.appInfo.currencySign} 0",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppLocalizations.of(context).txt_tax}",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    cartController.cartItemsList != null ? "${global.appInfo.currencySign} ${cartController.cartItemsList.totalTax}" : "${global.appInfo.currencySign} 0",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Divider(),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppLocalizations.of(context).lbl_total_amount}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    cartController.cartItemsList != null ? "${global.appInfo.currencySign} ${cartController.cartItemsList.totalPrice}" : "${global.appInfo.currencySign} 0",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              BottomButton(
                loadingState: false,
                disabledState: false,
                onPressed: () => onButtonPressed(),
                child: Text("${AppLocalizations.of(context).btn_proceed_to_checkout}"),
              )
            ],
          ),
        ));
  }
}
