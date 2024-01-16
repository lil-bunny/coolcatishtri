import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/statemanagemnt/provider/LaundryDataProvider.dart';
import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
import 'package:ishtri_db/widgets/CapitalizeFirstLetterText.dart';
import 'package:ishtri_db/widgets/question.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';

class AddLaundry extends StatefulWidget {
  const AddLaundry({super.key});

  @override
  State<AddLaundry> createState() => _AddLaundryState();
}

class _AddLaundryState extends State<AddLaundry> {
  var lname = '',
      fadhar = '',
      ladhar = '',
      mob = '',
      lmob = '',
      address = '',
      city = '',
      cityId = 0,
      pincode = '',
      landmark = '';
  dynamic cityArr = [];
  DateTime? selectedDate;
  String dob = '';

  FocusNode _inputFocusNode = FocusNode();
  FocusNode _inputFocusNode1 = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var data = {
      "id": '1',
    };
    Provider.of<SignupDataProvider>(context, listen: false)
        .getDataCity(context, data);
    Future.delayed(Duration(milliseconds: 1000), () {
      getCity();
    });
  }

  void addlaundry() async {
    dynamic data = {};
    try {} catch (e) {
      print(e);
    }
  }

  void getCity() {
    cityArr = [];
    final postMdl = Provider.of<SignupDataProvider>(context, listen: false);
    print('postMdl ${postMdl.loading}');
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

  toast(String name) {
    return Fluttertoast.showToast(
        msg: name,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white);
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

  laundry() async {
    dynamic data = {};
    if (lname == '') {
      showErrorPopup(context, 'Alert!', 'Please enter your laundry name');
    } else if (!validateStringWithoutNumbers(lname)) {
      showErrorPopup(
          context, 'Alert!', 'Please enter your correct laundry name');
    } else if (fadhar == '') {
      showErrorPopup(context, 'Alert!', 'Please enter your first name');
    } else if (!validateStringWithoutNumbers(fadhar)) {
      showErrorPopup(
          context, 'Alert!', 'Please enter your correct laundry name');
    } else if (ladhar == '') {
      showErrorPopup(context, 'Alert!', 'Please enter your last name');
    } else if (!validateStringWithoutNumbers(ladhar)) {
      showErrorPopup(
          context, 'Alert!', 'Please enter your correct laundry name');
    } else if (mob == '') {
      showErrorPopup(
          context, 'Alert!', 'Please enter your primary phone number');
    } else if (mob.length < 10) {
      showErrorPopup(
          context, 'Alert!', 'Please enter your 10 digit primary phone number');
    } else if (!validatePhoneNumber(mob)) {
      showErrorPopup(
          context, 'Alert!', 'Please enter your correct primary phone number');
    } else if (lmob == '') {
      showErrorPopup(
          context, 'Alert!', 'Please enter your laundery phone number');
    } else if (lmob.length < 10) {
      showErrorPopup(context, 'Alert!',
          'Please enter your 10 digit laundery phone number');
    } else if (!validatePhoneNumber(lmob)) {
      showErrorPopup(
          context, 'Alert!', 'Please enter your correct laundery phone number');
    } else if (dob == '') {
      showErrorPopup(context, 'Alert!', 'Please select your dob');
    } else if (calculateYearDifference(selectedDate!) < 18) {
      showErrorPopup(context, 'Alert!', 'Age <18 years cannot be enrolled');
    } else if (address == '') {
      print(address);
      showErrorPopup(context, 'Alert!', 'Please enter your address');
    } else if (city == '') {
      showErrorPopup(context, 'Alert!', 'Please select your city');
    } else if (pincode == '') {
      showErrorPopup(context, 'Alert!', 'Please enter your pincode');
    } else if (landmark == '') {
      showErrorPopup(context, 'Alert!', 'Please enter your landmark');
    } else {
      data = {
        "laundryName": lname,
        "ownerFirstName": fadhar,
        "ownerLastName": ladhar,
        "owner_phone_no": mob,
        "laundry_phone_no": lmob,
        "address": address,
        "street": landmark,
        "city": cityId,
        "dob": dob,
        "pincode": pincode,
      };
      await Provider.of<LaundryDataProvider>(context, listen: false)
          .fetchData(context, data);
      Navigator.pushNamed(context, '/screens/AddLaundryUploadDocument');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromRGBO(92, 136, 218, 1), //const Color(0x5C88DA),
        title: const Text("Add Laundry"),
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
                        "Laundry Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '1',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                              ),
                            ),
                            TextSpan(
                              text: '/3',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
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
                  TextQuestion("Laundry Name", FontWeight.bold, 12, '*',
                      Colors.red, Colors.black),
                  SizedBox(
                    child: TextField(
                      onChanged: (text) {
                        // setState(() {
                        lname = text;
                        // });
                      },
                      textCapitalization: TextCapitalization.sentences,
                      inputFormatters: [CapitalizeFirstLetterTextFormatter()],
                      decoration: const InputDecoration(
                        fillColor: Colors.transparent,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: Colors.grey,
                          ),
                        ),
                        filled: false,
                        hintText: "Enter the laundry name",
                      ),
                      maxLength: 12,
                    ),
                  ),
                  TextQuestion("Owner First Name", FontWeight.bold, 12, '*',
                      Colors.red, Colors.black),
                  SizedBox(
                    child: TextField(
                      onChanged: (text) {
                        setState(() {
                          fadhar = text;
                        });
                      },
                      textCapitalization: TextCapitalization.sentences,
                      inputFormatters: [CapitalizeFirstLetterTextFormatter()],
                      maxLength: 12,
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
                  TextQuestion("Owner Last Name", FontWeight.bold, 12, '*',
                      Colors.red, Colors.black),
                  SizedBox(
                    child: TextField(
                      onChanged: (text) {
                        ladhar = text;
                      },
                      textCapitalization: TextCapitalization.sentences,
                      inputFormatters: [CapitalizeFirstLetterTextFormatter()],
                      maxLength: 12,
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
                  TextQuestion("Owners Mobile No.", FontWeight.bold, 12, '*',
                      Colors.red, Colors.black),
                  SizedBox(
                    height: 52,
                    child: TextField(
                      onChanged: (text) {
                        mob = text;
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
                  TextQuestion("Date of Birth", FontWeight.bold, 12, '*',
                      Colors.red, Colors.black),
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
                          final DateFormat formatter = DateFormat('yyyy-MM-dd');
                          final String formatted = formatter.format(value);
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
                  const SizedBox(
                    height: 25,
                  ),
                  TextQuestion("Laundry Contact No", FontWeight.bold, 12, '*',
                      Colors.red, Colors.black),
                  SizedBox(
                    // height: 32,
                    child: TextField(
                      onChanged: (text) {
                        lmob = text;
                      },
                      focusNode: _inputFocusNode,
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
                  TextQuestion("Current Address", FontWeight.bold, 12, '*',
                      Colors.red, Colors.black),
                  SizedBox(
                    height: 32,
                    child: TextField(
                      inputFormatters: [CapitalizeFirstLetterTextFormatter()],
                      onChanged: (text) {
                        address = text;
                      },
                      textCapitalization: TextCapitalization.sentences,
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
                    height: 12,
                  ),
                  Container(
                    height: 42,
                    width: (MediaQuery.of(context).size.width - 0),
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                        _inputFocusNode1.requestFocus();
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
                  SizedBox(
                      // height: 12,
                      ),
                  SizedBox(
                    // height: 32,
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
                          hintText: "Pincode"),
                    ),
                  ),
                  const SizedBox(
                      // height: 25,
                      ),
                  SizedBox(
                    // height: 32,
                    child: TextField(
                      onChanged: (text) {
                        landmark = text;
                      },
                      textCapitalization: TextCapitalization.sentences,
                      inputFormatters: [CapitalizeFirstLetterTextFormatter()],
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
                height: 105,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(236, 241, 255, 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
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
                          //     context, "/screens/AddLaundryUploadDocument");
                          laundry();
                        },
                        child: const Text(
                          "Next",
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
          ],
        ),
      ),
    );
  }
}
