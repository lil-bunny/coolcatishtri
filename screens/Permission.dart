import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  var activelocation = false;
  var activecamera = false;
  var activepush = false;
  double latitude = 0.0;
  double longitude = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _permission();
  }

  _permission() async {
    var status2 = await Permission.location.request();
    var status3 = await Permission.camera.request();
    var status4 = await Permission.notification.request();
    if (status2.isGranted) {
      setState(() {
        activelocation = true;
      });
    } else {
      setState(() {
        activelocation = false;
      });
    }
    if (status3.isGranted) {
      setState(() {
        activecamera = true;
      });
    } else {
      setState(() {
        activecamera = false;
      });
    }
    if (status4.isGranted) {
      setState(() {
        activepush = true;
      });
    } else {
      setState(() {
        activepush = false;
      });
    }
  }

  Future _initLocationService() async {
    // var location = Location();
    // var status = await Permission.location.request();
    var status2 = await Permission.location.request();
    if (status2.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print(position.latitude);
      setState(() {
        activelocation = true;
        latitude = position.latitude;
        longitude = position.longitude;
      });
    } else {
      setState(() {
        activelocation = false;
      });
    }

    print("${status2.isGranted}");
  }

  Future _initCameraService() async {
    // var location = Location();
    // var status = await Permission.location.request();
    var status2 = await Permission.camera.request();
    if (status2.isGranted) {
      setState(() {
        activecamera = true;
      });
    } else {
      setState(() {
        activecamera = false;
      });
    }

    print("${status2.isGranted}");
  }

  Future _initPushService() async {
    // var location = Location();
    // var status = await Permission.location.request();
    var status2 = await Permission.notification.request();
    if (status2.isGranted) {
      setState(() {
        activepush = true;
      });
    } else {
      setState(() {
        activepush = false;
      });
    }

    print("${status2.isGranted}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(92, 136, 218, 1),
        flexibleSpace: const FlexibleSpaceBar(
          centerTitle: true,
          background: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 29, 0, 0),
              child: Image(
                color: Colors.white,
                height: 60,
                width: 90,
                image: AssetImage(
                    "assets/images/base_logo_transparent_background.png"),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(42.0),
            child: Column(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        "assets/images/Location.png",
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      const Text(
                        "Access Your Location",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      Container(
                        height: 42,
                        width: MediaQuery.of(context).size.width - 180,
                        decoration: BoxDecoration(
                          color: activelocation == true
                              ? HexColor('#C5C5C5')
                              : Color.fromRGBO(28, 41, 65, 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            _initLocationService();
                          },
                          child: Text(
                            activelocation == true
                                ? "Enabled".toUpperCase()
                                : "Enable Location Service".toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 45,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        "assets/images/Selfie.png",
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      const Text(
                        "Access Your Camera",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      Container(
                        height: 42,
                        width: MediaQuery.of(context).size.width - 180,
                        decoration: BoxDecoration(
                          color: activecamera
                              ? HexColor("#D2D2D2")
                              : Color.fromRGBO(28, 41, 65, 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            // Get.toNamed("/screens/AddLaundry1");
                            _initCameraService();
                          },
                          child: Text(
                            activecamera
                                ? "Enabled".toUpperCase()
                                : "Enable Camera Access".toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 45,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        "assets/images/PushNotifications.png",
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      const Text(
                        "Can We Notify You?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      Container(
                        height: 42,
                        width: MediaQuery.of(context).size.width - 180,
                        decoration: BoxDecoration(
                          color: activepush
                              ? HexColor('#D2D2D2')
                              : Color.fromRGBO(28, 41, 65, 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            _initPushService();
                          },
                          child: Text(
                            activepush
                                ? "Enabled".toUpperCase()
                                : "Enable Push Notification".toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 22,
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      Container(
                        height: 42,
                        width: MediaQuery.of(context).size.width - 180,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(28, 41, 65, 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, "/screens/WelcomeSignup");
                          },
                          child: Text(
                            "Login or signup".toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
