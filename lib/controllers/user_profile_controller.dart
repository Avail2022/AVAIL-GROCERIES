import 'package:get/get.dart';
import 'package:grocery_onlineapp/models/addressModel.dart';
import 'package:grocery_onlineapp/models/businessLayer/apiHelper.dart';
import 'package:grocery_onlineapp/models/businessLayer/global.dart' as global;
import 'package:grocery_onlineapp/models/userModel.dart';

class UserProfileController extends GetxController {
  APIHelper apiHelper = new APIHelper();
  CurrentUser currentUser;
  List<Address> addressList = [];
  var isDataLoaded = false.obs;
  var isAddressDataLoaded = false.obs;
 

  getMyProfile() async {
    try {
      isDataLoaded(false);
      await apiHelper.myProfile().then((result) async {
        if (result != null) {
          if (result.status == "1") {
            currentUser = result.data;
            global.currentUser = currentUser;
          } else {
            currentUser = null;
          }
        }
      });
      isDataLoaded(true);
      update();
    } catch (e) {
      print("Exception - user_profile_controller.dart - _getMyProfile():" + e.toString());
    }
  }

  getUserAddressList() async {
    try {
      isAddressDataLoaded(false);
      await apiHelper.getAddressList().then((result) async {
        if (result != null) {
          if (result.status == "1") {
            addressList = result.data;
            global.addressList.addAll(global.addressList);
          } else {
            addressList = [];
          }
        }
      });
      isAddressDataLoaded(true);
      update();
    } catch (e) {
      print("Exception - user_profile_controller.dart - _init():" + e.toString());
    }
  }

  removeUserAddress(int index) async {
    try {
      await apiHelper.removeAddress(addressList[index].addressId).then((result) async {
        if (result != null) {
          if (result.status == "1") {
            addressList.removeAt(index);
          }
        }
      });
      update();
    } catch (e) {
      print("Exception - user_profile_controller.dart - _removeAddress():" + e.toString());
    }
  }
}
