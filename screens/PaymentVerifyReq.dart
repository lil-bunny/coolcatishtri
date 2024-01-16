import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class PaymentVerifyReq extends StatefulWidget {
  const PaymentVerifyReq({super.key});

  @override
  State<PaymentVerifyReq> createState() => _PaymentVerifyReqState();
}

class _PaymentVerifyReqState extends State<PaymentVerifyReq> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscription Payment"),
        backgroundColor: const Color.fromRGBO(92, 136, 218, 1),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
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
              Container(
                margin: const EdgeInsets.fromLTRB(0, 49, 0, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Image(
                            height: 25,
                            width: 25,
                            image: AssetImage("assets/images/tick.png"),
                          ),
                          Text(
                            "8796231143@okaxis",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      const Text(
                        "From",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
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
                              hintText: "Sarmila K"),
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      const Text(
                        "Amount",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
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
                              hintText: "50.00"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0.0, 10, 18, 18),
                child: Text(
                    "You need to authorise the collect request on your UPI app withing 15 minutes for successful payment.",
                    style: TextStyle(
                      fontSize: 12,
                    )),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 180,
                height: 42,
                margin: const EdgeInsets.fromLTRB(0, 11, 0, 12),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/screens/PaymentVerifySuccess');
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
                      "Request".toUpperCase(),
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
