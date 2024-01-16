import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/statemanagemnt/provider/CustomerDataProvider.dart';
import 'package:provider/provider.dart';

class CSAddRequest extends StatefulWidget {
  const CSAddRequest({super.key});

  @override
  State<CSAddRequest> createState() => _CSAddRequestState();
}

class _CSAddRequestState extends State<CSAddRequest> {
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
      primary_phone_no = (res.customerDetails?.data?.primaryPhoneNo == ''
          ? ''
          : res.customerDetails?.data?.primaryPhoneNo ?? '')!;
      alternate_phone_no = res.customerDetails!.data?.alternatePhoneNo! ?? '';
      c_id = res.customerDetails?.data?.id!;
      unique_id = res.customerDetails?.data?.activeOrderId!;
    });
    print(firstName);
  }

  _accept_reject(statusUser) async {
    try {
      dynamic data = {};
      data = {"customer_id": c_id, "status": statusUser};
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      final data1 = await ApiService().sendPostRequest(
          '/v1/delivery-boy/customer/accept-or-reject-customer', data);
      if (kDebugMode) {
        log('@@ ${data1['data']['data']}');
      }
      if (data1['data']['status'] == 1) {
        hideLoader(context);
        Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    routes = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
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
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    firstName.toString(),
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
                                  primary_phone_no.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: HexColor('#5C88DA')),
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
                                  alternate_phone_no.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: HexColor('#5C88DA'),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
                              "Customer Address",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              address.toString(),
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
                    height: 1,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 42,
                            width: MediaQuery.of(context).size.width - 280,
                            margin: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                            decoration: BoxDecoration(
                              color: HexColor('#BE3A3A'),
                              borderRadius: BorderRadius.all(
                                Radius.circular(7),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                // submit();
                                _accept_reject('2');
                              },
                              child: Text(
                                "Reject".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 42,
                            width: MediaQuery.of(context).size.width - 280,
                            margin: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                            decoration: BoxDecoration(
                              color: HexColor('#1C2941'),
                              borderRadius: BorderRadius.all(
                                Radius.circular(7),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                // submit();
                                _accept_reject('1');
                              },
                              child: Text(
                                "Accept".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
