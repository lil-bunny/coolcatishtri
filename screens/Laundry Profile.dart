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
import 'package:ishtri_db/widgets/CButton.dart';

class LaundryProfile extends StatefulWidget {
  const LaundryProfile({super.key});

  @override
  State<LaundryProfile> createState() => _LaundryProfileState();
}

class _LaundryProfileState extends State<LaundryProfile> {
  dynamic routes = Map<String, String>, _userDetails = [];
  String? firstName = '',
      lastName = '',
      email = '',
      image = '',
      primary_phone_no = '',
      alternate_phone_no = '',
      edit_alternate_phone_no = '',
      address = '',
      city = '',
      pincode = '',
      payment = '',
      amount = '';
  int? c_id;
  dynamic holiday = [];

  _laundryDetails() async {
    try {
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      final data1 = await ApiService().sendGetRequest(
          '/v1/delivery-boy/laundry-service/laundry-details/${routes['id']}');
      if (kDebugMode) {
        log('@@ ${data1['data']['data']}');
      }
      if (data1['data']['status'] == 1) {
        setState(() {
          _userDetails = data1['data']['data'];
        });
        for (int i = 0; i < data1['data']['data'].length; i++) {
          // holiday.add({});
        }
        hideLoader(context);
      } else {
        var mes = '';
        mes = data1['data']['data']['message'];
        hideLoader(context);
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
    Future.delayed(const Duration(seconds: 1), () {
      hideLoader(context);
    });
  }

  _refundAmount() async {
    try {
      dynamic data = {};
      if (amount == '') {
        showErrorPopup(context, 'Alert!', "Please enter the amount");
      } else {
        data = {"ls_id": _userDetails['id'], "amount": amount};
        Future.delayed(const Duration(microseconds: 700), () {
          showLoader(context);
        });
        log('@@@ ${data}');
        final data1 = await ApiService()
            .sendPostRequest('/v1/delivery-boy/auth/payment-by-db-to-lS', data);
        if (kDebugMode) {
          log('@@ ${data1['data']['data']}');
        }
        if (data1['data']['status'] == 1) {
          var mes = '';
          mes = data1['data']['data']['message'];
          toast(mes);
          hideLoader(context);
          Navigator.pop(context);
        } else {
          var mes = '';
          mes = data1['data']['data']['message'];
          hideLoader(context);
          toast(mes!);
        }
        hideLoader(context);
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
    } catch (e) {}
    Future.delayed(const Duration(seconds: 1), () {
      hideLoader(context);
    });
  }

  void _showRefund() async {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: double.maxFinite,
              height: 230,
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: refundDialog(),
            ),
          );
        });
  }

  Widget refundDialog() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState1) {
        return Container(
          height: 360,
          width: MediaQuery.of(context).size.width - 90,
          child: Column(
            children: [
              Container(
                height: 200,
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
                                    "Accept Due Payment",
                                    style: TextStyle(
                                      color: lightBlackColor,
                                      fontFamily: "Poppins-bold",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    'Enter Amount',
                                    style: TextStyle(
                                        color: blackColor,
                                        fontFamily: "Poppins-Regular",
                                        fontSize: 16),
                                  ),
                                ),
                                SizedBox(
                                  height: 32,
                                  child: TextField(
                                    onChanged: (text) {
                                      amount = text;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      fillColor: Colors.transparent,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      filled: false,
                                    ),
                                  ),
                                ),
                              ],
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
                                        "Confirm recived ",
                                        () {
                                          _refundAmount();
                                          Navigator.pop(context);
                                        },
                                        MediaQuery.of(context).size.width *
                                            0.45,
                                        HexColor('#1C2941'),
                                        whiteColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
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
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      _laundryDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    routes = ModalRoute.of(context)?.settings.arguments as dynamic;
    log('@@@ ${routes}');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Image(
            image: AssetImage("assets/images/ChevronLeft.png"),
            height: 22,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor:
            const Color.fromRGBO(92, 136, 218, 1), //const Color(0x5C88DA),
        title: const Text(
          "Laundry's",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _userDetails['new_profile_image_name'] == null
                                  ? Image(
                                      image: AssetImage(
                                          'assets/images/AccountLaundry.png'),
                                    )
                                  : ClipOval(
                                      child: Image.network(
                                          height: 100.0,
                                          width:
                                              100, // Adjust the width and height as needed
                                          fit: BoxFit.cover,
                                          _userDetails['new_profile_image_name']
                                              .toString())),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Laundry Name",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _userDetails['laundry_aditional_detail']
                                          ['laundry_name'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            "/screens/LaundryServiceMyRate",
                                            arguments: {
                                              "id":
                                                  _userDetails['id'].toString()
                                            });
                                      },
                                      child: Text(
                                        "View / Edit Services & Rates",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromRGBO(
                                                92, 136, 218, 1)),
                                      ),
                                    ),
                                  ],
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
                                    "Laundry Contact Number",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    _userDetails['primary_phone_no'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: const [
                              //     Image(
                              //       image:
                              //           AssetImage('assets/images/Pencil.png'),
                              //     ),
                              //     Text(
                              //       "Edit",
                              //       style: TextStyle(
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.normal,
                              //       ),
                              //     ),
                              //   ],
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
                                "Next Holiday ",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              _userDetails['laundry_holidays'].length > 0
                                  ? Container(
                                      height: 32,
                                      width: MediaQuery.of(context).size.width *
                                          .55,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            _userDetails['laundry_holidays']
                                                .length,
                                        itemBuilder: (context, index1) {
                                          return Text(
                                            _userDetails['laundry_holidays']
                                                        [index1]['day'] ==
                                                    1
                                                ? "Sunday, "
                                                : _userDetails['laundry_holidays']
                                                            [index1]['day'] ==
                                                        2
                                                    ? "Monday, "
                                                    : _userDetails['laundry_holidays']
                                                                    [index1]
                                                                ['day'] ==
                                                            3
                                                        ? "Tuesday, "
                                                        : _userDetails['laundry_holidays']
                                                                        [index1]
                                                                    ['day'] ==
                                                                4
                                                            ? "Wednesday, "
                                                            : _userDetails['laundry_holidays']
                                                                            [index1][
                                                                        'day'] ==
                                                                    5
                                                                ? "Thusday, "
                                                                : _userDetails['laundry_holidays'][index1]
                                                                            ['day'] ==
                                                                        6
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
                                    )
                                  : Container(
                                      margin: EdgeInsets.symmetric(vertical: 7),
                                      child: Text(
                                        'No holiday',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Laundry Address",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                _userDetails['address'],
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
                      height: 7,
                      color: Colors.grey,
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
                                width: MediaQuery.of(context).size.width - 240,
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
                                child: TextButton(
                                  onPressed: () {
                                    // Navigator.pushNamed(
                                    //     context, "/screens/LaundryOrders");
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Active Order",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        _userDetails['active_order_count']
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 52,
                                width: MediaQuery.of(context).size.width - 240,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(91, 91, 91, 1),
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
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, "/screens/LaundryOrders");
                                  },
                                  child: const Text(
                                    "Order History",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          _userDetails['pending_amount'] != 0
                              ? Container(
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromRGBO(190, 58, 58, 1),
                                      borderRadius: BorderRadius.circular(9)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Rs. ${_userDetails['pending_amount']} Payment Due",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Container(
                                          height: 36,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              290,
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                91, 91, 91, 1),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(7),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 0,
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              _showRefund();
                                            },
                                            child: const Text(
                                              "Pay",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Container(
                      height: 7,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Owner Name ",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                _userDetails['firstName'].toString() +
                                    ' ' +
                                    _userDetails['lastName'].toString(),
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
                                "Owner Mobile Number",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                _userDetails['primary_phone_no'],
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
                                "Current Address",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                _userDetails['address'],
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
                        ],
                      ),
                    ),
                    Container(
                      height: 7,
                      color: Colors.grey,
                    ),
                    // const SizedBox(
                    //   height: 12,
                    // ),
                    // Container(
                    //   width: MediaQuery.of(context).size.width - 42,
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       const Text(
                    //         "Document’s",
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.normal,
                    //         ),
                    //       ),
                    //       const SizedBox(
                    //         height: 12,
                    //       ),
                    //       Text(
                    //         "Aadhar Number",
                    //         style: TextStyle(
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.normal,
                    //           color: Colors.grey[700],
                    //         ),
                    //       ),
                    //       const Text(
                    //         "1234-4567-7891-0987",
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.normal,
                    //         ),
                    //       ),
                    //       const SizedBox(
                    //         height: 12,
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Column(
                    //             children: const [
                    //               const Image(
                    //                 height: 99,
                    //                 width: 149,
                    //                 fit: BoxFit.contain,
                    //                 image: AssetImage(
                    //                     'assets/images/addharfront.png'),
                    //               ),
                    //               Text(
                    //                 "Front",
                    //                 style: TextStyle(
                    //                   fontSize: 11,
                    //                   fontWeight: FontWeight.normal,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //           Column(
                    //             children: const [
                    //               const Image(
                    //                 height: 99,
                    //                 width: 149,
                    //                 fit: BoxFit.contain,
                    //                 image: AssetImage(
                    //                     'assets/images/addharback.png'),
                    //               ),
                    //               Text(
                    //                 "Back",
                    //                 style: TextStyle(
                    //                   fontSize: 11,
                    //                   fontWeight: FontWeight.normal,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //       const SizedBox(
                    //         height: 25,
                    //       ),
                    //       Column(
                    //         children: const [
                    //           const Image(
                    //             height: 99,
                    //             width: 149,
                    //             fit: BoxFit.contain,
                    //             image: AssetImage('assets/images/shop.png'),
                    //           ),
                    //           Text(
                    //             "Shop",
                    //             style: TextStyle(
                    //               fontSize: 11,
                    //               fontWeight: FontWeight.normal,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       const SizedBox(
                    //         height: 12,
                    //       ),
                    //       const Text(
                    //         "GST Number ",
                    //         style: TextStyle(
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.normal,
                    //         ),
                    //       ),
                    //       const Text(
                    //         "1234-4567-7891-0987",
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.normal,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 25,
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
