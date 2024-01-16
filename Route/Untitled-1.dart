// import 'package:flutter/material.dart';
// import 'package:ishtri_db/Route/Navigation.dart';
// import 'package:ishtri_db/screens/Bottom%20Tab.dart';
// import 'package:ishtri_db/screens/Permission.dart';
// import 'package:ishtri_db/screens/Splash.dart';
// import 'package:get/get.dart';
// import 'package:ishtri_db/services/Api.dart';
// import 'package:ishtri_db/statemanagemnt/provider/HelperDataProvider.dart';
// import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
// import 'package:provider/provider.dart';
// import 'package:provider/single_child_widget.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // import 'package:ishtri_db/screens/CustomerLanding.dart';

// List<SingleChildWidget> providers = [
//   ChangeNotifierProvider<SignupDataProvider>(
//       create: (_) => SignupDataProvider()),
//   ChangeNotifierProvider<HelperDataProvider>(
//       create: (_) => HelperDataProvider()),
// ];
// void main() async {
//   runApp(
//     MultiProvider(
//       providers: providers,
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   // const MyApp({super.key});
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   @override
//   Widget build(BuildContext context) {
//     bool _showSplashScreen = true;
//     var token = '';

//     _showSplashScreen =
//         Provider.of<SignupDataProvider>(context, listen: false).loading;
//     token = Provider.of<SignupDataProvider>(context, listen: false).storedName;
//     print('token res $token');
//     print('token res $_showSplashScreen');

//     // if (_showSplashScreen) {
//     //   Provider.of<SignupDataProvider>(context, listen: false).localStorageGet();
//     //   return MaterialApp(
//     //     theme: ThemeData(
//     //       primarySwatch: Colors.blue,
//     //     ),
//     //     home: Splash(),
//     //     debugShowCheckedModeBanner: false,
//     //   );
//     // }
//     return GetMaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       initialRoute: '/screens/Splash',
//       routes: Navigation.screen,
//       home: token == '' ? Splash() : BottomTab(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
