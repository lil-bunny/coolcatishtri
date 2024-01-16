import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/screens/My%20Rate.dart';
import 'package:ishtri_db/screens/MySchedule.dart';
import 'package:ishtri_db/screens/Orders.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/services/global.dart';
import 'package:ishtri_db/statemanagemnt/provider/DBProfileDataProvider.dart';
import 'package:ishtri_db/widgets/CButton.dart';
import 'package:provider/provider.dart';
import '../../widgets/question.dart';
import '../../widgets/CustomText.dart';
import '../models/Data.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isAddService = false;
  dynamic day = "today";

  var _data = null;
  var page = 1;
  dynamic _users = [];
  late ScrollController _controller = ScrollController();

  Future<dynamic> _fetchDasborad() async {
    try {
      var arr = [], arr1 = [];
      Future.delayed(Duration(microseconds: 700), () {
        showLoader(context);
      });
      final data1 = await ApiService()
          .sendGetRequest('/v1/delivery-boy/order/dashboard?day=${day}');
      if (kDebugMode) {
        log('@@ 29 ${data1['data']['data']}');
      }
      if (data1['data']['status'] == 1) {
        hideLoader(context);

        setState(() {
          _users = [data1['data']['data']];
        });
      } else {
        var arr = [];
        var mes = '';
        for (var i = 0; i < data1['data']['data'].length; i++) {
          // log('@@@ ${res['data'][i]}');
          arr.add(data1['data']['data'][i]);
        }

        for (dynamic item in arr) {
          item.forEach((key, value) {
            print('Key: $key, Value: $value');
            mes = '${mes} ' + value.replaceAll('"', '') + '.';
          });
        }
        hideLoader(context);
        // var mes = reg?.data![0].message;
        toast(mes!);
      }
      hideLoader(context);
    } catch (ex) {
      if (kDebugMode) {
        print('x');
      }
      if (kDebugMode) {
        print(ex);
      }
      Future.delayed(const Duration(milliseconds: 200), () {
        hideLoader(context);
      });
    } catch (e) {}

    // ignore: use_build_context_synchronously
    Future.delayed(Duration(seconds: 1), () {
      hideLoader(context);
    });
  }

  void showAlert(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 320,
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: showAlertDialog(context),
          ),
        );
      },
    );
  }

  bool isChecked = true;
  showAlertDialog(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: [
                  const Image(
                    image: AssetImage('assets/images/Welcome.png'),
                    width: 126,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 15, top: 0),
                    // color: Colors.white,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    // height: 120,
                    child: Text(
                      "Hello..! Please add your Services & Rates to start taking orders",
                      style: TextStyle(
                        color: lightBlackColor,
                        fontFamily: "Poppins-Regular",
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: ActionButton("Add Services Rate", () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/screens/MyRates',
                              arguments: {"isHome": false});
                        }, MediaQuery.of(context).size.width * 0.45,
                            HexColor('#1C2941'), Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ));
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _fetchDasborad();
    _details();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isSelect = false;

  _details() async {
    setState(() {
      isAddService = false;
    });
    // Future.delayed(Duration(seconds: 1), () {
    //   showLoader(context);
    // });
    await Provider.of<DBProfileDataProvider>(context, listen: false)
        .profileData(context);
    var res = await Provider.of<DBProfileDataProvider>(context, listen: false)
        .dBdetails;
    if (res?.status == 1) {
      setState(() {
        isAddService = res?.data![0].dbDetails?.serviceRate == 1 ? false : true;
      });
      // Future.delayed(Duration(seconds: 1), () {
      // hideLoader(context);
      // });
      res?.data![0].dbDetails?.serviceRate == 0 ? showAlert(context) : null;
    } else {
      Future.delayed(Duration(seconds: 1), () {
        hideLoader(context);
      });
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  // }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Dashboard',
          ),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(92, 136, 218, 1),
          leading: IconButton(
            icon: const Image(
              image: AssetImage("assets/images/Hover.png"),
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/screens/DeliveryBoyProfile");
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: Column(
                children: [
                  // Container(
                  //   height: 60,
                  //   width: MediaQuery.of(context).size.width - 36,
                  //   decoration: const BoxDecoration(
                  //     color: Color.fromRGBO(26, 163, 1, 1),
                  //     borderRadius: BorderRadius.all(
                  //       Radius.circular(
                  //         7,
                  //       ),
                  //     ),
                  //   ),
                  //   child: const Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 8.0),
                  //     child: Align(
                  //       alignment: Alignment.centerLeft,
                  //       child: Text(
                  //         'You have new order',
                  //         style: TextStyle(color: Colors.white),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 12,
                  // ),
                  Container(
                    height: 52,
                    // width: MediaQuery.of(context).size.width - 22,
                    decoration: const BoxDecoration(
                      color: Color(0xff1C2941),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () => {
                            setState(() {
                              isChecked = true;
                              day = 'today';
                            }),
                            _fetchDasborad()
                          },
                          child: Container(
                            height: 42,
                            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            decoration: BoxDecoration(
                              color: !isChecked
                                  ? const Color.fromRGBO(28, 41, 65, 1)
                                  : const Color.fromRGBO(92, 136, 218, 1),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  7,
                                ),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width / 2 - 22,
                            child: Center(
                              child: Text(
                                "Today",
                                style: TextStyle(
                                  color: !isChecked
                                      ? const Color.fromRGBO(92, 136, 218, 1)
                                      : Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => {
                            setState(() {
                              isChecked = false;
                              day = "tomorrow";
                            }),
                            _fetchDasborad()
                          },
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color: isChecked
                                  ? const Color(0xff1C2941)
                                  : const Color.fromRGBO(92, 136, 218, 1),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  7,
                                ),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width / 2 - 22,
                            child: Center(
                              child: Text(
                                "Tomorrow",
                                style: TextStyle(
                                  color: isChecked
                                      ? const Color.fromRGBO(92, 136, 218, 1)
                                      : Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 12, 8, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                // Get.toNamed("/screens/MySchedule");
                              },
                              child: Container(
                                height: 92,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 25,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(9),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      "Scheduled Pickups",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      _users?[0]['scheduled_pickup']
                                              ?.toString() ??
                                          '',
                                      style: TextStyle(
                                        color: Color.fromRGBO(190, 58, 58, 1.0),
                                        fontSize: 33,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 92,
                              width: MediaQuery.of(context).size.width / 2 - 25,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(9),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Actual Pickups",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    _users?[0]['actual_pickup'].toString() ??
                                        '',
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 255, 0, 1.0),
                                      fontSize: 33,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () => {
                                // submit(),
                              },
                              child: Container(
                                height: 92,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 25,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(9),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Scheduled Delivery",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      _users?[0]['scheduled_delivery']
                                              .toString() ??
                                          '',
                                      style: TextStyle(
                                        color: Color.fromRGBO(190, 58, 58, 1.0),
                                        fontSize: 33,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 92,
                              width: MediaQuery.of(context).size.width / 2 - 25,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(9),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Actual Delivery",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    _users?[0]['actual_delivery'].toString() ??
                                        '',
                                    style: TextStyle(
                                      color: Color.fromRGBO(27, 162, 27, 1),
                                      fontSize: 33,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 62,
                        width: MediaQuery.of(context).size.width - 25,
                        margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(9),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                              child: const Text(
                                "Active Laundries",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: _users?[0]['active_laundries']
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '/${_users[0]['all_laundries']}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 12,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.fromLTRB(0, 12, 0, 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 92,
                          width: MediaQuery.of(context).size.width / 2 - 25,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(9),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Unpaid Orders",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                _users[0]['unpaid_orders'].toString() ?? '',
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 33,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 92,
                          width: MediaQuery.of(context).size.width / 2 - 25,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(9),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                "Unpaid Amount",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Rs. ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                    TextSpan(
                                      text: _users[0]['unpaid_amount']
                                              .toString() ??
                                          '',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 62,
                    width: MediaQuery.of(context).size.width - 25,
                    margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(9),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                          child: const Text(
                            "Laundries Due Amount",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Rs. ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                                TextSpan(
                                  text: _users[0]['laundries_due_amount']
                                          .toString() ??
                                      '',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
