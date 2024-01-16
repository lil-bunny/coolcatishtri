import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/services/global.dart';
import 'package:ishtri_db/statemanagemnt/provider/CustomerDataProvider.dart';
import 'package:ishtri_db/widgets/CButton.dart';
import 'package:ishtri_db/widgets/question.dart';
import 'package:provider/provider.dart';

class CustomersProfile extends StatefulWidget {
  const CustomersProfile({super.key});

  @override
  State<CustomersProfile> createState() => _CustomersProfileState();
}

class _CustomersProfileState extends State<CustomersProfile> {
  dynamic routes = Map<String, String>;
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
      amount = '',
      unique_id = '';
  int? c_id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      _details();
    });
  }

  @override
  void dispose() {
    // _controller.removeListener(_loadMore);
    super.dispose();
  }

  toast(String name) {
    return Fluttertoast.showToast(
      msg: name,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  _customerDelete() async {
    dynamic data = {
      "id": c_id.toString(),
      "status": "0",
      "type": "5",
    };
    await Provider.of<CustomerDataProvider>(context, listen: false)
        .deletecustomerData(context, data);

    final res =
        Provider.of<CustomerDataProvider>(context, listen: false).dbDeleteUser;
    print('res$res');
    if (res?.status == 1) {
      toast(res?.data![0].message.toString() as String);
      Navigator.of(context).pop(true);
    } else {
      toast(res?.data![0].message.toString() as String);
    }
  }

  _editAlterPhone() async {
    try {
      dynamic data = {};
      if (edit_alternate_phone_no == '') {
        showErrorPopup(context, 'Alert!', "Please select any helper");
      } else {
        data = {
          "alternate_phone_no": edit_alternate_phone_no,
          "customer_id": c_id
        };
        Future.delayed(const Duration(microseconds: 700), () {
          showLoader(context);
        });
        final data1 = await ApiService().sendPostRequest(
            '/v1/delivery-boy/customer/update-customer-details', data);
        if (kDebugMode) {
          log('@@ ${data1['data']['data']}');
        }
        if (data1['data']['status'] == 1) {
          hideLoader(context);
          _details();
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

  _refundAmount() async {
    try {
      dynamic data = {};
      if (amount == '') {
        showErrorPopup(context, 'Alert!', "Please enter the amount");
      } else {
        data = {"customer_id": c_id, "refundable_amount": amount};
        Future.delayed(const Duration(microseconds: 700), () {
          showLoader(context);
        });
        final data1 = await ApiService()
            .sendPostRequest('/v1/delivery-boy/customer/refund-amount', data);
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

  _customerBlock() async {
    dynamic data1 = {
      "customer_id": c_id.toString(),
    };
    try {
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      final data = await ApiService()
          .sendPostRequest('/v1/delivery-boy/customer/block-customer', data1);
      if (kDebugMode) {
        log('@@ ${data['data']}');
      }
      if (data1['data']['status'] == 1) {
        hideLoader(context);
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        hideLoader(context);
      }
    } catch (e) {
      hideLoader(context);
    }
  }

  _details() async {
    // Future.delayed(Duration(seconds: 3), () {
    log('@@@ ${routes}');
    await Provider.of<CustomerDataProvider>(context, listen: false)
        .viewCustomerData(context, routes['id']);
    // ignore: use_build_context_synchronously
    var res = Provider.of<CustomerDataProvider>(context, listen: false);
    print('customerDetails ${res.customerDetails?.data?.activeOrderId}');
    // })
    // arr = [res?.data![0].dbDetails == null ? [] : res?.data![0].dbDetails];
    setState(() {
      firstName = (res.customerDetails?.data?.firstName == ''
          ? ''
          : '${res.customerDetails?.data?.firstName ?? ''} ${res.customerDetails?.data!?.lastName ?? ''}')!;
      address = (res.customerDetails?.data?.address == ''
          ? ''
          : res.customerDetails?.data?.address ?? '')!;
      primary_phone_no = res.customerDetails?.data?.primaryPhoneNo == ''
          ? ''
          : res.customerDetails?.data?.primaryPhoneNo! ?? '';
      // ignore: null_check_always_fails
      alternate_phone_no = res.customerDetails?.data?.alternatePhoneNo ?? '';
      c_id = res.customerDetails?.data?.id! ?? 0;
      unique_id = res.customerDetails?.data?.activeOrderId ?? '';
    });
    print(firstName);
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

  void _acceptCash() async {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: double.maxFinite,
              height: 330,
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: acceptCashDialog(),
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

  void _editPhone() async {
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
              child: editDialog(),
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
                                    "Accept Cash Payment",
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

  Widget acceptCashDialog() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState1) {
        return Container(
          height: 360,
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
                                    "Accept Cash Payment",
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
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'Refund will be adjust in future orders bills.',
                                style: TextStyle(
                                  color: blackColor,
                                  fontFamily: "Poppins-Regular",
                                  fontSize: 14,
                                ),
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

  Widget editDialog() {
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
                                    "Edit Contact Number",
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
                                SizedBox(
                                  height: 52,
                                  child: TextField(
                                    onChanged: (text) {
                                      edit_alternate_phone_no = text;
                                    },
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
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
                                        "Confirm ",
                                        () {
                                          _editAlterPhone();
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
    routes = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    print('routes $routes');
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromRGBO(92, 136, 218, 1), //const Color(0x5C88DA),
        title: const Text(
          "Customers",
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
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Customer Name",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    firstName!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
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
                                  "Primary Mobile Number",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  primary_phone_no!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: const [
                                // Image(
                                //   image: AssetImage('assets/images/Pencil.png'),
                                // ),
                                Text(
                                  "Edit",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Alternate Mobile Number",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  alternate_phone_no!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                _editPhone();
                              },
                              child: Row(
                                children: const [
                                  Image(
                                    image:
                                        AssetImage('assets/images/Pencil.png'),
                                  ),
                                  Text(
                                    "Edit",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
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
                              "Laundry Address",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              address!,
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
                        InkWell(
                          onTap: () => Navigator.pushNamed(
                            context,
                            "/screens/SpecialServiceRate",
                            arguments: {
                              "customer_id": c_id.toString(),
                            },
                          ),
                          child: const Text(
                            "Special Service Rate",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(92, 136, 218, 1)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: () {
                      _blockAccount();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
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
                        const SizedBox(
                          width: 25,
                        ),
                        InkWell(
                          onTap: () => {_deleteAccount()},
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
                        InkWell(
                          onTap: () {
                            _acceptCash();
                          },
                          child: Column(
                            children: [
                              const Image(
                                image:
                                    AssetImage("assets/images/Transaction.png"),
                              ),
                              const Text(
                                "Refund",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
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
                                  children: [
                                    Text(
                                      "Active Order",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      unique_id.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color.fromRGBO(92, 136, 218, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        payment != ''
                            ? Container(
                                decoration: BoxDecoration(
                                    color: const Color.fromRGBO(190, 58, 58, 1),
                                    borderRadius: BorderRadius.circular(9)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Rs. 256 Payment Pending",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Container(
                                        height: 36,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                270,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(7),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0,
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: TextButton(
                                          onPressed: () {},
                                          child: const Text(
                                            "Accept Cash",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color.fromRGBO(
                                                  92, 136, 218, 1),
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
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/screens/CustomerOrders",
                          arguments: {"c_id": c_id.toString()});
                    },
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(18.0, 0, 0, 0),
                      child: Text(
                        "Check order history",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(92, 136, 218, 1),
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
    );
  }
}
