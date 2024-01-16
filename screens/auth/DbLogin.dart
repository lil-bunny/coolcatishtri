import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ishtri_db/Widgets/TextField.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ishtri_db/screens/Bottom%20Tab.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
import 'package:provider/provider.dart';

class DbLogin extends StatefulWidget {
  const DbLogin({super.key});

  @override
  State<DbLogin> createState() => _DbLoginState();
}

class _DbLoginState extends State<DbLogin> {
  var phNumber = '';
  var year = '';
  final myControllerPhnumber = TextEditingController();
  final myControllerYear = TextEditingController();

  String fbtoken = '';
  String pattern =
      r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$';
  // RegExp regExp = RegExp(pattern);
  final _numericRegExp = new RegExp(
      r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$');

  commonValidation() {}
  _passwordController() {}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getId();
  }

  toast(String name) {
    return Fluttertoast.showToast(
        msg: name,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }

  bool validateNumeric(String input) {
    return _numericRegExp.hasMatch(input);
  }

  signing() async {
    print(fbtoken);
    print(checkInternetStatus());
    print(myControllerPhnumber.text);
    if (myControllerPhnumber.text == '') {
      toast('Please enter your phone number');
    } else if (!validatePhoneNumber(myControllerPhnumber.text)) {
      toast('Phone number should digit');
    } else if (myControllerPhnumber.text.length < 10) {
      toast('Phone number should be at least 10 digit');
    } else if (myControllerYear.text == '') {
      toast('Please enter your bith year');
    } else {
      fbtoken = (await getFirebaseToken())!;
      var id = await getId();
      print(validateNumeric(myControllerPhnumber.text));
      var data = {
        "username": myControllerPhnumber.text,
        "password": myControllerYear.text,
        "device_token": fbtoken,
        "device_id": id
      };
      try {
        showLoader(context);
        await Provider.of<SignupDataProvider>(context, listen: false)
            .postLoginData(context, data);
        final reg =
            await Provider.of<SignupDataProvider>(context, listen: false);
        var mes = reg.login?.status;

        print('mes${reg.login}');
        if (reg.login?.status == 1) {
          print('reg ${reg.login?.status}');
          var mes = reg.login?.data![0].message;
          await Provider.of<SignupDataProvider>(context, listen: false)
              .localStorageSave(context, reg.login?.data![0].token);
          hideLoader(context);
          toast(mes.toString());
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const BottomTab()),
              (Route route) => false);
        } else {
          hideLoader(context);
          var mes = reg.login?.data![0].message;
          toast(mes.toString());
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(92, 136, 218, 1),
        // toolbarHeight: 12,
        automaticallyImplyLeading: false,
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
      body: Provider.of<SignupDataProvider>(context).loading1 == false
          ? SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      height: 52,
                    ),
                    Text(
                      "SIGN IN".toUpperCase(), //Mobile No
                      style: const TextStyle(
                        fontSize: 33,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(57.0, 22, 60, 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Mobile number", //Mobile No
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            height: 52,
                            margin: const EdgeInsets.only(bottom: 0, top: 10),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              // onChanged: (text) {
                              //   phNumber = text;
                              // },
                              onTap: () {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                              },
                              onTapOutside: (event) {},
                              controller: myControllerPhnumber,
                              maxLength: 10,
                              decoration: const InputDecoration(
                                fillColor: Colors.transparent,
                                suffixIcon: Icon(Icons.mobile_screen_share),
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
                            "Enter birth year", //Mobile No
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            height: 52,
                            margin: const EdgeInsets.only(bottom: 19, top: 10),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              controller: myControllerYear,
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
                                  fontFamily: '9903251458',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 111,
                      height: 45,
                      margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(92, 136, 218, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(9),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, "/screens/Otp");
                          signing();
                        },
                        child: Text(
                          "Sign in".toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : CircularProgressIndicator(),
    );
  }
}
