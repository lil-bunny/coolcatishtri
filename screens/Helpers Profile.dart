import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/services/global.dart';
import 'package:ishtri_db/statemanagemnt/provider/HelperDataProvider.dart';
import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
import 'package:ishtri_db/widgets/CButton.dart';
import 'package:provider/provider.dart';

class HelpersProfile extends StatefulWidget {
  const HelpersProfile({super.key});

  @override
  State<HelpersProfile> createState() => _HelpersProfileState();
}

class _HelpersProfileState extends State<HelpersProfile> {
  var id = '';
  var arr = null;
  var token = '';
  var phone = null, name = null, dob = null, address = null;
  var name1 = null, name2 = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void dialog() {
    var dialog = Dialog(
      backgroundColor: Colors.amber,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        height: 350.0,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 16),
              // decoration: boxDecorationStylealert,
              // width: 200,
              padding: EdgeInsets.symmetric(horizontal: 8),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Edit Contact Number",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      // color: black_color,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 12, right: 6),
                    child: MaterialButton(
                      onPressed: () {},
                      color: Colors.green,
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 6, right: 12),
                    child: MaterialButton(
                      onPressed: () {},
                      color: Colors.green,
                      child: Text(
                        "OK",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  helperProfile(var id) async {
    var headers = {
      'Authorization':
          'Bearer $token', // Include the Bearer token in the headers
    };
    Map<String, dynamic> helperid = {
      "id": id.toString(),
    };

    print('id 108 $id');
    // print('helperid ${helperid as int}');
    await Provider.of<HelperDataProvider>(context, listen: false)
        .viewHelperData(context, helperid, headers);
    var data = await Provider.of<HelperDataProvider>(context, listen: false)
        .viewHelper;
    // arr = data?.data![0].userDetails;
    if (arr == null || arr == []) {
      setState(() {
        arr = data?.data![0].userDetails;
      });
    }

    phone = data?.data![0].userDetails?.primaryPhoneNo.toString();
    name1 = data?.data![0].userDetails?.firstName;
    name2 = data?.data![0].userDetails?.lastName;
    name = name1 + " " + name2;
    dob = data?.data![0].userDetails?.dob;
    address = data?.data![0].userDetails?.address;
  }

  _customerBlock() async {
    dynamic data = {};
    try {
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      data = {
        "helper_id": id.toString(),
      };
      log('@@@ ${data}');
      final data1 = await ApiService()
          .sendPostRequest('/v1/delivery-boy/helper/block-helper', data);
      if (kDebugMode) {
        log('@@ ${data1['data']}');
      }
      hideLoader(context);
      if (data1['data']['status'] == 1) {
        hideLoader(context);
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        hideLoader(context);
      }
    } catch (e) {}
  }

  _customerDelete() async {
    dynamic data = {
      "id": id.toString(),
      "status": "0",
      "type": "5",
    };
    try {
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      final data1 = await ApiService()
          .sendPostRequest('/v1/delivery-boy/customer/order-list', data);
      if (kDebugMode) {
        log('@@ ${data['data']['data']}');
      }
      hideLoader(context);
      if (data1['data']['status'] == 1) {
        hideLoader(context);
      } else {
        hideLoader(context);
      }
    } catch (e) {}
  }

  void _deleteAccount() async {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: double.maxFinite,
              height: 260,
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: deleteDialog(),
            ),
          );
        });
  }

  void _blockAccount() async {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: double.maxFinite,
              height: 260,
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: blockDialog(),
            ),
          );
        });
  }

  Widget deleteDialog() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState1) {
        return Container(
          height: 260,
          width: MediaQuery.of(context).size.width - 90,
          child: Column(
            children: [
              Container(
                height: 240,
                width: MediaQuery.of(context).size.width - 90,
                child: Column(
                  children: [
                    Container(
                      // height: 200,
                      margin: EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.only(
                          top: 12, left: 15, right: 15, bottom: 15),
                      // color: Colors.white,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0, top: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Delete Account",
                                    style: TextStyle(
                                      color: lightBlackColor,
                                      fontFamily: "Poppins-bold",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: ActionButton(
                                        "Cancel",
                                        () {
                                          Navigator.pop(context);
                                        },
                                        MediaQuery.of(context).size.width *
                                            0.25,
                                        Colors.transparent,
                                        HexColor('#1C2941'),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: ActionButton(
                                        "Confirm ",
                                        () {
                                          _customerDelete();
                                        },
                                        MediaQuery.of(context).size.width *
                                            0.25,
                                        HexColor('#1C2941'),
                                        whiteColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
        );
      },
    );
  }

  Widget blockDialog() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState1) {
        return Container(
          height: 260,
          width: MediaQuery.of(context).size.width - 90,
          child: Column(
            children: [
              Container(
                height: 240,
                width: MediaQuery.of(context).size.width - 90,
                child: Column(
                  children: [
                    Container(
                      // height: 200,
                      margin: EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.only(
                          top: 12, left: 15, right: 15, bottom: 15),
                      // color: Colors.white,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0, top: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Block Account",
                                    style: TextStyle(
                                      color: lightBlackColor,
                                      fontFamily: "Poppins-bold",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: ActionButton(
                                        "Cancel",
                                        () {
                                          Navigator.pop(context);
                                        },
                                        MediaQuery.of(context).size.width *
                                            0.25,
                                        Colors.transparent,
                                        HexColor('#1C2941'),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: ActionButton(
                                        "Confirm ",
                                        () {
                                          _customerBlock();
                                        },
                                        MediaQuery.of(context).size.width *
                                            0.25,
                                        HexColor('#1C2941'),
                                        whiteColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    token = Provider.of<SignupDataProvider>(context, listen: false).storedName;
    id = Provider.of<HelperDataProvider>(context, listen: false).helper_id;

    print(id);
    helperProfile(id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromRGBO(92, 136, 218, 1), //const Color(0x5C88DA),
        title: const Text(
          "Helper’s",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Image(
            image: AssetImage("assets/images/ChevronLeft.png"),
            height: 22,
          ),
          onPressed: () {
            // Get.toNamed("/screens/DeliveryBoyProfile");
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (arr != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(49),
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Image(
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                  image:
                                      AssetImage('assets/images/Account.png'),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 116,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Helper Name",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          "Active",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                        // Text(
                                        //   "Current Location",
                                        //   style: TextStyle(
                                        //     fontSize: 14,
                                        //     fontWeight: FontWeight.bold,
                                        //     color:
                                        //         Color.fromRGBO(92, 136, 218, 1),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Primary Mobile Number",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  phone,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            // InkWell(
                            //   onTap: () {
                            //     dialog();
                            //   },
                            //   child: Row(
                            //     children: const [
                            //       Image(
                            //         image:
                            //             AssetImage('assets/images/Pencil.png'),
                            //       ),
                            //       Text(
                            //         "Edit",
                            //         style: TextStyle(
                            //           fontSize: 14,
                            //           fontWeight: FontWeight.normal,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date of Birth",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              dob,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "My Address",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              address,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          _blockAccount();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Image(
                              image: AssetImage("assets/images/block.png"),
                            ),
                            const Text(
                              "Block",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 55,
                      ),
                      InkWell(
                        onTap: () {
                          _deleteAccount();
                        },
                        child: Column(
                          children: [
                            const Image(
                              image: AssetImage("assets/images/Delete.png"),
                            ),
                            const Text(
                              "Delete",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    height: 7,
                    color: Colors.grey[200],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 52,
                              width: MediaQuery.of(context).size.width - 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(7),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      "Active Order",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "07",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromRGBO(92, 136, 218, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 7,
                    color: Colors.grey[200],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   "Document’s",
                        //   style: TextStyle(
                        //     fontSize: 12,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 12,
                        // ),
                        // Text(
                        //   "Aadhar Number",
                        //   style: TextStyle(
                        //       fontSize: 12,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.grey[600]),
                        // ),
                        // Text(
                        //   "1234-4567-7891-0987",
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // children: [
                            //   Column(
                            //     children: const [
                            //       const Image(
                            //         height: 99,
                            //         width: 149,
                            //         fit: BoxFit.contain,
                            //         image:
                            //             AssetImage('assets/images/addharfront.png'),
                            //       ),
                            //       Text(
                            //         "Front",
                            //         style: TextStyle(
                            //           fontSize: 11,
                            //           fontWeight: FontWeight.normal,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            //   SizedBox(
                            //     width: 25,
                            //   ),
                            //   Column(
                            //     children: const [
                            //       const Image(
                            //         height: 99,
                            //         width: 149,
                            //         fit: BoxFit.contain,
                            //         image:
                            //             AssetImage('assets/images/addharback.png'),
                            //       ),
                            //       Text(
                            //         "Back",
                            //         style: TextStyle(
                            //           fontSize: 11,
                            //           fontWeight: FontWeight.normal,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ],
                            ),
                      ],
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
