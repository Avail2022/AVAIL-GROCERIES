import 'dart:convert';
import 'dart:ui';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:grocery_onlineapp/controllers/user_profile_controller.dart';
import 'package:grocery_onlineapp/models/addressModel.dart';
import 'package:grocery_onlineapp/models/appInfoModel.dart';
import 'package:grocery_onlineapp/models/appNoticeModel.dart';
import 'package:grocery_onlineapp/models/businessLayer/apiHelper.dart';
import 'package:grocery_onlineapp/models/googleMapModel.dart';
import 'package:grocery_onlineapp/models/localNotificationModel.dart';
import 'package:grocery_onlineapp/models/mapBoxModel.dart';
import 'package:grocery_onlineapp/models/mapByModel.dart';
import 'package:grocery_onlineapp/models/nearByStoreModel.dart';
import 'package:grocery_onlineapp/models/paymentGatewayModel.dart';
import 'package:grocery_onlineapp/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Address> addressList = [];
APIHelper apiHelper;
String appDeviceId;
AppInfo appInfo = new AppInfo();
AppNotice appNotice = new AppNotice();
String appName = 'Avail Service';
String appShareMessage = "I'm inviting you to use $appName, a simple and easy app to find all required products near by your location. Here's my code [CODE] - jusy enter it while registration.";
String appVersion = '1.0';
String baseUrl = 'https://availservice.availapp.in/api/';
int cartCount = 0;
List<Color> colorList = [
  Color(0xFF4DD0E1),
  Color(0xFFAB47BC),
];
String currentLocation;
 CurrentUser currentUser = new CurrentUser();
String defaultImage = 'assets/images/appicon_180x180.png';
GoogleMapModel googleMap;
String imageUploadMessageKey = 'w0daAWDk81';
bool isChatNotTapped = false;
String languageCode = 'en';
double lat;
double lng;
bool isRTL = false;
List<String> rtlLanguageCodeLList = ['ar', 'arc', 'ckb', 'dv', 'fa', 'ha', 'he', 'khw', 'ks', 'ps', 'ur', 'uz_AF', 'yi'];
LocalNotification localNotificationModel = new LocalNotification();
String locationMessage = '';
MapBoxModel mapBox;
NearStoreModel nearStoreModel = new NearStoreModel();
PaymentGateway paymentGateway = new PaymentGateway();
String selectedImage;
SharedPreferences sp;
bool isNavigate = false;
String stripeBaseApi = 'https://api.stripe.com/v1';
final UserProfileController userProfileController = Get.put(UserProfileController());
Mapby mapby;
Future<Map<String, String>> getApiHeaders(bool authorizationRequired) async {
  Map<String, String> apiHeader = new Map<String, String>();
  if (authorizationRequired) {
    sp = await SharedPreferences.getInstance();
    if (sp.getString("currentUser") != null) {
      CurrentUser currentUser = CurrentUser.fromJson(json.decode(sp.getString("currentUser")));
      apiHeader.addAll({"Authorization": "Bearer " + currentUser.token});
    }
  }
  apiHeader.addAll({"Content-Type": "application/json"});
  apiHeader.addAll({"Accept": "application/json"});
  return apiHeader;
}
