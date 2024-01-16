import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/models/City.dart';
import 'package:ishtri_db/screens/Customers.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/services/global.dart';
import 'package:ishtri_db/statemanagemnt/provider/CustomerDataProvider.dart';
import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
import 'package:ishtri_db/widgets/CButton.dart';
import 'package:ishtri_db/widgets/CapitalizeFirstLetterText.dart';
import 'package:ishtri_db/widgets/question.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io' as Io;

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  bool _isChecked = false;
  List _tower = [];
  String _currindex = '';
  String _currindex1 = '';
  String _currindexCity = '';
  String society = '';
  String tower = '';
  var _numberForm = GlobalKey<FormState>();
  var fullName = '',
      fname = '',
      lname = '',
      landmark = '',
      state = '',
      stateId = 0,
      city = '',
      cityId = '',
      pincode = '',
      token = '',
      phone_no = '',
      alter_no = '';
  var cityArr = [];
  var stateArr = [];
  FocusNode _inputFocusNode = FocusNode();
  dynamic _society;

  String dob = '';
  City city1 = City();
  DateTime? selectedDate;
  dynamic address = '';
  FocusNode textSecondFocusNode = new FocusNode();
  FocusNode textSecondFocusNode1 = new FocusNode();
  FocusNode textSecondFocusNode2 = new FocusNode();
  FocusNode textSecondFocusNode3 = new FocusNode();
  FocusNode textSecondFocusNode4 = new FocusNode();

  String _txtSociety = '',
      _txtTower = '',
      _societySel = '',
      _towersel = '',
      _societyId = '',
      _towerId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _societyAll();
    _towerAll();
    getCity('1');
    // Future.delayed(Duration(milliseconds: 1000), () {
    getCityD();
    // });
  }

  toast(String name) {
    return Fluttertoast.showToast(
        msg: name,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }

  _societyAll() async {
    print('hello');
    try {
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      final data1 = await ApiService()
          .sendGetRequest('/v1/delivery-boy/schedule/society-list');
      if (kDebugMode) {
        print('@@ ${data1['data']}');
      }
      if (data1['data']['status'] == 1) {
        setState(() {
          _society = data1['data']['data'];
        });
        hideLoader(context);
      } else {
        var mes = '';
        mes = data1['data']['message'];
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

  _towerAll() async {
    try {
      dynamic data = {};
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      final data1 = await ApiService()
          .sendGetRequest('/v1/delivery-boy/schedule/tower-list');
      if (kDebugMode) {
        print('@@ ${data1['data']['data']}');
      }
      if (data1['data']['status'] == 1) {
        setState(() {
          _tower = data1['data']['data'];
        });
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

  bool validateStringWithoutNumbers(String input) {
    // Define a regex pattern to match strings without numbers
    String pattern = r'^[^\d]+$';

    // Create a RegExp object
    RegExp regex = RegExp(pattern);

    // Test the input against the regex pattern
    return regex.hasMatch(input);
  }

  Future<void> AddCustomer() async {
    try {
      if (fname == '') {
        showErrorPopup(context, 'Alert!', 'Please enter your first name');
      } else if (!validateStringWithoutNumbers(fname)) {
        showErrorPopup(
            context, 'Alert!', 'Please enter correct formate first name');
      } else if (lname == '') {
        showErrorPopup(context, 'Alert!', 'Please enter your last name');
      } else if (!validateStringWithoutNumbers(lname)) {
        showErrorPopup(
            context, 'Alert!', 'Please enter correct formate last name');
      } else if (phone_no == '') {
        showErrorPopup(context, 'Alert!', 'Please enter your mobile number');
      } else if (!validatePhoneNumber(phone_no)) {
        showErrorPopup(context, 'Alert!',
            'Please enter your correct formate mobile number');
      } else if (address == '') {
        showErrorPopup(context, 'Alert!', 'Please enter your address');
        // } else if (!validateStringWithoutNumbers(address)) {
        //   showErrorPopup(
        //       context, 'Alert!', 'Please enter correct formate address');
      } else if (city == '') {
        showErrorPopup(context, 'Alert!', 'Please select your city');
      } else if (pincode == '') {
        showErrorPopup(context, 'Alert!', 'Please enter your pincode');
      } else if (!validatePincode(pincode)) {
        showErrorPopup(
            context, 'Alert!', 'Please enter your correct formate pincode');
      } else if (landmark == '') {
        showErrorPopup(context, 'Alert!', 'Please enter your landmark');
        // } else if (!validateStringWithoutNumbers(landmark)) {
        //   showErrorPopup(context, 'Alert!', 'Please enter correct landmark');
      } else if (society == '') {
        showErrorPopup(context, 'Alert!', 'Select your society');
      } else if (tower == '') {
        showErrorPopup(context, 'Alert!', 'Select your tower / block');
      } else {
        var data = {
          "firstName": fname,
          "lastName": lname,
          "primary_phone_no": phone_no.toString(),
          // "alternate_phone_no": alter_no.toString(),
          "address": address,
          "society_id": _societyId,
          "tower_id": _towerId,
          "society_name": society,
          "tower_name": tower.toString(),
          "street": landmark,
          "city": cityId.toString(),
          "pincode": pincode,
        };
        Future.delayed(Duration(microseconds: 700), () {
          showLoader(context);
        });
        print('@@@ ${data}');
        final data1 = await ApiService()
            .sendPostRequest('/v1/delivery-boy/customer/add-customer', data);
        if (kDebugMode) {
          print('@@ ${data1['data']}');
        }
        if (data1['data']['status'] == 1) {
          var arr = [];
          var mes = '';
          for (var i = 0; i < data1['data']['data'].length; i++) {
            // log('@@@ ${res['data'][i]}');
            arr.add(data1['data']['data'][i]);
          }

          for (dynamic item in arr) {
            item.forEach((key, value) {
              print('Key: $key, Value: $value');
              mes = value.replaceAll('"', '') + '.';
            });
          }

          toast(mes!);
          hideLoader(context);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed('/screens/Customers');
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
        var arr = [];
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
  }

  void newSociety() {
    try {
      setState(() {
        _society.add({"name": _txtSociety, "id": ""});
      });
      Navigator.pop(context);
    } catch (e) {}
  }

  void newTower() {
    try {
      setState(() {
        _tower.add({"name": _txtTower, "id": "", "isSelect": true});
      });
      Navigator.pop(context);
    } catch (e) {}
  }

  void _newTower() async {
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
              child: towerDialog(),
            ),
          );
        });
  }

  void _newSociety() async {
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
              child: societyDialog(),
            ),
          );
        });
  }

  Widget societyDialog() {
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
                        padding: EdgeInsets.only(left: 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0, top: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Enter your society name",
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
                                      _txtSociety = text;
                                    },
                                    decoration: InputDecoration(
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
                                      padding: EdgeInsets.all(0),
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
                                          newSociety();
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

  Widget towerDialog() {
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
                        padding: EdgeInsets.only(left: 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0, top: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Enter your tower / block",
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
                                      _txtTower = text;
                                    },
                                    decoration: InputDecoration(
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
                                      padding: EdgeInsets.all(0),
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
                                          newTower();
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

  getCity(id) async {
    var data = {
      "id": id,
    };
    Provider.of<SignupDataProvider>(context, listen: false)
        .getDataCity(context, data);
  }

  getCityD() {
    cityArr = [];
    final postMdl = Provider.of<SignupDataProvider>(context, listen: false);
    print('postMdl${postMdl.loading}');
    postMdl.city?.data
        ?.map((item) => {
              print('city ${item.id}'),
              // print('postMdl  ${postMdl.city!.data}')
              cityArr.add({
                "id": item.id,
                "name": item.name,
                "isSelect": false,
              })
            })
        .toList();

    print(cityArr);
  }

  getState() {
    stateArr = [];
    final postMdl = Provider.of<SignupDataProvider>(context);
    print('postMdl${postMdl.loading}');
    postMdl.state?.data
        ?.map((item) => {
              print('city ${item.id}'),
              // print('postMdl  ${postMdl.city!.data}')
              stateArr.add({
                "id": item.id,
                "name": item.name,
                "isSelect": false,
              })
            })
        .toList();

    print(stateArr);
  }

  CustomDialogCity(BuildContext context) {
    // DialogHelper();

    return Dialog(
      // Add your custom dialog content here
      child: Container(
        // padding: EdgeInsets.all(0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Select City',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: '',
                ),
              ),
            ),
            Container(
              height: 2,
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: cityArr.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => {
                        setState(() {
                          city = cityArr[index]['name'];
                          cityId = cityArr[index]['id'].toString();
                          _currindexCity = index.toString();
                        }),
                        Navigator.of(context).pop()
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              height: 22,
                              width: 22,
                              margin: const EdgeInsets.fromLTRB(0, 0, 9, 0),
                              decoration: BoxDecoration(
                                  color: HexColor('#D9D9D9'),
                                  borderRadius: BorderRadius.circular(17)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 14,
                                    width: 14,
                                    decoration: BoxDecoration(
                                        color: _currindexCity == ''
                                            ? HexColor('#ffff')
                                            : _currindexCity == index.toString()
                                                ? HexColor('#5C88DA')
                                                : HexColor('#ffff'),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              cityArr[index]['name'],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // To close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  CustomDialogSociety(BuildContext context) {
    // DialogHelper();

    return Dialog(
      // Add your custom dialog content here
      child: Container(
        // padding: EdgeInsets.all(0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Select Society',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: '',
                ),
              ),
            ),
            Container(
              height: 2,
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              height: 180,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: _society.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => {
                        setState(() {
                          // city = cityArr[index]['name'];
                          _societyId = _society[index]['id'].toString() ?? '';
                          _currindex = index.toString();
                          society = _society[index]['name'];
                        }),
                        Navigator.of(context).pop()
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              height: 22,
                              width: 22,
                              margin: const EdgeInsets.fromLTRB(0, 0, 9, 0),
                              decoration: BoxDecoration(
                                  color: HexColor('#D9D9D9'),
                                  borderRadius: BorderRadius.circular(17)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 14,
                                    width: 14,
                                    decoration: BoxDecoration(
                                        color: _currindex == ''
                                            ? HexColor('#ffff')
                                            : _currindex == index.toString()
                                                ? HexColor('#5C88DA')
                                                : HexColor('#ffff'),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              _society[index]['name'] ?? '',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // To close the dialog
                _newSociety();
              },
              child: const Text('Add New Society'),
            ),
          ],
        ),
      ),
    );
  }

  CustomDialogTower(BuildContext context) {
    // DialogHelper();

    return Dialog(
      // Add your custom dialog content here
      child: Container(
        // padding: EdgeInsets.all(0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Select Tower / Block / Section',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: '',
                ),
              ),
            ),
            Container(
              height: 2,
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              height: 180,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: _tower.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => {
                        setState(() {
                          // city = _Tower[index]['name'];
                          _towerId = _tower[index]['id'].toString();
                          tower = _tower[index]['name'];
                          _currindex1 = index.toString();
                        }),
                        Navigator.of(context).pop()
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              height: 22,
                              width: 22,
                              margin: const EdgeInsets.fromLTRB(0, 0, 9, 0),
                              decoration: BoxDecoration(
                                  color: HexColor('#D9D9D9'),
                                  borderRadius: BorderRadius.circular(17)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 14,
                                    width: 14,
                                    decoration: BoxDecoration(
                                        color: _currindex1 == index.toString()
                                            ? HexColor('#5C88DA')
                                            : HexColor('#ffff'),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              _tower[index]['name'],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // To close the dialog
                _newTower();
              },
              child: const Text('Add New Tower / Block'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomDialogCity(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogCity(context); // Use the custom dialog widget here
      },
    );
  }

  void _showSocietyDialogCity(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogSociety(
            context); // Use the custom dialog widget here
      },
    );
  }

  void _showTowerDialogCity(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogTower(context); // Use the custom dialog widget here
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // getCityD();
    // getState();
    address =
        Provider.of<CustomerDataProvider>(context, listen: false).location;
    log('loading ${Provider.of<CustomerDataProvider>(context).loading}');

    return Scaffold(
        appBar: AppBar(
          backgroundColor:
              const Color.fromRGBO(92, 136, 218, 1), //const Color(0x5C88DA),
          title: const Text("Add Customer"),
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
        body: SafeArea(
          child: SingleChildScrollView(
              child: Container(
            // height: MediaQuery.of(context).size.height - 170,
            // color: Colors.amber,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Customer Details",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const TextQuestion("Location", FontWeight.bold, 12, '*',
                          Colors.red, Colors.black),
                      SizedBox(
                        // height: 32,
                        child: TextFormField(
                          onChanged: (text) {
                            address = text;
                          },
                          initialValue: address,
                          textCapitalization: TextCapitalization.sentences,
                          inputFormatters: [
                            CapitalizeFirstLetterTextFormatter()
                          ],
                          decoration: const InputDecoration(
                              fillColor: Colors.transparent,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2.0,
                                  color: Colors.grey,
                                ),
                              ),
                              filled: false,
                              hintText: "House number, building, Village"),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const TextQuestion("First Name", FontWeight.bold, 12, '*',
                          Colors.red, Colors.black),
                      SizedBox(
                        height: 32,
                        child: TextFormField(
                          onChanged: (text) {
                            fname = text;
                          },
                          textCapitalization: TextCapitalization.sentences,
                          inputFormatters: [
                            CapitalizeFirstLetterTextFormatter()
                          ],
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(textSecondFocusNode1);
                          },
                          focusNode: textSecondFocusNode,
                          decoration: const InputDecoration(
                            fillColor: Colors.transparent,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 2.0,
                                color: Colors.grey,
                              ),
                            ),
                            filled: false,
                            hintText: "Enter first name",
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const TextQuestion("Last Name", FontWeight.bold, 12, '*',
                          Colors.red, Colors.black),
                      SizedBox(
                        height: 32,
                        child: TextFormField(
                          onChanged: (text) {
                            lname = text;
                          },
                          focusNode: textSecondFocusNode1,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(textSecondFocusNode2);
                          },
                          inputFormatters: [
                            CapitalizeFirstLetterTextFormatter()
                          ],
                          decoration: const InputDecoration(
                              fillColor: Colors.transparent,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2.0,
                                  color: Colors.grey,
                                ),
                              ),
                              filled: false,
                              hintText: "Enter Last name"),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const TextQuestion("Primery Mobile No.", FontWeight.bold,
                          12, '*', Colors.red, Colors.black),
                      SizedBox(
                        child: TextFormField(
                          onChanged: (text) {
                            phone_no = text;
                          },
                          focusNode: textSecondFocusNode2,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(textSecondFocusNode3);
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
                              hintText: ""),
                        ),
                      ),
                      const SizedBox(
                          // height: 25,
                          ),
                      const TextQuestion("Alternate Mobile No", FontWeight.bold,
                          12, '', Colors.red, Colors.black),
                      SizedBox(
                        child: TextField(
                          onChanged: (text) {
                            alter_no = text;
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
                              hintText: "Enter contact number"),
                        ),
                      ),
                      const SizedBox(
                          // height: 25,
                          ),
                      const TextQuestion("Current city/Location",
                          FontWeight.bold, 12, '*', Colors.red, Colors.black),
                      const SizedBox(
                          // height: 25,
                          ),
                      Container(
                        height: 42,
                        width: (MediaQuery.of(context).size.width - 0),
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 2.0, // Adjust the width as needed
                            ),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            _showCustomDialogCity(context);
                            // DialogHelper();
                            _inputFocusNode.requestFocus();
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              city == '' ? "Select City" : city,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const TextQuestion("Select Society", FontWeight.bold, 12,
                          '*', Colors.red, Colors.black),
                      Container(
                        height: 42,
                        width: (MediaQuery.of(context).size.width - 0),
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 2.0, // Adjust the width as needed
                            ),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            _showSocietyDialogCity(context);
                            // DialogHelper();
                            _inputFocusNode.requestFocus();
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              society == '' ? "Select Society" : society,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const TextQuestion("Select Tower / Block / Section",
                          FontWeight.bold, 12, '*', Colors.red, Colors.black),
                      Container(
                        height: 42,
                        width: (MediaQuery.of(context).size.width - 0),
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 2.0, // Adjust the width as needed
                            ),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            _showTowerDialogCity(context);
                            // DialogHelper();
                            _inputFocusNode.requestFocus();
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              tower == ''
                                  ? "Select Tower / Block / Section"
                                  : tower,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        child: TextFormField(
                          onChanged: (text) {
                            pincode = text;
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(textSecondFocusNode4);
                          },
                          focusNode: _inputFocusNode,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: const InputDecoration(
                              fillColor: Colors.transparent,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2.0,
                                  color: Colors.grey,
                                ),
                              ),
                              filled: false,
                              hintText: "Pincode"),
                        ),
                      ),
                      const SizedBox(
                          // height: 12,
                          ),
                      SizedBox(
                        height: 32,
                        child: TextField(
                          onChanged: (text) {
                            landmark = text;
                          },
                          inputFormatters: [
                            CapitalizeFirstLetterTextFormatter()
                          ],
                          focusNode: textSecondFocusNode4,
                          decoration: const InputDecoration(
                              fillColor: Colors.transparent,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2.0,
                                  color: Colors.grey,
                                ),
                              ),
                              filled: false,
                              hintText: "Nearest landmark"),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
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
                        AddCustomer();
                      },
                      child: Text(
                        "Send Request".toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
        )
        // : Center(
        //     child: SpinKitCircle(
        //       color: Colors.white, // Color of the loading indicator
        //       size: 50.0, // Size of the loading indicator
        //     ),
        //   ),
        );
  }
}
