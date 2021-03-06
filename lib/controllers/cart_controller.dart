import 'package:get/get.dart';
import 'package:grocery_onlineapp/models/businessLayer/apiHelper.dart';
import 'package:grocery_onlineapp/models/businessLayer/global.dart' as global;
import 'package:grocery_onlineapp/models/cartModel.dart';
import 'package:grocery_onlineapp/models/categoryProductModel.dart';
import 'package:grocery_onlineapp/models/varientModel.dart';

class CartController extends GetxController {
  Cart cartItemsList;
  APIHelper apiHelper = new APIHelper();
  var isDataLoaded = false.obs;
  var isReorderDataLoaded = false.obs;
  var isReOrderSuccess = false.obs;
  Future<bool> addToCart(Product product, int cartQty, bool isDel, {Varient varient, int varientId, int callId}) async {
    try {
      bool isSuccess = false;
      int vId;
      if (varient != null) {
        vId = varient.varientId;
      } else {
        vId = varientId;
      }

      await apiHelper.addToCart(qty: cartQty, varientId: vId, special: 0).then((result) {
        if (result != null) {
          if (result.status == '1') {
            cartItemsList = result.data;

            isSuccess = true;
            if (callId == 0) {
              // show cart screen
              if (isDel) {
                if (product.cartQty != null && product.cartQty == 1) {
                  product.cartQty = 0;
              
                    // cartItemsList.cartList.remove(product);
                

                  global.cartCount -= 1;
                } else {
                  product.cartQty -= 1;
                }
              } else {
                if (product.cartQty == null || product.cartQty == 0) {
                  product.cartQty = 1;

                  global.cartCount += 1;
                } else {
                  product.cartQty += 1;
                }
              }
            } else {
              if (product.varientId == varient.varientId) {
                if (isDel) {
                  if (product.cartQty != null && product.cartQty == 1) {
                    product.cartQty = 0;
                    varient.cartQty = 0;
                    global.cartCount -= 1;
                  } else {
                    product.cartQty -= 1;
                    varient.cartQty -= 1;
                  }
                } else {
                  if (product.cartQty == null || product.cartQty == 0) {
                    product.cartQty = 1;
                    varient.cartQty = 1;
                    global.cartCount += 1;
                  } else {
                    product.cartQty += 1;
                    varient.cartQty += 1;
                  }
                }
              } else {
                if (isDel) {
                  if (varient.cartQty != null && varient.cartQty == 1) {
                    varient.cartQty = 0;
                    global.cartCount -= 1;
                  } else {
                    varient.cartQty -= 1;
                  }
                } else {
                  if (varient.cartQty == null || varient.cartQty == 0) {
                    varient.cartQty = 1;
                    global.cartCount += 1;
                  } else {
                    varient.cartQty += 1;
                  }
                }
              }
            }
          }
        } else {
          isSuccess = false;
          cartItemsList = null;
        }
      });

      update();
      return isSuccess;
    } catch (e) {
      print("Exception -  cart_controller.dart - addToCart():" + e.toString());
      return null;
    }
  }

  getCartList() async {
    try {
      isDataLoaded(false);
      cartItemsList = new Cart();

      await apiHelper.showCart().then((result) async {
        if (result != null) {
          if (result.status == "1") {
            cartItemsList = result.data;
            global.cartCount = cartItemsList.cartList.length;
          } else {
            cartItemsList.cartList = [];
            global.cartCount = 0;
          }
        }
      });
      isDataLoaded(true);
      update();
    } catch (e) {
      print("Exception -  cart_controller.dart - getCartList():" + e.toString());
    }
  }
}
