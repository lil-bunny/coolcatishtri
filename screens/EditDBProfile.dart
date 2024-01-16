import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/models/City.dart';
import 'package:ishtri_db/screens/Welcome.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/statemanagemnt/provider/DBProfileDataProvider.dart';
import 'package:ishtri_db/widgets/CapitalizeFirstLetterText.dart';
import '../../widgets/CustomText.dart';
import '../../widgets/question.dart';
import 'package:get/get.dart';
import 'package:date_field/date_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../statemanagemnt/provider/SignupDataProvider.dart';
import 'dart:io' as Io;
import 'package:intl/intl.dart';

class EditDBProfile extends StatefulWidget {
  const EditDBProfile({super.key});

  @override
  State<EditDBProfile> createState() => _EditDBProfileState();
}

class _EditDBProfileState extends State<EditDBProfile> {
  var isOpen = false;
  var isSelect = false;
  File? image;
  String? firstName = '',
      lastName = '',
      email = '',
      primary_phone_no = '',
      alternate_phone_no = '',
      address = '',
      city = '',
      token = '',
      new_profile_image_name = '';
  var cityArr = [];
  int? cityId = 0;
  var profileArr = [];
  bool loading = true;
  String? dob = '';
  int? pincode;
  double? rating = 0.0;
  City city1 = City();
  TextEditingController? txtFname = TextEditingController(text: '');
  TextEditingController? txtLname = TextEditingController();
  TextEditingController? txtPhone = TextEditingController();
  TextEditingController? txtMail = TextEditingController();
  TextEditingController? txtAddress = TextEditingController();
  TextEditingController? txtPincode = TextEditingController();
  void submit() {
    showAlertDialog(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // final postMdl =
    var data = {
      "id": '1',
    };
    Provider.of<SignupDataProvider>(context, listen: false)
        .getDataCity(context, data);

    getCity();
    getProfile();
    // _details();
  }

  @override
  void dispose() {
    // _controller.removeListener(_loadMore);
    super.dispose();
  }

  String capitalizeFirstLetter(String input) {
    if (input == null || input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }

  void getCity() {
    cityArr = [];
    final postMdl = Provider.of<SignupDataProvider>(context, listen: false);
    print('postMdl${postMdl.loading}');
    postMdl.city?.data
        ?.map((item) => {
              print('city ${item.id}'),
              cityArr.add({
                "id": item.id,
                "name": capitalizeFirstLetter(item.name.toString()),
                "isSelect": false,
              })
            })
        .toList();
  }

  _details() async {
    setState(() {
      var arr = [];
      loading = true;
    });
    // Future.delayed(Duration(seconds: 3), () {
    await Provider.of<DBProfileDataProvider>(context, listen: false)
        .profileData(context);
    var res = await Provider.of<DBProfileDataProvider>(context, listen: false)
        .dBdetails;
    // })
    // arr = [res?.data![0].dbDetails == null ? [] : res?.data![0].dbDetails];
    setState(() {
      firstName = (res?.data![0].dbDetails?.firstName == ''
          ? ''
          : '${res?.data![0].dbDetails?.firstName} ${res?.data![0].dbDetails?.lastName}')!;
      address = (res?.data![0].dbDetails?.address == ''
          ? ''
          : res?.data![0].dbDetails?.address)!;
      loading = false;
    });
    print(firstName);
  }

  getProfile() async {
    var tempArr = [];
    setState(() {
      loading = true;
      profileArr = [];
    });
    await Provider.of<DBProfileDataProvider>(context, listen: false)
        .profileData(context);
    var postMdl =
        await Provider.of<DBProfileDataProvider>(context, listen: false)
            .dBdetails;
    print('postMdl${postMdl?.data![0].dbDetails?.firstName}');

    DateTime now = DateTime.now();
    if (postMdl?.data![0] == null) {
      setState(() {});
    } else {
      String? date1 = postMdl?.data![0].dbDetails!.dob;
      String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
      DateTime date = new DateFormat("yyyy-MM-dd").parse(date1!);
      var inputDate = DateTime.parse(date.toString());
      var outputFormat = DateFormat('dd-MM-yyyy');
      String formate = outputFormat.format(inputDate);
      print(formate);
      setState(() {
        loading = false;
        firstName = postMdl?.data?[0].dbDetails?.firstName;
        lastName = postMdl?.data![0].dbDetails?.lastName;
        email = postMdl?.data![0].dbDetails?.email;
        dob = postMdl?.data![0].dbDetails?.dob;
        primary_phone_no = postMdl?.data![0].dbDetails?.primaryPhoneNo;
        address = postMdl?.data![0].dbDetails?.address;
        city = postMdl?.data![0].dbDetails?.city;
        pincode = postMdl?.data![0].dbDetails?.pincode;
        cityId = postMdl?.data![0].dbDetails?.cityId;
        selectedDate = DateTime.parse(dob!);
        new_profile_image_name =
            postMdl?.data![0].dbDetails?.newProfileImageName;
        rating = postMdl?.data![0].dbDetails?.rating;
        txtFname?.text = firstName.toString() ?? '';
        txtLname?.text = lastName.toString() ?? '';
        txtAddress?.text = address.toString() ?? '';
        txtMail?.text = email.toString() == null ? email.toString() : '';
        txtPhone?.text = primary_phone_no.toString() ?? '';
        txtPincode?.text = pincode.toString() ?? '';
      });
    }

    print(
        'new_profile_image_name   ${postMdl?.data![0].dbDetails?.newProfileImageName}');
  }

  CustomDialog(BuildContext context) {
    // DialogHelper();

    return Dialog(
      // Add your custom dialog content here
      child: Container(
        // padding: EdgeInsets.all(0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
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
                          Navigator.of(context).pop();
                        })
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              height: 22,
                              width: 22,
                              margin: EdgeInsets.fromLTRB(0, 0, 9, 0),
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
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(context); // Use the custom dialog widget here
      },
    );
  }

  DateTime? selectedDate;
  Uint8List Selimage = base64.decode(
      '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');
  bool isChecked = false;
  var imagesel = '';
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    Widget remindButton = TextButton(
      child: const Text("Remind me later"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("AlertDialog"),
      content: const Text(
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

  void datePicker() {
    // Get.bottomSheet(
    //   backgroundColor: Colors.white,
    //   DateTimeField(
    //     mode: DateTimeFieldPickerMode.date,
    //     decoration: const InputDecoration(
    //         // hintText: 'Please select your birthday date and time',
    //         ),
    //     selectedDate: selectedDate,
    //     onDateSelected: (DateTime value) {
    //       setState(() {
    //         selectedDate = value;
    //       });
    //     },
    //     enabled: true,
    //   ),
    //   // ),
    // );
  }

  void pickimage() async {
    // setState(() {
    // });
    var status2 = await Permission.mediaLibrary.request();
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 10,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final bytes = Io.File(pickedFile.path).readAsBytesSync();
      String img64 = base64Encode(bytes);
      // var Selimageto=base64.decode(img64);
      print(bytes);
      setState(() {
        image = imageFile;
        Selimage = base64.decode(img64);
        imagesel = pickedFile.path;
        isSelect = true;
      });
    }
  }

  void pickimageCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 10,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final bytes = await Io.File(pickedFile.path).readAsBytesSync();
      String img64 = base64Encode(bytes);
      // var Selimageto = base64.decode(img64);
      print(img64);
      setState(() {
        image = imageFile;
        Selimage = base64.decode(img64);
        imagesel = pickedFile.path;
        isSelect = true;
      });
    }
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        context: context,
        builder: (BuildContext bc) {
          return SizedBox(
            height: 120,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 19.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12),
                    child: InkWell(
                      onTap: () => {
                        pickimage(),
                      },
                      child: const Text(
                        "Select from gallary",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12),
                    child: InkWell(
                      onTap: () => {
                        pickimageCamera(),
                      },
                      child: const Text(
                        "Capture photo using camera",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  toast(String name) {
    return Fluttertoast.showToast(
        msg: name,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }

  bool isAdult(String? dateStr) {
    //DateTime birthDate = DateTime.parse(dateStr!);

    print("santuuuu $selectedDate");
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - selectedDate!.year;

    if (currentDate.month < selectedDate!.month ||
        (currentDate.month == selectedDate!.month &&
            currentDate.day < selectedDate!.day)) {
      age--;
    }

    print("santuuuu $age");
    if (age >= 18) {
      return true;
    } else {
      return false;
    }
//return true;
    // DateTime currentDate = DateTime.now();
    // int age = currentDate.year - birthDate.year;

    // if (currentDate.month < birthDate.month ||
    //     (currentDate.month == birthDate.month &&
    //         currentDate.day < birthDate.day)) {
    //   age--;
    // }

    // print('Anikesh $age');

    // if (age >= 18) {
    //   return true;
    // } else {
    //   return false;
    // }
    //return age;
  }

  update() async {
    // final DateFormat formatter = DateFormat('dd-MM-yyyy');
    // String formated = formatter.format(dob.toString() as DateTime);
    DateTime date = new DateFormat("yyyy-MM-dd").parse(dob!);
    var inputDate = DateTime.parse(date.toString());
    var outputFormat = DateFormat('dd-MM-yyyy');
    String formate = outputFormat.format(inputDate);
    print(formate);
    if (txtFname?.text == '') {
      showErrorPopup(context, "Alert!", 'Please enter your frist name');
    } else if (!validateStringWithoutNumbers(txtFname!.text)) {
      showErrorPopup(context, "Alert!", 'Please enter your correct frist name');
    } else if (txtLname?.text == '') {
      showErrorPopup(context, "Alert!", 'Please enter your last name');
    } else if (!validateStringWithoutNumbers(txtLname!.text)) {
      showErrorPopup(context, "Alert!", 'Please enter correct your last name');
    } else if (dob == '') {
      showErrorPopup(context, "Alert!", 'Please select your DOB');
    } else if (!isAdult(formate)) {
      showErrorPopup(context, "Alert!",
          'Sorry, you need to be above 18 Years of age to register as a Laundry Associate"');
    } else if (txtPhone?.text == '') {
      showErrorPopup(
          context, "Alert!", 'Please enter your primary phone number');
    } else if (txtAddress?.text == '') {
      showErrorPopup(context, "Alert!", 'Please enter your address');
    } else if (city == '') {
      showErrorPopup(context, "Alert!", 'Please select your city');
    } else if (txtPincode?.text == '') {
      showErrorPopup(context, "Alert!", 'Please enter your pincode');
    } else if (!validatePincode(txtPincode!.text.toString())) {
      showErrorPopup(context, "Alert!", 'Please enter your correct pincode');
    } else {
      showErrorPopup(
          context, "Alert!", 'Please wait while submitting your details');
      var data = {
        "firstName": txtFname?.text,
        "lastName": txtLname?.text,
        "email": txtMail?.text,
        "dob": formate,
        "primary_phone_no": txtPhone?.text,
        "address": txtAddress?.text,
        "city": cityId.toString(),
        "pincode": txtPincode?.text,
      };

      try {
        showLoader(context);
        await Provider.of<DBProfileDataProvider>(context, listen: false)
            .updateData(context, data, image);
        final reg =
            await Provider.of<DBProfileDataProvider>(context, listen: false)
                .dbUpdate;
        print('reg 448 ${reg?.data![0]}');
        if (reg?.status == 1) {
          print('reg ${reg?.status}');
          var mes = reg?.data![0].message;
          hideLoader(context);
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          hideLoader(context);
          var mes = reg?.data![0].message;
          toast(mes!);
        }
      } catch (e) {
        hideLoader(context);
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.red,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor:
                const Color.fromRGBO(92, 136, 218, 1), //const Color(0x5C88DA),
            automaticallyImplyLeading: false,
            flexibleSpace: const FlexibleSpaceBar(
              background: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 22, 0, 0),
                child: Image(
                  color: Colors.white,
                  height: 55,
                  width: 90,
                  image: AssetImage(
                      'assets/images/base_logo_transparent_background.png'),
                ),
              ),
            ),
            leading: Container(
              child: IconButton(
                icon: const Image(
                  image: AssetImage("assets/images/ChevronLeft.png"),
                  height: 22,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // const Question("Edit your profile"),
                      // CircleAvatar(backgroundColor: Colors.white, maxRadius: 80,),
                      InkWell(
                        onTap: () => {_settingModalBottomSheet(context)},
                        child: Container(
                          height: 140,
                          width: 140,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: Offset(4, 4)),
                            ],
                          ),
                          child: CircleAvatar(
                            maxRadius: 100,
                            backgroundColor: Colors.white,
                            child: Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2.2,
                                ),
                              ),
                              child: isSelect == true
                                  ? Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image: MemoryImage(Selimage)),
                                      ),
                                    )
                                  : new_profile_image_name != ''
                                      ? Container(
                                          // height: 180,
                                          // width: 180,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  new_profile_image_name
                                                      .toString()),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          // height: 180,
                                          // width: 180,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.contain,
                                              image: AssetImage(
                                                  'assets/images/camera.png'),
                                            ),
                                          ),
                                        ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        // color: Colors.amberAccent,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(top: 19),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "First Name*",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontFamily: '',
                              ),
                            ),
                            Container(
                              height: 42,
                              margin: const EdgeInsets.only(bottom: 19),
                              child: TextField(
                                controller: txtFname,
                                inputFormatters: [
                                  CapitalizeFirstLetterTextFormatter()
                                ],
                                textInputAction: TextInputAction.done,
                                onEditingComplete: () {},
                                decoration: const InputDecoration(
                                  fillColor: Colors.transparent,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  // filled:false,
                                  hintStyle: TextStyle(
                                    fontFamily: '',
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              "Last Name*",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontFamily: '',
                              ),
                            ),
                            Container(
                              height: 42,
                              margin: const EdgeInsets.only(bottom: 19),
                              child: TextField(
                                controller: txtLname,
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
                                ),
                              ),
                            ),
                            const Text(
                              "Date of Birth* (IMPORTANT : Your BIRTH YEAR will be your log in PIN)",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontFamily: '',
                              ),
                            ),
                            Container(
                              height: 42,
                              margin: const EdgeInsets.only(bottom: 19),
                              child: Container(
                                child: DateTimeField(
                                  mode: DateTimeFieldPickerMode.date,
                                  decoration: const InputDecoration(
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
                                        DateFormat('yyyy-MM-dd');
                                    final String formatted =
                                        formatter.format(value);

                                    setState(() {
                                      selectedDate = value;
                                      dob = formatted;
                                    });
                                    print("testmsg $dob");
                                  },
                                  enabled: true,
                                ),
                              ),
                              // ),
                            ),
                            const Text(
                              "Primery Mobile No.*",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontFamily: '',
                              ),
                            ),
                            Container(
                              height: 52,
                              margin: const EdgeInsets.only(bottom: 19),
                              child: TextField(
                                controller: txtPhone,
                                maxLength: 10,
                                enabled: false,
                                decoration: const InputDecoration(
                                  fillColor: Colors.transparent,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            // const Text(
                            //   "Alternate Mobile No.",
                            //   style: TextStyle(
                            //     color: Colors.black,
                            //     fontSize: 17,
                            //     fontFamily: '',
                            //   ),
                            // ),
                            // Container(
                            //   height: 52,
                            //   margin: const EdgeInsets.only(bottom: 19),
                            //   child: TextField(
                            //     maxLength: 10,
                            //     keyboardType: TextInputType.number,
                            //     decoration: const InputDecoration(
                            //       fillColor: Colors.transparent,
                            //       enabledBorder: UnderlineInputBorder(
                            //         borderSide: BorderSide(
                            //           width: 2.0,
                            //           color: Colors.grey,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            const Text(
                              "Email Address",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontFamily: '',
                              ),
                            ),
                            Container(
                              height: 42,
                              margin: const EdgeInsets.only(bottom: 19),
                              child: TextField(
                                keyboardType: TextInputType.emailAddress,
                                controller: txtMail,
                                decoration: const InputDecoration(
                                  fillColor: Colors.transparent,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              "Current Address*",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontFamily: '',
                              ),
                            ),
                            Container(
                              height: 42,
                              margin: const EdgeInsets.only(top: 12),
                              child: TextField(
                                controller: txtAddress,
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
                                        "House number, building, Village"),
                              ),
                            ),
                            // SizedBox(
                            //   height: 42,
                            //   child: TextField(
                            //     onChanged: (text) {
                            //       city = text;
                            //     },
                            //     decoration: const InputDecoration(
                            //         fillColor: Colors.transparent,
                            //         enabledBorder: UnderlineInputBorder(
                            //           borderSide: BorderSide(
                            //             width: 2.0,
                            //             color: Colors.grey,
                            //           ),
                            //         ),
                            //         filled: false,
                            //         hintText: "Street, City, Pin"),
                            //   ),
                            // ),
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
                                  _showCustomDialog(context);
                                },
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    city == ''
                                        ? "Select City"
                                        : city.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 52,
                              child: TextField(
                                controller: txtPincode,
                                maxLength: 6,
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
                                    hintText: "Enter Pincode"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0),
                    child: Container(
                      height: 85,
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
                            // margin: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(28, 41, 65, 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(7),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                // Get.toNamed('/screens/TermsConditions');
                                update();
                              },
                              child: const Text(
                                "Update Profile",
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
                ),
              ],
            ),
          ),
        )
        // : Center(
        //     child: CircularProgressIndicator(
        //     backgroundColor: HexColor('#00000'),
        //   )),
        );
  }
}
