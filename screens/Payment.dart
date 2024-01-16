import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
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
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Order ID: ',
                          style: TextStyle(
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: 'CS12345678',
                          style: TextStyle(
                            color: Colors.black,
                            // fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                padding: const EdgeInsets.fromLTRB(0.0, 28, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Payment Method",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          // onChanged(!value);
                        },
                        child: Container(
                          width: 24.0,
                          height: 24.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _isChecked ? Colors.blue : Colors.transparent,
                            border: Border.all(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                          child: _isChecked
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18.0,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const Text("Credit Card", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              Container(
                height: 51,
                margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          // onChanged(!value);
                        },
                        child: Container(
                          width: 24.0,
                          height: 24.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _isChecked ? Colors.blue : Colors.transparent,
                            border: Border.all(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                          child: _isChecked
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18.0,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const Text("Debit Card", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              Container(
                height: 51,
                margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          // onChanged(!value);
                        },
                        child: Container(
                          width: 24.0,
                          height: 24.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _isChecked ? Colors.blue : Colors.transparent,
                            border: Border.all(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                          child: _isChecked
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18.0,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const Text("UPI", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              Container(
                height: 51,
                margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          // onChanged(!value);
                        },
                        child: Container(
                          width: 24.0,
                          height: 24.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _isChecked ? Colors.blue : Colors.transparent,
                            border: Border.all(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                          child: _isChecked
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18.0,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const Text("Net Banking", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 180,
                height: 42,
                margin: const EdgeInsets.fromLTRB(0, 11, 0, 12),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/screens/PaymentVerify');
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
                      "continue".toUpperCase(),
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
