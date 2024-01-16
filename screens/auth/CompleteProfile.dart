import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:http/http.dart' as http;
import 'package:ishtri_db/models/City.dart';
import 'package:ishtri_db/screens/Welcome.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/Constent.dart';
import 'package:ishtri_db/services/app_services.dart';
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool valuefirst = false;
  var isOpen = false;
  File? image;
  var firstName = '',
      lastName = '',
      email = '',
      primary_phone_no = '',
      alternate_phone_no = '',
      address = '',
      city = '',
      cityId = 0,
      pincode = '';
  var cityArr = [];
  TextEditingController txtFname = TextEditingController();
  FocusNode _inputFocusNode = FocusNode();
  FocusNode _inputFocusNode1 = FocusNode();
  void submit() {
    showAlertDialog(context);
  }

  String dob = '';
  City city1 = City();
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
    Future.delayed(Duration(milliseconds: 1000), () {
      getCity();
    });
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
              // print('postMdl  ${postMdl.city!.data}')
              cityArr.add({
                "id": item.id,
                "name": capitalizeFirstLetter(item.name.toString()),
                "isSelect": false,
              })
            })
        .toList();

    print(cityArr);
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
      'iVBORw0KGgoAAAANSUhEUgAAAHQAAABoCAYAAAAgjtTHAAAACXBIWXMAACE4AAAhOAFFljFgAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAhMSURBVHgB7Z1hWts4EIYnbv4vewP3AIXmBGtOUPYEhBNAT0A4QekJCCcoPQHuCSAt/+s9wbL/ge587rhPkia2lMjyyNH7PMaGKBD8WdJoNCMRRXrFgALi7u4uJf88jkajRwoE1YJ++/Yt+/Hjxzu+POIjpe6AoPf8WT6/vLzcsMAFKUWloF+/fh3z6Zy6FbGO6fPz84VGYVUJiib11atXV3yZUQAMBoPJmzdvLkgRagQVMW9Jb61cx+X+/v57UoIKQQMWs0KNqAkpIHAxwdlsNjsjBXQuKFuymo0fY7g/Pe9oWLVAp4LiBvBQYEL9YE8Muk7pVFC+AefULzJ+SDPqkM4EleZpTD2j64e0M0F7WDsrOq2lnQja19pZ0eXD2omgPa6dFailb6kDvAva99pZwQ/tKXWAd0F3oHZWjPnh3SPPeBVUaucR7QhJknj3HnkVdDgcHvPJ+1PbFew9OvVdS70Kyl6hMe0We75rqTdB++KztUVqaUqecDp99vDw8Pbl5QXm+gH9FG/edE9ptynmzo/cWs1Y7Pvn5+fcZczS1oLOxf2MaYf6R8fkfFyLuAVtwcaCStwPjJyMIi7ZKl7JWlCpkegPM4q0yUbCGgsK81ucAipm5neEgo+L/f39qekbjATtQcxP0NhEFzYKCieziBkNnm654Sb4pMkirhU0iqkLDHOenp4O60Rd61iIYuqDjVFo8qmuzEpBpc/EG6OY+sh4yPhh3YsrBWUnOsRMKaKVMxZ15azVb4LC54qqTRHtXK2ayVkQtGdxsn0HfoHfmt4FQXcomqAvjJcjDH8JuiuxPn1juRIm616IBEM2P9863+RmFHFNzscJe3hGfBzimm2UghyTJMm4ui49RWICf6L+gAnkAp4VfMPX//Bpj7//g4+UJ+Fx3aolz3/z4uDgYLLqtdlsNuW/f0zuKNiB/xoXlaDImhpT2OQ2i1qIyf9Wnu6/IDS5Y8o3+KSuAA8Pb/nzZuQItALM/RDf4GnlX04Bgpr4kUW8tA3jkPK5HBD4iB0qpy5uMuYxm8qwT/aC7ZaMHMEPZsan+4HMc/5LgSFCTlyvIYRhAN+cq01rLH+ue25qRyZluWXEfXflXi1bBdTQoLxC6BtZSEwj5dQC8ntfcz83QVY2WcLvsXnAUNaJoJV3L+HaGZID/prFHLUl5jwwaLjpfL2BVZq2VLYWfpBKHRP+wCkFAKxGblLGPpdpg3HFD9ChpaipSX6oBNm5JMUXjEPV19C6IUDbbCIqG1cf6l4XR0ArjhwVy9rUAeOnKzErbEVFf8Y18HZVxPxc4EBKLTAkxeAGspjWUYYINUUEP/cr5fiSf0/VChVyfLENakZZFuNExDAh47LfWdgbRMnjB/g81LJHTrOgj6gVNm9Av8Q3D2NJiFn+bGl8ncp5zDcb5a1iX2GMsfX7EfkqZM4Rl/eWQqm2yUW/aXqj0YxxrbzjyytLlx6E/S6JVEZg7NuGP9YVKgWVpvbSpOzDw8MxmsFtoiwwqc+19btJlhisbBZVzWKNy6gUlGuZUVAx16xTvrlTcmOpl8HkhqLe8GfMSSHqBEXtNAn9lxwbo1psQWq6vBs/SJ9JIeoENXnyJfaprXX1Mrj9mgpJy+DNyWGKOkHZ6rxuKiNLxqTUEiZrI6AvreZbNaFN0McmP630cW1nwBmtjaCx2dUmaOMT73IOsQ6TsSYm00kZqgTlfvFLUxnHoRt17DU52TXuCqFKUBaraCrjM6qfm12Tv1WQItT1oXUviqHibXaIH7ADgzIFKUKVoGzhNg0DvE71cWvwJwWG+umziB2qBGULNm0o4nUgz81pcMFzQdVQCT/xJmo1j9lQJiVFaBu2mFiVOXmCx5kmnqCUFKFt2NJoVZqMVV2ASQIDr5W6EFhtTW7jDfLlFDeZJOA+PwragIl3pkx/oJYxSWdg3pEy1BlF7J1pjL9BLkubYSAm4S/i5PAWK2SKxvnQY5OpK6RDUAtIbsqkqRw3t+rEBBqHLXsmNwsGC998p7E9kjfzt2FxlRnvWsehRjcLgWRoHskBqJkIGzWZQZE0hpQUolXQ1HSDVUkqGm3Tp0pq4qHFdJja9SjUeopsNlhF5jILi5R02zUMcqx9gOh80yQo7ZshaI6crzZYNY6el2jBqSTtHvFxsMI1h753hvGsbSabRBpOSDGqc1tIFiq03bBcPDw5OaTlSENnhOCcP7NJVWiDkFb0DmK2Bc1cV6KGtjx7MNNnkn/ygTzSdi5nG4QWsXBmmlS0LcibYTGR0ZZSQGg3ilaRSgrg5Onp6dp1KGW1L43LRaF8AkHV5WeYgCaYhR2zAFMXwoYuZMXQcl0dbaQiLPpXRLF/tkm1h4h8+gvbYIayGkwNpY5DvgH3SE/vAXDoH0mqPf45hI8UsnBjCRZvpJ+LOGIpvPm1F/pAGS6DJreg/gGhMlxUay3ME+i6hrXw//Qfzom4vwqKhE6OL+WwxVfgVaQ92Ded41wKys2SurS4iDkSoVj2oaWgsAwp0OFLZDFCsRRUIukaU+EjOpmPUPzl+tOYjRwxYmHc/UtQzCFqXXsnsp7l+OEF5zy70BAaGfvScJgup2ssCIqq6yMqPeKEx1XR/St3+J3NZndt72sS2Q7EJK9aD3HlfKgEG8emVymyKPTlqtcG696EyDmLxX4jnmjaRmRtxAI6W+zKThE1VNH9dWVqQ1BYVKz4HJtfHeQS3V+rxYAMQAxPkiS3jvcHixgifaZRaohRkNjcrgjRPegX1MYTm40UjGroPLJQ/3msra2D7u69bbqGtaAVUdjWyGWnipw2YGNBKyQxaMzCYr2BPsXo+AQJVF822TZzmf8BQJZt7386y+AAAAAASUVORK5CYII=');
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
    Get.bottomSheet(
      backgroundColor: Colors.white,
      DateTimeField(
        mode: DateTimeFieldPickerMode.date,
        decoration: const InputDecoration(
            // hintText: 'Please select your birthday date and time',
            ),
        selectedDate: selectedDate,
        onDateSelected: (DateTime value) {
          setState(() {
            selectedDate = value;
          });
        },
        enabled: true,
      ),
      // ),
    );
  }

  void pickimage() async {
    var status2 = await Permission.mediaLibrary.request();
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 10);
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
      });
      Navigator.of(context).pop(context);
    }
  }

  void pickimageCamera() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 10);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final bytes = await Io.File(pickedFile.path).readAsBytesSync();
      String img64 = base64Encode(bytes);
      // var Selimageto = base64.decode(img64);
      log('@@ ${File(pickedFile.path)}');
      setState(() {
        image = File(pickedFile.path);
        Selimage = base64.decode(img64);
        imagesel = pickedFile.path;
      });
      Navigator.of(context).pop(context);
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
                        "Select from gallery",
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

  // void signup() async {
  //   // // toast();
  //     // toast('Please Enter your frist name');
  //     var data = {
  //       "firstName": firstName,
  //       "lastName": lastName,
  //       "email": email,
  //       "dob": dob,
  //       "primary_phone_no": primary_phone_no,
  //       // "alternate_phone_no": alternate_phone_no,
  //       "address": address,
  //       "city": cityId.toString(),
  //       "pincode": pincode,
  //     };

  //     try {
  //       showLoader(context);

  //       await Provider.of<SignupDataProvider>(context, listen: false)
  //           .postSignupData(context, data, image);
  //       final reg =
  //           await Provider.of<SignupDataProvider>(context, listen: false);
  //       // log('reg ${reg.registration?.data![0].pincode}');
  //       hideLoader(context);
  //       if (reg.registration?.status == 1) {
  //         print('reg ${reg.registration?.status}');
  //         var mes = reg.registration?.data![0].messages;
  //         toast(mes!);
  //         // Navigator.pushNamed(context, '/screens/Welcome');
  //         hideLoader(context);
  //         Navigator.of(context).pushAndRemoveUntil(
  //             MaterialPageRoute(builder: (context) => const Welcome()),
  //             (Route route) => false);
  //       } else {
  //         // log('reg ${reg.registration?.data![0].pincode}');
  //         int? size = reg.registration?.data?.length;
  //
  //         var arr = [];
  //         log('@@ ${(jsonEncode(reg.registration?.data))}');
  //         print(size);
  //         // reg.registration?.data?.map((item) => {
  //         //       log('@@ ${jsonEncode(item)}'),
  //         //     });

  //         setState(() {
  //           arr = [];
  //         });
  //         // var mes = reg.registration?.data![0].messages;
  //         toast(val!);
  //         hideLoader(context);
  //       }
  //     } catch (e) {
  //       print(e);
  //       // hideLoader(context);
  //     }
  //   }
  // }

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

  Future<void> signup() async {
    try {
      if (firstName == '') {
        showErrorPopup(context, 'Alert!', 'Please enter your first name');
      } else if (!validateStringWithoutNumbers(firstName)) {
        showErrorPopup(context, 'Alert!', 'Please enter correct first name');
      } else if (lastName == '') {
        showErrorPopup(context, 'Alert!', 'Please enter your last name');
      } else if (!validateStringWithoutNumbers(lastName)) {
        showErrorPopup(context, 'Alert!', 'Please enter correct first name');
      } else if (dob == '') {
        showErrorPopup(context, 'Alert!', 'Please select your DOB');
      } else if (calculateYearDifference(selectedDate!) < 18) {
        showErrorPopup(context, 'Alert!', 'Age <18 years cannot be enrolled');
      } else if (primary_phone_no == '') {
        showErrorPopup(
            context, 'Alert!', 'Please enter your primary phone number');
      } else if (!validatePhoneNumber(primary_phone_no)) {
        showErrorPopup(
            context, 'Alert!', 'Please enter your correct phone number');
      } else if (address == '') {
        showErrorPopup(context, 'Alert!', 'Please enter your address');
        // } else if (!validateStringWithoutNumbers(address)) {
        //   showErrorPopup(context, 'Alert!', 'Please enter correct address');
      } else if (city == '') {
        showErrorPopup(context, 'Alert!', 'Please enter your city');
      } else if (pincode == '') {
        showErrorPopup(context, 'Alert!', 'Please enter your pincode');
      } else if (pincode.length < 6) {
        showErrorPopup(context, 'Alert!', 'Please enter your 6 digit pincode');
      } else if (!validatePincode(pincode)) {
        showErrorPopup(context, 'Alert!', 'Please enter your right pincode');
      } else if (imagesel == '') {
        showErrorPopup(context, 'Alert!', 'Please select your image');
      } else {
        Future.delayed(Duration(microseconds: 700), () {
          showLoader(context);
        });
        var url =
            Uri.parse('$base_url_dev/${"v1/delivery-boy/auth/create-user"}');
        log('@@ ${image?.path.split('/').last}');
        var request = http.MultipartRequest('POST', url);
        var fileStream = http.ByteStream(image!.openRead());
        var fileLength = await image?.length();
        var multipartFile = http.MultipartFile('file', fileStream, fileLength!,
            filename: image?.path.split('/').last);
        request.files.add(multipartFile);
        log('@@! ${request}');
        request.fields['firstName'] = firstName;
        request.fields['lastName'] = lastName;
        request.fields['email'] = email;
        request.fields['dob'] = dob;
        request.fields['primary_phone_no'] = primary_phone_no;
        request.fields['alternate_phone_no'] = alternate_phone_no;
        request.fields['address'] = address;
        request.fields['city'] = cityId.toString();
        request.fields['pincode'] = pincode.toString();

        final response = await request.send().then((value) => value);
        final response1 = await http.Response.fromStream(response);
        log('response1 ${request.fields}');
        dynamic? val = '';
        dynamic res = {};
        setState(() {
          res = jsonDecode(response1.body);
        });

        // log('response2 ${res?["data"]}');
        if (response.statusCode == 200) {
          hideLoader(context);
          var arr = [];
          for (var i = 0; i < res['data'].length; i++) {
            log('@@@ ${res['data'][i]}');
            arr.add(res['data'][i]);
          }

          for (dynamic item in arr) {
            item.forEach((key, value) {
              print('Key: $key, Value: $value');
              val = '${val} ' + value.replaceAll('"', '') + '.';
            });
          }

          showErrorPopup(
              context, "Alert!", "Your BIRTH YEAR will be your log in PIN");
          toast(val);
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (context) => const Welcome()),
          //     (Route route) => false);
          Navigator.pushNamed(context, '/screens/Welcome');
          // Navigator.pop(context);
        } else if (response.statusCode == 400) {
          log('response2 ${res["data"].length}');
          var arr = [];
          for (var i = 0; i < res['data'].length; i++) {
            log('@@@ ${res['data'][i]}');
            arr.add(res['data'][i]);
          }

          for (dynamic item in arr) {
            item.forEach((key, value) {
              print('Key: $key, Value: $value');
              val = '${val} ' + value.replaceAll('"', '') + '.';
            });
          }

          toast(val);
          hideLoader(context);
          return json.decode(response1.body);
        } else {
          throw Exception('Failed to load data');
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.red,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(53.0),
          child: AppBar(
            backgroundColor:
                const Color.fromRGBO(92, 136, 218, 1), //const Color(0x5C88DA),
            automaticallyImplyLeading: false,
            flexibleSpace: const FlexibleSpaceBar(
              background: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 22, 0, 0),
                child: Image(
                  color: Colors.white,
                  // height: 55,
                  // width: 90,
                  image: AssetImage(
                      'assets/images/base_logo_transparent_background.png'),
                ),
              ),
            ),
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
                      // const Question("Complete your profile"),
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
                              child: image != ''
                                  ? Container(
                                      // height: 180,
                                      // width: 180,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image: MemoryImage(Selimage)),
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
                      const TextQuestion("Upload your profile picture",
                          FontWeight.bold, 12, '*', Colors.red, Colors.black),
                      Container(
                        // color: Colors.amberAccent,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(top: 19),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextQuestion("First Name", FontWeight.bold,
                                12, '*', Colors.red, Colors.black),
                            Container(
                              height: 42,
                              margin: const EdgeInsets.only(bottom: 19),
                              child: TextField(
                                onChanged: (text) {
                                  firstName = text;
                                },
                                textCapitalization: TextCapitalization.words,
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
                            const TextQuestion("Last Name", FontWeight.bold, 12,
                                '*', Colors.red, Colors.black),
                            Container(
                              height: 42,
                              margin: const EdgeInsets.only(bottom: 19),
                              child: TextField(
                                onChanged: (text) {
                                  lastName = text;
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
                                ),
                              ),
                            ),
                            const TextQuestion("Date of Birth", FontWeight.bold,
                                12, '*', Colors.red, Colors.black),
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
                                    _inputFocusNode.requestFocus();
                                  },
                                  enabled: true,
                                ),
                              ),
                              // ),
                            ),
                            const TextQuestion(
                              "Primary Mobile No",
                              FontWeight.bold,
                              12,
                              '*',
                              Colors.red,
                              Colors.black,
                            ),
                            Container(
                              height: 52,
                              margin: const EdgeInsets.only(bottom: 19),
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
                            //     onChanged: (text) {
                            //       alternate_phone_no = text;
                            //     },
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
                            const TextQuestion("Email Address", FontWeight.bold,
                                12, '', Colors.red, Colors.black),
                            Container(
                              height: 42,
                              margin: const EdgeInsets.only(bottom: 19),
                              child: TextField(
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (text) {
                                  email = text;
                                },
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
                            const TextQuestion(
                                "Current Address",
                                FontWeight.bold,
                                12,
                                '*',
                                Colors.red,
                                Colors.black),
                            Container(
                              height: 42,
                              margin: const EdgeInsets.only(top: 12),
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
                              height: 52,
                              child: TextField(
                                onChanged: (text) {
                                  pincode = text;
                                },
                                focusNode: _inputFocusNode1,
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18.0, 19, 18, 18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Color.fromRGBO(92, 136, 218, 1),
                          value: valuefirst,
                          onChanged: (value) {
                            setState(() {
                              valuefirst = value!;
                            });
                          },
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, '/screens/TermsConditions');
                          },
                          child: const Text(
                            "Terms & Conditions",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
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
                            decoration: BoxDecoration(
                              color: valuefirst
                                  ? Color.fromRGBO(28, 41, 65, 1)
                                  : HexColor('#D2D2D2'),
                              borderRadius: BorderRadius.all(
                                Radius.circular(7),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                // Get.toNamed('/screens/TermsConditions');
                                valuefirst ? signup() : null;
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
                ),
              ],
            ),
          ),
        ));
  }
}
