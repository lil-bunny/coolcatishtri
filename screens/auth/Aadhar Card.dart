import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class AadharCard extends StatefulWidget {
  const AadharCard({super.key});

  @override
  State<AadharCard> createState() => _AadharCardState();
}

class _AadharCardState extends State<AadharCard> {
  bool valuefirst = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Color.fromRGBO(92, 136, 218, 1), //const Color(0x5C88DA),
        flexibleSpace: FlexibleSpaceBar(
          background: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 48, 0, 0),
            child: Image(
              color: Colors.white,
              height: 25,
              width: 90,
              image: AssetImage(
                  'assets/images/base_logo_transparent_background.png'),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ignore: avoid_unnecessary_containers
            Container(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Upload Documents",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Aadhar Card",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "Enter Aadhar Number*",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 42,
                      child: TextField(
                        onChanged: (text) {
                          // value = text;
                        },
                        decoration: const InputDecoration(
                          fillColor: Colors.transparent,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.0,
                              color: Colors.grey,
                            ),
                          ),
                          filled: false,
                          hintText: "1234-5678-1234-8521",
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const SizedBox(
                      height: 32,
                    ),

                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   decoration: const BoxDecoration(
                    //     image: DecorationImage(
                    //       image: AssetImage("assets/addhar.png"),
                    //       fit: BoxFit.contain,
                    //     ),
                    //   ),
                    //   child: Center(
                    //     child: Text(
                    //       "Hello, World!",
                    //       style: TextStyle(
                    //         fontSize: 30,
                    //         color: Colors.black,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/addhar.png',
                          fit: BoxFit.cover,
                        ),
                        Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 49, 0, 0),
                          child: const Center(
                            child: Text(
                              'Upload or Capture Aadhar front side',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromRGBO(182, 182, 182, 1.0),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/addhar.png',
                          fit: BoxFit.cover,
                        ),
                        Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 49, 0, 0),
                          child: const Center(
                            child: Text(
                              'Upload or Capture Aadhar back side',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromRGBO(182, 182, 182, 1.0),
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 10,
              color: const Color.fromRGBO(239, 239, 239, 1.0),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "UPI Payment Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      "Accept payment on GPay, PhonePe,Paytm etc...",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Aadhar Card",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "Enter Register Mobile Number*",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      height: 42,
                      child: TextField(
                        onChanged: (text) {
                          // value = text;
                        },
                        decoration: const InputDecoration(
                          fillColor: Colors.transparent,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.0,
                              color: Colors.grey,
                            ),
                          ),
                          filled: false,
                          hintText: "1234567812",
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 10,
              color: const Color.fromRGBO(239, 239, 239, 1.0),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 8, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Shop Photograph",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "Shop Photograph",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 42,
                      child: TextField(
                        onChanged: (text) {
                          // value = text;
                        },
                        decoration: const InputDecoration(
                          fillColor: Colors.transparent,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.0,
                              color: Colors.grey,
                            ),
                          ),
                          filled: false,
                          hintText: "1234567812",
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      "Shop Photograph",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 42,
                      child: TextField(
                        onChanged: (text) {
                          // value = text;
                        },
                        decoration: const InputDecoration(
                          fillColor: Colors.transparent,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.0,
                              color: Colors.grey,
                            ),
                          ),
                          filled: false,
                          hintText: "1234567812",
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/addhar.png',
                          fit: BoxFit.cover,
                        ),
                        Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 49, 0, 0),
                          child: const Center(
                            child: Text(
                              'Upload or Capture Aadhar front side',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromRGBO(182, 182, 182, 1.0),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/addhar.png',
                          fit: BoxFit.cover,
                        ),
                        Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 49, 0, 0),
                          child: const Center(
                            child: Text(
                              'Upload or Capture Aadhar front side',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromRGBO(182, 182, 182, 1.0),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 10,
              color: const Color.fromRGBO(239, 239, 239, 1.0),
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
                    const Text(
                      "Terms & Conditions",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0),
              child: Container(
                height: 105,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(236, 241, 255, 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 42,
                      width: MediaQuery.of(context).size.width - 290,
                      margin: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Go back",
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 42,
                      width: MediaQuery.of(context).size.width - 180,
                      margin: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(28, 41, 65, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/screens/TermsConditions');
                        },
                        child: const Text(
                          "Next",
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
          ],
        ),
      ),
    );
  }
}
