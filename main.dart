import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ishtri_db/Route/Navigation.dart';
import 'package:ishtri_db/screens/Splash.dart';
import 'package:get/get.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/Constent.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/services/global.dart';
import 'package:ishtri_db/statemanagemnt/provider/CustomerDataProvider.dart';
import 'package:ishtri_db/statemanagemnt/provider/DBProfileDataProvider.dart';
import 'package:ishtri_db/statemanagemnt/provider/HelperDataProvider.dart';
import 'package:ishtri_db/statemanagemnt/provider/LaundryDataProvider.dart';
import 'package:ishtri_db/statemanagemnt/provider/OrderDataProvider.dart';
import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';

// import 'package:ishtri_db/screens/CustomerLanding.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<SignupDataProvider>(
      create: (_) => SignupDataProvider()),
  ChangeNotifierProvider<HelperDataProvider>(
      create: (_) => HelperDataProvider()),
  ChangeNotifierProvider<CustomerDataProvider>(
      create: (_) => CustomerDataProvider()),
  ChangeNotifierProvider<LaundryDataProvider>(
      create: (_) => LaundryDataProvider()),
  ChangeNotifierProvider<DBProfileDataProvider>(
      create: (_) => DBProfileDataProvider()),
  ChangeNotifierProvider<OrderDataProvider>(create: (_) => OrderDataProvider()),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  AUTH_TOKEN = await getApiToken();
  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  // NotificationSettings settings = await messaging.requestPermission(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  var token = await getFirebaseToken();
  // await _createNotificationChannel(flutterLocalNotificationsPlugin);
  log('Navigation.screen ${token}');
  runApp(
    MultiProvider(
      providers: providers,
      child: MyApp(),
    ),
  );
}

// Future<void> _createNotificationChannel(
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//   log('nbcnxcbmxbcjsbk');
//   const AndroidNotificationChannel androidNotificationChannel =
//       AndroidNotificationChannel(
//     '2', // Use the same channel ID as in AndroidManifest.xml
//     'flutterEmbedding',
//     'Your Channel Description',
//     importance: Importance.high,
//   );

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(androidNotificationChannel);
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static void showLoader(BuildContext context, isShowing, loaderText) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.showLoader(isShowing, loaderText);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}
// This widget is the root of your application.

class _MyAppState extends State<MyApp> {
  String _loaderText = "";
  dynamic subscription;
  dynamic _userDetails;

  bool _showSplashScreen = true;
  var token = '';
  void authCheck() async {
    await Provider.of<SignupDataProvider>(context, listen: false)
        .localStorageGet(context);
    // token = await Provider.of<SignupDataProvider>(context, listen: false)
    //     .localStorageGet(context);

    // print('Navigation.screen ${AUTH_TOKEN}');
  }

  showLoader(isShowing, loaderText) async {
    setState(() {
      _loaderText = loaderText;
    });
    if (isShowing) {
      context.loaderOverlay.show();
    } else {
      context.loaderOverlay.hide();
    }
  }

  var firstLoad = true;
  checkInternetStatus() async {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none) {
        log('no int Stat@@@ $result');
        showInternetLoading('You are offline');
      } else {
        //if (!firstLoad){
        log('active int@@@ $result');
        hideInternetLoading("Back to online");
        // }
      }
      print('connect status result :: ${result}');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternetStatus();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    //getFirebaseToken();
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    log('vnxbmsfbsf');
    // Handle notification data when the app is in the background or terminated.
    log("Handling a background message: ${message.messageId}");

    // Extract the data payload from the message
    Map<String, dynamic> data = message.data;

    // Check if the data payload contains a 'screen' key
    if (data.containsKey('screen')) {
      // Navigate to the specified screen
      String screen = data['screen'];
      print("Navigating to screen: $screen");

      // You can replace 'MySecondPage' with the name of the screen you want to navigate to
      Navigator.pushNamed(context, '/$screen');
    }
  }

// Be sure to cancel subscription after you are done
  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: GlobalLoaderOverlay(
        useDefaultLoading: false,
        overlayColor: Colors.black.withOpacity(0.6),
        overlayWidget: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: darkBlueColor,
                strokeWidth: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "Loading...",
                  style: TextStyle(
                      color: whiteColor,
                      fontSize: 14,
                      fontFamily: "Poppins-Regular"),
                ),
              )
            ],
          ),
        ),
        overlayOpacity: 0.7,
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          onGenerateInitialRoutes: (_) {
            return <Route>[
              MaterialPageRoute(builder: (context) => const Splash())
            ];
          },
          routes: Navigation.screen,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
