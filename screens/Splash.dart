import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:ishtri_db/screens/Bottom%20Tab.dart';
import 'package:ishtri_db/screens/Permission.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  static var token = '';
  @override
  void initState() {
    super.initState();
    authCheck();
  }

  void authCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var storedName = prefs.getString(API_TOKEN_KEY) ?? '';
    print(storedName);
    Future.delayed(const Duration(seconds: 3), () {
      storedName == ''
          ? Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const PermissionScreen()),
              (Route route) => false)
          : Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const BottomTab()),
              (Route route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    token = Provider.of<SignupDataProvider>(context).storedName;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset(
          "assets/images/SplashScreen.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
