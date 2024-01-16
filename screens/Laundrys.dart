import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/statemanagemnt/provider/HelperDataProvider.dart';
import 'package:ishtri_db/statemanagemnt/provider/LaundryDataProvider.dart';
import 'package:provider/provider.dart';
import '../../widgets/question.dart';
import '../../widgets/CustomText.dart';
import '../models/Data.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class Laundrys extends StatefulWidget {
  const Laundrys({super.key});

  @override
  State<Laundrys> createState() => _LaundrysState();
}

class _LaundrysState extends State<Laundrys> {
  void submit() {
    showAlertDialog(context);
  }

  bool isChecked = true;
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {},
    );
    Widget remindButton = TextButton(
      child: const Text("Remind me later"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text(
          "Would you like to continue learning how to use Flutter alerts?"),
      actions: [cancelButton, continueButton, remindButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    void cancel() {
      Navigator.pop(context, false);
    }
  }

  var _data = null;
  var page = 1;
  List _users = [];
  late ScrollController _controller = ScrollController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // print("Hello");
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _firstLoad();
        print(_controller.position.pixels);
      }
    });

    setState(() {
      page++;
    });
    // _firstLoad();
    _laundry();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<String> names = <String>[];
  final List<int> msgCount = <int>[2, 0, 10, 6, 52, 4, 0, 2];
  bool isSelect = false;
  _firstLoad() async {}

  _fetchData() async {}

  var activedelivery = [];
  var inactivedelivery = [];

  _laundry() async {
    var arr = [], arr1 = [];
    setState(() {
      activedelivery = [];
      inactivedelivery = [];
    });
    Future.delayed(Duration(seconds: 1), () {
      // showLoader(context);
    });
    // Provider.of<LaundryDataProvider>(context, listen: false)
    //     .viewLaundryData(context);
    // var laundry = Provider.of<LaundryDataProvider>(context, listen: false)
    //     .laundryActive;

    try {
      final data1 = await ApiService()
          .sendGetRequest('/v1/delivery-boy/laundry-service/laundry-list');
      if (kDebugMode) {
        log('@@ ${data1['data']['data']}');
      }
      // if (data1['data']['status'] == 1) {
      //   log('@@@ ${data1['data']}');
      if (data1['data']['status'] == 1) {
        data1['data']['data'][0]['active_laundries']?.forEach((element) => {
              arr.add({
                "name": element['laundry_aditional_detail']['laundry_name']
                    .toString(),
                "laundry_holidays": element['laundry_holidays'],
                "id": element['id'],
              })
            });
        data1['data']['data'][0]['inactive_laundries']?.forEach((element) => {
              arr1.add({
                "name": element['laundry_aditional_detail']['laundry_name']
                    .toString(),
                "laundry_holidays": element['laundry_holidays'],
                "id": element['id'],
              })
            });
        log('@@@ ${arr1}');
        setState(() {
          activedelivery = arr;
          inactivedelivery = arr1;
        });
        hideLoader(context);
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
        toast(mes!);
      }
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
    } catch (e) {
      hideLoader(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Laundry' + '`s',
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(92, 136, 218, 1),
        leading: IconButton(
          icon: const Image(
            image: AssetImage("assets/images/ChevronLeft.png"),
            height: 27,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Column(
              children: [
                SizedBox(
                  height: 0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 10,
                    height: 49,
                    decoration: BoxDecoration(
                      color: HexColor('#1C2941'),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/screens/AddLaundry');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Image(
                                  image: AssetImage('assets/images/Add.png')),
                            ),
                            Text(
                              'Add Laundry',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xff1C2941),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () => {
                          setState(() {
                            isChecked = true;
                          }),
                          _laundry()
                        },
                        child: Container(
                          height: 42,
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          decoration: BoxDecoration(
                            color: !isChecked
                                ? const Color.fromRGBO(28, 41, 65, 1)
                                : const Color.fromRGBO(92, 136, 218, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                7,
                              ),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width / 2 - 22,
                          child: Center(
                            child: Text(
                              "Active",
                              style: TextStyle(
                                color: !isChecked
                                    ? Color.fromRGBO(92, 136, 218, 1)
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
                          }),
                          _laundry()
                        },
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: isChecked
                                ? const Color(0xff1C2941)
                                : Color.fromRGBO(92, 136, 218, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                7,
                              ),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width / 2 - 22,
                          child: Center(
                            child: Text(
                              "Inactive",
                              style: TextStyle(
                                color: isChecked
                                    ? Color.fromRGBO(92, 136, 218, 1)
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
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Laundry Name",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "Holiday",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.grey,
                    )
                  ],
                ),
                isChecked == true
                    ? Container(
                        height: double.maxFinite,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: activedelivery.length != 0
                            ? ListView.builder(
                                itemCount: activedelivery.length,
                                itemBuilder: (context, index) {
                                  print((activedelivery[index]));
                                  return Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 1,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12.0, 10, 10, 10.0),
                                      child: InkWell(
                                        onTap: () => {
                                          Navigator.pushNamed(context,
                                              '/screens/LaundryProfile',
                                              arguments: {
                                                "id": activedelivery[index]
                                                    ['id']
                                              })
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              activedelivery[index]['name'],
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                // backgroundColor: Colors.amber,
                                                height: 2,
                                              ),
                                            ),
                                            Container(
                                              height: 32,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .55,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: activedelivery[index]
                                                        ['laundry_holidays']
                                                    .length,
                                                itemBuilder: (context, index1) {
                                                  return Text(
                                                    activedelivery[index]
                                                                        ['laundry_holidays']
                                                                    [index1]
                                                                ['day'] ==
                                                            1
                                                        ? "Sunday, "
                                                        : activedelivery[index]
                                                                            ['laundry_holidays']
                                                                        [index1]
                                                                    ['day'] ==
                                                                2
                                                            ? "Monday, "
                                                            : activedelivery[index]
                                                                            ['laundry_holidays'][index1]
                                                                        [
                                                                        'day'] ==
                                                                    3
                                                                ? "Tuesday, "
                                                                : activedelivery[index]['laundry_holidays'][index1]
                                                                            ['day'] ==
                                                                        4
                                                                    ? "Wednesday, "
                                                                    : activedelivery[index]['laundry_holidays'][index1]['day'] == 5
                                                                        ? "Thusday, "
                                                                        : activedelivery[index]['laundry_holidays'][index1]['day'] == 6
                                                                            ? "Friday, "
                                                                            : "Satarday",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.red,
                                                      // backgroundColor: Colors.amber,
                                                      height: 2,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(),
                      )
                    : Container(
                        height: double.maxFinite,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: inactivedelivery.length != 0
                            ? ListView.builder(
                                itemCount: inactivedelivery.length,
                                itemBuilder: (context, index) {
                                  print((inactivedelivery[index]));
                                  return Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 1,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12.0, 10, 10, 10.0),
                                      child: InkWell(
                                        onTap: () => {
                                          // Navigator.pushNamed(context,
                                          //     '/screens/LaundryProfile')
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              inactivedelivery[index]['name']
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                // backgroundColor: Colors.amber,
                                                height: 2,
                                              ),
                                            ),
                                            // Text(
                                            //   activedelivery[index]['Holiday'],
                                            //   style: const TextStyle(
                                            //     fontSize: 12,
                                            //     color: Colors.red,
                                            //     // backgroundColor: Colors.amber,
                                            //     height: 2,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(),
                      ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
