import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:grocery_onlineapp/l10n/l10n.dart';
import 'package:grocery_onlineapp/models/businessLayer/global.dart' as global;
import 'package:grocery_onlineapp/models/localNotificationModel.dart';
import 'package:grocery_onlineapp/provider/local_provider.dart';
import 'package:grocery_onlineapp/screens/splash_screen.dart';
import 'package:grocery_onlineapp/theme/style.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  HttpOverrides.global = new MyHttpOverrides();

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  runApp(App());
}
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
  description: 'Channel Description',
  playSound: true
);
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
  } catch (e) {
    print('Exception - main.dart - _firebaseMessagingBackgroundHandler(): ' + e.toString());
  }
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class _AppState extends State<App> {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final String routeName = "main";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        builder: (context, child) {
          return GetMaterialApp(
              navigatorObservers: <NavigatorObserver>[observer],
              debugShowCheckedModeBanner: false,
              title: "Avail Service",
              locale: Get.deviceLocale,
              supportedLocales: L10n.all,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              home: SplashScreen(
                a: analytics,
                o: observer,
              ),
              theme: ThemeUtils.defaultAppThemeData);
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var initialzationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initialzationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      try {
        LocalNotification _notificationModel = LocalNotification.fromJson(message.data);
        global.localNotificationModel = _notificationModel;
        setState(() {
          global.isChatNotTapped = false;
        });

        print('Got a message whilst in the foreground!');
        print('${message.data['0']}');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          Future<String> _downloadAndSaveFile(String url, String fileName) async {
            final Directory directory = await getApplicationDocumentsDirectory();
            final String filePath = '${directory.path}/$fileName';
            final http.Response response = await http.get(Uri.parse(url));
            final File file = File(filePath);
            await file.writeAsBytes(response.bodyBytes);
            return filePath;
          }

          if (Platform.isAndroid) {
            final String bigPicturePath = await _downloadAndSaveFile(message.notification.android.imageUrl != null ? message.notification.android.imageUrl : 'https://picsum.photos/200/300', 'bigPicture');

            final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
              FilePathAndroidBitmap(bigPicturePath),
            );
            final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(channel.id, channel.name, channelDescription: channel.description, icon: '@mipmap/ic_notification', styleInformation: bigPictureStyleInformation, playSound: true);
            final AndroidNotificationDetails androidPlatformChannelSpecifics2 = AndroidNotificationDetails(channel.id, channel.name, channelDescription: channel.description, icon: '@mipmap/ic_notification', styleInformation: BigTextStyleInformation(message.notification.body), playSound: true
                // styleInformation:   message.notification.android.imageUrl != null  ? bigPictureStyleInformation : BigPictureStyleInformation
                );
            final NotificationDetails platformChannelSpecifics = NotificationDetails(android: message.notification.android.imageUrl != null ? androidPlatformChannelSpecifics : androidPlatformChannelSpecifics2);

            flutterLocalNotificationsPlugin.show(1, message.notification.title, message.notification.body, platformChannelSpecifics);
          } else if (Platform.isIOS) {
            final String bigPicturePath = await _downloadAndSaveFile(message.notification.apple.imageUrl != null ? message.notification.apple.imageUrl : 'https://picsum.photos/200/300', 'bigPicture.jpg');
            final IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(attachments: <IOSNotificationAttachment>[IOSNotificationAttachment(bigPicturePath)], presentSound: true);
            final IOSNotificationDetails iOSPlatformChannelSpecifics2 = IOSNotificationDetails(presentSound: true);
            final NotificationDetails notificationDetails = NotificationDetails(
              iOS: message.notification.apple.imageUrl != null ? iOSPlatformChannelSpecifics : iOSPlatformChannelSpecifics2,
            );
            await flutterLocalNotificationsPlugin.show(1, message.notification.title, message.notification.body, notificationDetails);
          }
        }

        if (message.notification != null) {
          print('Message also contained a notification: ${message.notification}');
        }
      } catch (e) {
        print('Exception - main.dart - onMessage.listen(): ' + e.toString());
      }
    });
  }
}
