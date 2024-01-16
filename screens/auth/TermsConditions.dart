import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({super.key});

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Terms & Conditions",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "1. I, Name (Picked up from the registration details), understand that the app is being downloaded at my own free will.",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "2. I am free to use the app for connecting with laundry service providers to avail services and or products offered by them.",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "3. I understand that the B-Tecno E Com Ventures and iS-thri app will take all measures to protect my personal information at the best of their abilities.",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "4. I will not hold B-Tecno E Com Ventures or iS-thri app responsible for the following:",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          const Text(
                            "a. Delay in services due to any unforeseen events as communicated by the laundry service providers.",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                          const Text(
                            "b. Any damages in products serviced by the laundry service providers during the order and processing cycle. ",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                          const Text(
                            "c. Misuse of my personal data by any third-party service providers and any of the laundry service providers or their associates. ",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                          const Text(
                            "d. Any financial or other damages arising out of the features and or functionality of the iS-thri app.",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                          const Text(
                            "e. Any financial and or other damages arising out of the withdrawal of the iS-thri app by B-Tecno E Com Ventures due to any reasons. ",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "5. I hereby authorize B-Tecno E Com Ventures and iS-thri app to use the registration data and images to be used for business and or marketing purposes.",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "6. I understand that after the delivery of service or products by the service providers, I am bound to pay the charges due from me within seven days or as per demand made on me by the laundry service provider thru the iS-thri app, whichever is earlier. ",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "7. My relationships with the laundry service providers are individual transaction based and it is not binding for them to continue providing services to me after closure of each transaction.",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "8. Any liability coming out of local, state and national taxes will be borne by me for the transactions carried out by me. B-Tecno E Com Ventures and iS-thri app will not be liable for such taxes. I also understand that B-Tecno E Com Ventures and iS-thri app are liable to provide details of my transactions to competent government authorities upon request. ",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "9. I will not upload any images or literature on the Is-thri app that will ",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "a. Violate the sovereignty of India",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                          const Text(
                            "b. Promote Hate",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                          const Text(
                            "c. Promote sexual contents.",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                          const Text(
                            "d. Lower the dignity of any religion, caste, race, Gender, Economic group or any other group of Individuals.  ",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "10. Maximum value of damages that I can claim from the laundry service providers is ten times the value of the service against the particular product or as mutually agreed between me and the laundry service providers. Any disputes will be under the jurisdiction of Karnataka Judicial System.",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
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
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 111,
                    height: 42,
                    margin: const EdgeInsets.fromLTRB(0, 18, 0, 22),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 5, 38, 88),
                      borderRadius: BorderRadius.all(
                        Radius.circular(9),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Navigator.pushNamed(context, "/screens/LoginPage");
                        Navigator.of(context).pop(context);
                      },
                      child: Text(
                        "Accept".toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
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
