import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class PaymentVerifySuccess extends StatefulWidget {
  const PaymentVerifySuccess({super.key});

  @override
  State<PaymentVerifySuccess> createState() => _PaymentVerifySuccessState();
}

class _PaymentVerifySuccessState extends State<PaymentVerifySuccess> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscription Payment"),
        backgroundColor: const Color.fromRGBO(92, 136, 218, 1),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Center(
                    child: Image(
                      // height: 185,
                      // width: 185,
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/circletick.png"),
                    ),
                  ),
                  Center(
                    child: Text("Payment Completed \n Successfully",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        )),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width - 180,
                height: 42,
                margin: const EdgeInsets.fromLTRB(0, 81, 0, 12),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/screens/AddService');
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(
                        28, 41, 65, 1.0), // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9), // Button shape
                    ),
                    alignment:
                        Alignment.center, // Alignment of text within the button
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 4, 12, 4),
                    child: Text(
                      "Proceed".toUpperCase(),
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
      ),
    );
  }
}
