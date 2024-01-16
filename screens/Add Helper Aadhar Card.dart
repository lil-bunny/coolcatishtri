import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class AddHelperAadharCard extends StatefulWidget {
  const AddHelperAadharCard({super.key});

  @override
  State<AddHelperAadharCard> createState() => _AddHelperAadharCardState();
}

class _AddHelperAadharCardState extends State<AddHelperAadharCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Laundry",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Upload Documents",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '2',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                ),
                              ),
                              TextSpan(
                                text: '/3',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Aadhar Card",
                      style: TextStyle(
                        fontSize: 12,
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
                      height: 32,
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
                          hintText: "Enter first name",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const SizedBox(
                      height: 32,
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
                          margin: EdgeInsets.fromLTRB(0, 49, 0, 0),
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
                    SizedBox(
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
                          margin: EdgeInsets.fromLTRB(0, 49, 0, 0),
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
              color: Color.fromRGBO(239, 239, 239, 1.0),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 8, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Shop Photograph",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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
                          margin: EdgeInsets.fromLTRB(0, 49, 0, 0),
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
              color: Color.fromRGBO(239, 239, 239, 1.0),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 19, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "GST Nummber",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      height: 42,
                      child: TextField(
                        maxLines: 1,
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
                            hintText: "Enter GST number"),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "CGST (in %)",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(
                              height: 42,
                              width:
                                  (MediaQuery.of(context).size.width - 81) / 2,
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
                                    hintText: "00"),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "SGST (in %)",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 42,
                              width:
                                  (MediaQuery.of(context).size.width - 81) / 2,
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
                                    hintText: "00"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 29),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 42,
                        width: MediaQuery.of(context).size.width - 290,
                        margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                        decoration: const BoxDecoration(
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
                        margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(28, 41, 65, 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, "/screens/AddLaundryService");
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
            ),
          ],
        ),
      ),
    );
  }
}
