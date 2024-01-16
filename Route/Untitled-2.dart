// import 'package:flutter/material.dart';
// import 'package:ishtri_db/Route/Navigation.dart';
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
//   // WidgetsFlutterBinding.ensureInitialized();
//   // await SharedPreferences.getInstance();
//   // bool isLoggedIn = await Auth.isUserLoggedIn();
//   // var context=ApiService.navigatorKey;
//   // var isLoggedIn =
//   // Provider.of<SignupDataProvider>(context, listen: false)
//   //     .localStorageGet(ApiService.navigatorKey);
//   // print(isLoggedIn);
//   runApp(
//     MultiProvider(
//       providers: providers,
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   MyApp({super.key});
//   bool _showSplashScreen = true;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance?.addObserver(this);
//     _loadAppState();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance?.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       _updateAppState(false);
//     }
//   }

//   Future<void> _loadAppState() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool shouldShowSplash = prefs.getBool('showSplashScreen') ?? true;
//     setState(() {
//       _showSplashScreen = shouldShowSplash;
//     });
//   }

//   Future<void> _updateAppState(bool showSplash) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('showSplashScreen', showSplash);
//     setState(() {
//       _showSplashScreen = showSplash;
//     });
//   }

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     // var token;
//     // print('token emp${token}');

//     return GetMaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       // initialRoute: '/',
//       routes: Navigation.screen,
//       home:
//           // Consumer<SignupDataProvider>(builder: (context, auth, _) {
//           //   // authCheck();
//           //   final bool isLoggedIn = auth.storedName != null;
//           //   print(isLoggedIn);
//           Splash(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
