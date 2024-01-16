import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/statemanagemnt/provider/CustomerDataProvider.dart';
import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
import 'package:provider/provider.dart';
import '../../widgets/question.dart';
import '../../widgets/CustomText.dart';
import '../models/Data.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Customers extends StatefulWidget {
  const Customers({super.key});

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  bool isChecked = true;
  var _data = null;
  var page = 1;
  dynamic token = '';
  List _users = [];
  var delivery = [], inactive = [];
  dynamic arrInactive = [];
  final List<String> names = <String>[];
  bool isSelect = false;
  late ScrollController _controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // _inactive();
    _customer();
  }

  @override
  void dispose() {
    // _controller.removeListener(_loadMore);
    super.dispose();
  }

  _customer() async {
    print(token);
    var arr = [];
    var arr1 = [];
    // setState(() {
    delivery = [];
    inactive = [];
    // });
    Future.delayed(Duration(seconds: 1), () {
      showLoader(context);
    });
    // Future.delayed(Duration(seconds: 2), () {
    await Provider.of<CustomerDataProvider>(context, listen: false)
        .customerData(context);
    var res = await Provider.of<CustomerDataProvider>(context, listen: false)
        .customerView;
    // print('res ${res?.data![0].accepectedCustomer![0]}');
    if (res?.data![0].accepectedCustomer?.length == 0 &&
        res?.data![0].rejectedCustomer?.length == 0) {
      setState(() {
        delivery = [];
        inactive = [];
        arr = [];
        arr1 = [];
      });
    } else {
      int? size = res?.data![0].accepectedCustomer?.length;
      int? size1 = res?.data![0].rejectedCustomer?.length;
      if (size != 0) {
        for (int? i = 0; i! < size!; i++) {
          log('item  ${res?.data![0].accepectedCustomer![i].address}');
          arr.add({
            'firstName': res?.data![0].accepectedCustomer![i]?.firstName,
            'lastName': res?.data![0].accepectedCustomer![i].lastName,
            'id': res?.data![0].accepectedCustomer![i].id,
          });
        }
      } else {
        setState(() {
          delivery = [];
          arr = [];
        });
      }
      log(('@@ ${size1}'));
      if (size1 != 0) {
        for (int? i = 0; i! < size1!; i++) {
          log('item  ${res?.data![0].rejectedCustomer![i].address}');
          arr1.add({
            'firstName': res?.data![0].rejectedCustomer![i]?.firstName,
            'lastName': res?.data![0].rejectedCustomer![i].lastName,
            'id': res?.data![0].rejectedCustomer![i].id,
          });
        }
      } else {
        setState(() {
          inactive = [];
          arr1 = [];
        });
      }
    }
    // });
    // delivery = res?.data![0].accepectedCustomer == null
    //     ? []
    //     : [res?.data![0].accepectedCustomer];

    setState(() {
      delivery = arr;
      inactive = arr1;
      arr = [];
      arr1 = [];
    });
    Future.delayed(Duration(seconds: 1), () {
      hideLoader(context);
    });
  }

  _customerInactive() async {
    var active = [], arr = [];
    setState(() {
      inactive = [];
      arr = [];
    });

    Future.delayed(Duration(microseconds: 600), () {
      showLoader(context);
    });
    hideLoader(context);
    Future.delayed(Duration(microseconds: 700), () {
      Provider.of<CustomerDataProvider>(context, listen: false)
          .customerData(context);
      var res = Provider.of<CustomerDataProvider>(context, listen: false)
          .customerView;
      // print('res ${res?.data![0].rejectedCustomer![0]}');
      int? size = res?.data![0].rejectedCustomer?.length;

      if (size == 0) {
        for (int? i = 0; i! < size!; i++) {
          arr.add({
            'firstName': res?.data![0].rejectedCustomer![i].firstName,
            'lastName': res?.data![0].rejectedCustomer![i].lastName,
            'dob': res?.data![0].rejectedCustomer![i].dob,
          });
        }
      } else {
        hideLoader(context);
      }
      setState(() {
        inactive = arr;
      });
    });
    Future.delayed(Duration(microseconds: 600), () {
      hideLoader(context);
    });
    hideLoader(context);
  }

  _inactive() async {
    print(token);
    var arr = [];
    setState(() {
      delivery = [];
      arr = [];
    });
    await Provider.of<CustomerDataProvider>(context, listen: false)
        .customerData(context);
    var res = await Provider.of<CustomerDataProvider>(context, listen: false)
        .customerView;
    log('res ${res?.data![0].rejectedCustomer![0].firstName}');
    int? size = res?.data![0].rejectedCustomer?.length;
    for (int? i = 0; i! < size!; i++) {
      arr.add({
        'firstName': res?.data![0].rejectedCustomer![i].firstName,
        'lastName': res?.data![0].rejectedCustomer![i].lastName,
        'dob': res?.data![0].rejectedCustomer![i].dob,
      });
    }

    setState(() {
      inactive = arr;
    });
  }

  _fetchData() async {
    var res =
        Provider.of<CustomerDataProvider>(context, listen: false).customerView;
    print('res${res!.data![0].accepectedCustomer}');
    delivery = [res!.data];
  }

  @override
  Widget build(BuildContext context) {
    token = Provider.of<SignupDataProvider>(context, listen: false).storedName;
    print(token);
    // _fetchData();
    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Customers',
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(92, 136, 218, 1),
        actions: [],
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
        child: Stack(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Column(
              children: [
                // Container(
                //   height: 60,
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //     child: Align(
                //       alignment: Alignment.centerLeft,
                //       child: SizedBox(
                //         height: 32,
                //         child: TextField(
                //           // autofillHints: "Enter your address",
                //           // obscureText: true,
                //           onChanged: (text) {
                //             // value = text;
                //           },
                //           decoration: const InputDecoration(
                //             fillColor: Colors.transparent,
                //             enabledBorder: UnderlineInputBorder(
                //               borderSide: BorderSide(
                //                 width: 2.0,
                //                 color: Colors.grey,
                //               ),
                //             ),
                //             filled: false,
                //             hintText: "Search customer",
                //             suffixIcon: Image(
                //               image: AssetImage('assets/images/Search.png'),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
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
                        // Add your onPressed logic here
                        Navigator.pushNamed(context, '/screens/Location');
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
                              'Add Customers',
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
                  // width: MediaQuery.of(context).size.width - 22,
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
                          _customer()
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
                                fontSize: 14,
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
                          _customer()
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
                isChecked
                    ? Container(
                        height: 450,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: delivery.length != 0
                            ? ListView.builder(
                                itemCount: delivery.length,
                                itemBuilder: (context, index) {
                                  print(delivery);
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
                                              '/screens/CustomersProfile',
                                              arguments: {
                                                "id": delivery![index]['id']
                                                    .toString()
                                              })
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 9,
                                                  width: 9,
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 6, 10, 0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            9),
                                                  ),
                                                ),
                                                Text(
                                                  delivery![index]['firstName']
                                                          .toString() +
                                                      ' ' +
                                                      delivery![index]
                                                              ['lastName']
                                                          .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    // backgroundColor: Colors.amber,
                                                    height: 2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Text(
                                            //   delivery[index]['Holiday'],
                                            //   style: const TextStyle(
                                            //     fontSize: 12,
                                            //     color: Colors.black,
                                            //     // backgroundColor: Colors.amber,
                                            //     height: 2,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                })
                            : Center(
                                child: Container(
                                  child: Text(
                                    'No Active Customer found',
                                    style:
                                        TextStyle(fontSize: 14, fontFamily: ''),
                                  ),
                                ),
                              ),
                      )
                    : Container(
                        height: 450,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: inactive.length != 0
                            ? ListView.builder(
                                itemCount: inactive.length,
                                itemBuilder: (context, index) {
                                  print(inactive![0]);
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
                                          Navigator.pushNamed(
                                              context, '/screens/CSAddRequest',
                                              arguments: {
                                                "id": inactive![index]['id']
                                                    .toString()
                                              })
                                          // Navigator.pushNamed(context,
                                          //     '/screens/CustomersProfile',
                                          //     arguments: {
                                          //       "id": inactive![index]['id']
                                          //     })
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 9,
                                                  width: 9,
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 6, 10, 0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            9),
                                                  ),
                                                ),
                                                Text(
                                                  inactive![index]['firstName']
                                                          .toString() +
                                                      ' ' +
                                                      inactive![index]
                                                              ['lastName']
                                                          .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    // backgroundColor: Colors.amber,
                                                    height: 2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Text(
                                            //   delivery[index]['Holiday'],
                                            //   style: const TextStyle(
                                            //     fontSize: 12,
                                            //     color: Colors.black,
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
                            : Center(
                                child: Container(
                                  child: Text(
                                    'No Inactive Customer found',
                                    style:
                                        TextStyle(fontSize: 14, fontFamily: ''),
                                  ),
                                ),
                              ),
                      )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
