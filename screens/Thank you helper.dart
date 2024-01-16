import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class Thankyouhelper extends StatefulWidget {
  const Thankyouhelper({super.key});

  @override
  State<Thankyouhelper> createState() => _ThankyouhelperState();
}

class _ThankyouhelperState extends State<Thankyouhelper> {
  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pop(context);
      Navigator.of(context).pop(context);
      Navigator.of(context).pop(context);
      Navigator.pushNamed(context, "/screens/Helpers");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(52),
        child: AppBar(
          backgroundColor:
              const Color.fromRGBO(92, 136, 218, 1), //const Color(0x5C88DA),
          automaticallyImplyLeading: false,
          flexibleSpace: const FlexibleSpaceBar(
            background: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 30, 0, 0),
              child: Image(
                color: Colors.white,
                height: 55,
                width: 90,
                image: AssetImage(
                    'assets/images/base_logo_transparent_background.png'),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 45,
            ),
            const Text(
              "Thank You!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(28, 41, 65, 1),
                // fontFamily: ,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              width: 292,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Thanks for Submitting your Details. Your profile has been submitted to admin for approval,",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Image(
              image: AssetImage('assets/images/iPhone Spinner.png'),
              width: 126,
              height: 180,
              fit: BoxFit.contain,
            ),
            // const SizedBox(
            //   height: 60,
            // ),
            // Center(
            //   child: Container(
            //     width: MediaQuery.of(context).size.width - 111,
            //     height: 42,
            //     margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
            //     decoration: const BoxDecoration(
            //       color: Color.fromARGB(255, 5, 38, 88),
            //       borderRadius: BorderRadius.all(
            //         Radius.circular(9),
            //       ),
            //     ),
            //     child: TextButton(
            //       onPressed: () {
            //         Navigator.pushNamed(context, "/screens/Welcome");
            //       },
            //       child: Text(
            //         "Go back".toUpperCase(),
            //         style: const TextStyle(
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
