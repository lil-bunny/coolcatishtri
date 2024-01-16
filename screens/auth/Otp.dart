import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ishtri_db/Widgets/TextField.dart';
import 'package:ishtri_db/screens/Bottom%20Tab.dart';
import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
import 'package:provider/provider.dart';

class Otp extends StatefulWidget {
  const Otp({super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  var otp1 = '', otp2 = '', otp3 = '', otp4 = '';
  commonValidation() {}
  _passwordController() {}
  FocusNode _firstFocusNode = FocusNode();
  FocusNode _secondFocusNode = FocusNode();
  FocusNode _thirdFocusNode = FocusNode();
  FocusNode _forthFocusNode = FocusNode();
  @override
  void dispose() {
    // Dispose the FocusNodes to release resources when they are no longer needed
    // _firstFocusNode.dispose();
    // _secondFocusNode.dispose();
    // _thirdFocusNode.dispose();
    // _forthFocusNode.dispose();
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

  otp() async {
    if (otp1 == '' && otp1 == '' && otp1 == '' && otp1 == '') {
      toast('Please enter otp');
    } else {
      var data = {
        "phone_no":
            Provider.of<SignupDataProvider>(context, listen: false).ph_number,
        "otp": otp1 + otp2 + otp3 + otp4,
      };

      try {
        await Provider.of<SignupDataProvider>(context, listen: false)
            .postOtpData(context, data);
        final reg =
            await Provider.of<SignupDataProvider>(context, listen: false);
        if (reg.otp?.status == 1) {
          print('reg ${reg.otp?.status}');
          // var mes = reg.otp?.data![0].message;
          // toast(mes.toString());

          await Provider.of<SignupDataProvider>(context, listen: false)
              .localStorageSave(context, reg.otp?.data![0].token);

          // Navigator.pushNamed(context, "/screens/BottomTab");
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const BottomTab()),
              (Route route) => false);
        } else {
          var mes = reg.otp?.data![0].message;
          toast(mes!);
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
        toolbarHeight: 12,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 52,
            ),
            Text(
              "Enter Your Otp".toUpperCase(), //Mobile No
              style: const TextStyle(
                fontSize: 33,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(57.0, 22, 60, 13),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 42,
                    width: 48,
                    margin: const EdgeInsets.only(bottom: 19),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: TextField(
                      onChanged: (text) {
                        otp1 = text;
                        _secondFocusNode.requestFocus();
                      },
                      focusNode: _firstFocusNode,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0, // Set the desired font size
                      ),
                      decoration: const InputDecoration(
                        fillColor: Colors.transparent,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 42,
                    width: 48,
                    margin: const EdgeInsets.only(bottom: 19),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: TextField(
                      onChanged: (text) {
                        otp2 = text;
                        _thirdFocusNode.requestFocus();
                      },
                      focusNode: _secondFocusNode,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 20.0, // Set the desired font size
                      ),
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        fillColor: Colors.transparent,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 42,
                    width: 48,
                    margin: const EdgeInsets.only(bottom: 19),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: TextField(
                      onChanged: (text) {
                        otp3 = text;
                        _forthFocusNode.requestFocus();
                      },
                      focusNode: _thirdFocusNode,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 20.0, // Set the desired font size
                      ),
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        fillColor: Colors.transparent,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 42,
                    width: 48,
                    margin: const EdgeInsets.only(bottom: 19),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: TextField(
                      onChanged: (text) {
                        otp4 = text;
                        _thirdFocusNode.requestFocus();
                      },
                      focusNode: _forthFocusNode,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 20.0, // Set the desired font size
                      ),
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        fillColor: Colors.transparent,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
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
              decoration: BoxDecoration(
                color: Color.fromRGBO(92, 136, 218, 1),
                borderRadius: BorderRadius.circular(7),
              ),
              child: TextButton(
                onPressed: () {
                  otp();
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
    );
  }
}
