import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
import 'package:provider/provider.dart';

class WelcomeSignup extends StatefulWidget {
  const WelcomeSignup({super.key});

  @override
  State<WelcomeSignup> createState() => _WelcomeSignupState();
}

class _WelcomeSignupState extends State<WelcomeSignup> {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            child: Image(
                height: 135,
                // width: 199,
                image: AssetImage(
                    'assets/images/base_logo_transparent_background.png')),
          ),
          Center(
            child: Container(
              height: 42,
              width: MediaQuery.of(context).size.width - 180,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(28, 41, 65, 1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/screens/LoginPage");
                },
                child: Text(
                  "Signup".toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 45,
          ),
          Container(
            height: 42,
            width: MediaQuery.of(context).size.width - 180,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(28, 41, 65, 1),
              borderRadius: const BorderRadius.all(
                Radius.circular(7),
              ),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/screens/DbLogin");
              },
              child: Text(
                "Login".toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
