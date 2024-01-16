import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ishtri_db/screens/Permission.dart';
import 'package:ishtri_db/screens/auth/DbLogin.dart';
import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
import 'package:provider/provider.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    final reg =
        Provider.of<SignupDataProvider>(context, listen: false).registration;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(
            92,
            136,
            218,
            1,
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                // height: 82,
                ),
            const Image(
              image: AssetImage('assets/images/Welcome.png'),
              // width: 86,
              // height: 280,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 22,
            ),
            const Text(
              "Welcome Onboard",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 18,
            ),
            Center(
              child: Text(
                "Thanks for Submitting your Details. Our Admin will get in touch with you shortly",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Text(
            //   "with Sarmila K.",
            //   style: TextStyle(
            //       fontSize: 13,
            //       fontWeight: FontWeight.normal,
            //       color: Colors.black),
            // ),
            // const SizedBox(
            //   height: 18,
            // ),
            // const Text(
            //   "Start ordering now!",
            //   style: TextStyle(
            //     fontSize: 13,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black,
            //   ),
            // ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 121,
                height: 42,
                margin: const EdgeInsets.fromLTRB(0, 78, 0, 0),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 5, 38, 88),
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, "/screens/Dashboard");
                    // Navigator.pushNamed(context, "/screens/DbLogin");
                    // Navigator.pop(context);
                    // Navigator.pop(context);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const PermissionScreen()),
                        (Route route) => false);
                  },
                  child: Text(
                    "Login".toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
