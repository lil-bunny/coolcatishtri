import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:date_field/date_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/statemanagemnt/provider/HelperDataProvider.dart';
import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
import 'package:ishtri_db/widgets/CapitalizeFirstLetterText.dart';
import 'package:ishtri_db/widgets/question.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddHelper extends StatefulWidget {
  const AddHelper({super.key});

  @override
  State<AddHelper> createState() => _AddHelperState();
}

class _AddHelperState extends State<AddHelper> {
  var firstName = '',
      lastName = '',
      email = '',
      primary_phone_no = '',
      alternate_phone_no = '',
      address = '',
      // landmark = '',
      city = '',
      cityId = 0,
      pincode = '',
      street = '';
  var cityArr = [];
  DateTime? selectedDate;
  FocusNode _inputFocusNode = FocusNode();
  FocusNode _inputFocusNode1 = FocusNode();

  var token;
  String dob = '';
  toast(String name) {
    return Fluttertoast.showToast(
        msg: name,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCity('1');
  }

  int calculateYearDifference(DateTime selectedDate) {
    // Get the current date
    DateTime currentDate = DateTime.now();

    // Calculate the difference in years
    int yearDifference = currentDate.year - selectedDate.year;

    // Check if the selected date hasn't occurred yet this year
    if (currentDate.month < selectedDate.month ||
        (currentDate.month == selectedDate.month &&
            currentDate.day < selectedDate.day)) {
      yearDifference--;
    }

    return yearDifference;
  }

  Future<void> AddHelper() async {
    try {
      if (firstName == '') {
        showErrorPopup(context, 'Alert!', 'Please enter your fiist name');
      } else if (!validateStringWithoutNumbers(firstName)) {
        showErrorPopup(
            context, 'Alert!', 'Please enter your correct fiist name');
      } else if (lastName == '') {
        showErrorPopup(context, 'Alert!', 'Please enter your last name');
      } else if (!validateStringWithoutNumbers(lastName)) {
        showErrorPopup(context, 'Alert!', 'Please enter your corect last name');
      } else if (dob == '') {
        showErrorPopup(context, 'Alert!', 'Please select your DOB');
      } else if (calculateYearDifference(selectedDate!) < 18) {
        showErrorPopup(context, 'Alert!',
            'You can only add helpers who are >18 years old');
      } else if (primary_phone_no == '') {
        showErrorPopup(
            context, 'Alert!', 'Please enter your primary phone number');
      } else if (primary_phone_no.length < 10) {
        showErrorPopup(
            context, 'Alert!', 'Please enter 10 digit primary phone number');
      } else if (!validatePhoneNumber(primary_phone_no)) {
        showErrorPopup(context, 'Alert!',
            'Please enter your correct primary phone number');
      } else if (address == '') {
        print(address);
        showErrorPopup(context, 'Alert!', 'Please enter your address');
        // } else if (!validateStringWithoutNumbers(address)) {
        //   showErrorPopup(context, 'Alert!', 'Please enter your correct address');
      } else if (city == '') {
        showErrorPopup(context, 'Alert!', 'Please select your city');
      } else if (pincode == '') {
        showErrorPopup(context, 'Alert!', 'Please enter your pincode');
      } else if (!validatePincode(pincode)) {
        showErrorPopup(context, 'Alert!', 'Please enter your correct pincode');
      } else {
        var data = {
          "firstName": firstName,
          "lastName": lastName,
          "dob": dob,
          "primary_phone_no": primary_phone_no,
          "alternate_phone_no": alternate_phone_no,
          "address": address,
          "city": cityId.toString(),
          "pincode": pincode,
          "street": 'vip road',
        };
        Future.delayed(Duration(microseconds: 700), () {
          showLoader(context);
        });
        log('@@@ ${data}');
        final data1 = await ApiService()
            .sendPostRequest('/v1/delivery-boy/helper/add-helper', data);
        if (kDebugMode) {
          log('@@ ${data1['data']['data']}');
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
// showConfirmPopup(context, heading, title, textOK, textCancel)
          showErrorPopup(context, 'Thank You', mes!);
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pop(context);
          });
          hideLoader(context);
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pushNamed('/screens/Thankyouhelper');
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

  getCity(id) async {
    var data = {
      "id": id,
    };
    Provider.of<SignupDataProvider>(context, listen: false)
        .getDataCity(context, data);
  }

  getCityD() async {
    cityArr = [];
    final postMdl = Provider.of<SignupDataProvider>(context);
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
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: cityArr.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => {
                        setState(() {
                          city = cityArr[index]['name'];
                          cityId = int.parse(cityArr[index]['id'].toString());
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
                                        color: HexColor('#5C88DA'),
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

  void _showCustomDialogCity(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogCity(context); // Use the custom dialog widget here
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    token = Provider.of<SignupDataProvider>(context).storedName;
    print(token);
    getCityD();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Helper",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromRGBO(92, 136, 218, 1),
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
      body: Container(
        // color: Colors.amber,

        child: SafeArea(
          bottom: true,
          top: true,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  height: 700,
                  child: Container(
                    height: MediaQuery.of(context).size.height - 100,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Helper Profile",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // RichText(
                                    //   text: const TextSpan(
                                    //     style: TextStyle(
                                    //       color: Colors.black,
                                    //     ),
                                    //     children: <TextSpan>[
                                    //       TextSpan(
                                    //         text: '1',
                                    //         style: TextStyle(
                                    //           color: Colors.black,
                                    //           fontWeight: FontWeight.bold,
                                    //           fontSize: 19,
                                    //         ),
                                    //       ),
                                    //       TextSpan(
                                    //         text: '/2',
                                    //         style: TextStyle(
                                    //           color: Colors.grey,
                                    //           fontWeight: FontWeight.normal,
                                    //           fontSize: 12,
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const TextQuestion(
                                    "Enter Helper First Name",
                                    FontWeight.bold,
                                    12,
                                    '*',
                                    Colors.red,
                                    Colors.black),
                                SizedBox(
                                  height: 52,
                                  child: TextField(
                                    onChanged: (text) {
                                      firstName = text;
                                    },
                                    maxLength: 11,
                                    textCapitalization:
                                        TextCapitalization.sentences,
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
                                      hintText: "Enter your Helper first name",
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    // height: 25,
                                    ),
                                const TextQuestion(
                                    "Enter Helper Last Name",
                                    FontWeight.bold,
                                    12,
                                    '*',
                                    Colors.red,
                                    Colors.black),
                                SizedBox(
                                  height: 52,
                                  child: TextField(
                                    onChanged: (text) {
                                      lastName = text;
                                    },
                                    maxLength: 11,
                                    textCapitalization:
                                        TextCapitalization.sentences,
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
                                      hintText: "Enter Helper last name",
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    // height: 25,
                                    ),
                                const TextQuestion(
                                    "Date of Birth",
                                    FontWeight.bold,
                                    12,
                                    '*',
                                    Colors.red,
                                    Colors.black),
                                SizedBox(
                                  height: 42,
                                  child: Container(
                                    child: DateTimeField(
                                      mode: DateTimeFieldPickerMode.date,
                                      decoration: const InputDecoration(
                                        // hintText: 'Please select your birthday date and time',
                                        suffixIcon: Icon(Icons.calendar_today),
                                      ),
                                      selectedDate: selectedDate,
                                      dateTextStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                      onDateSelected: (DateTime value) {
                                        final DateFormat formatter =
                                            DateFormat('dd-MM-yyyy');
                                        final String formatted =
                                            formatter.format(value);
                                        setState(() {
                                          selectedDate = value;
                                          dob = formatted;
                                        });
                                        _inputFocusNode.requestFocus();
                                      },
                                      enabled: true,
                                    ),
                                  ),
                                  // ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                const TextQuestion(
                                    "Primery Mobile No",
                                    FontWeight.bold,
                                    12,
                                    '*',
                                    Colors.red,
                                    Colors.black),
                                SizedBox(
                                  height: 52,
                                  child: TextField(
                                    onChanged: (text) {
                                      primary_phone_no = text;
                                    },
                                    focusNode: _inputFocusNode,
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
                                      hintText: "",
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                SizedBox(
                                    // height: 25,
                                    ),
                                const Text(
                                  "Alternate Mobile No.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 52,
                                  child: TextField(
                                    onChanged: (text) {
                                      alternate_phone_no = text;
                                    },
                                    maxLength: 10,
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
                                      hintText: "",
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    // height: 25,
                                    ),
                                const TextQuestion(
                                    "Current Address",
                                    FontWeight.bold,
                                    12,
                                    '*',
                                    Colors.red,
                                    Colors.black),
                                SizedBox(
                                  height: 42,
                                  child: TextField(
                                    onChanged: (text) {
                                      address = text;
                                    },
                                    textCapitalization:
                                        TextCapitalization.sentences,
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
                                      hintText:
                                          "House number, building, Village",
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 42,
                                  width:
                                      (MediaQuery.of(context).size.width - 10),
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 18, 0, 10),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey,
                                        width:
                                            2.0, // Adjust the width as needed
                                      ),
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      _showCustomDialogCity(context);
                                      _inputFocusNode1.requestFocus();
                                    },
                                    child: Align(
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
                                SizedBox(
                                  height: 12,
                                ),
                                SizedBox(
                                  height: 42,
                                  child: TextField(
                                    onChanged: (text) {
                                      pincode = text;
                                    },
                                    focusNode: _inputFocusNode1,
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
                                      hintText: "Enter Pincode",
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
              ),
              SizedBox(
                height: 70,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 105,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(236, 241, 255, 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 7,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                              // Navigator.pushNamed(
                              //     context, "/screens/AddCustomerUploadDocument");
                              AddHelper();
                            },
                            child: const Text(
                              "Submit",
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
