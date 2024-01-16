import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class PaymentVerify extends StatefulWidget {
  const PaymentVerify({super.key});

  @override
  State<PaymentVerify> createState() => _PaymentVerifyState();
}

class _PaymentVerifyState extends State<PaymentVerify> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Subscription Payment"),
        backgroundColor: const Color.fromRGBO(92, 136, 218, 1),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Amount To Be Paid",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '\u20B9' + " 190.00",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 28, 22, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Please enter UPI ID",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 42,
                      child: TextField(
                        // onChanged: (text) {
                        // value = text;
                        // },
                        decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 2.0,
                                color: Colors.grey,
                              ),
                            ),
                            filled: false,
                            hintText: "8796231143@okaxis"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10, 18, 18),
                      child: Text(
                          "Please make sure that you have an active UPI app like BHIM or your bank’s app installed on your mobile since transaction will have to verified on that app",
                          style: TextStyle(
                            fontSize: 14,
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 180,
                height: 42,
                margin: const EdgeInsets.fromLTRB(0, 11, 0, 12),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/screens/PaymentVerifyReq');
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
                      "Verify".toUpperCase(),
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
