import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(53.0),
        child: AppBar(
          backgroundColor:
              const Color.fromRGBO(92, 136, 218, 1), //const Color(0x5C88DA),
          // automaticallyImplyLeading: false,
          flexibleSpace: const FlexibleSpaceBar(
            background: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 20, 0, 0),
              child: Image(
                color: Colors.white,
                height: 55,
                width: 90,
                image: AssetImage(
                    'assets/images/base_logo_transparent_background.png'),
              ),
            ),
          ),
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Add Your Services & Rates",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        "To complete onboarding and customer addition, you must offer a cost for service items or add at least one laundry.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      height: 42,
                      width: MediaQuery.of(context).size.width - 180,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(28, 41, 65, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            "/screens/MyRates",
                            arguments: {
                              'home': false,
                            },
                          );
                        },
                        child: Text(
                          "Add Your Services & Rates".toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 25,
                    // ),
                    // Text(
                    //   "Or".toUpperCase(),
                    //   style: TextStyle(
                    //     fontSize: 12,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 25,
                    // ),
                    // Container(
                    //   height: 42,
                    //   width: MediaQuery.of(context).size.width - 180,
                    //   decoration: const BoxDecoration(
                    //     color: Color.fromRGBO(28, 41, 65, 1),
                    //     borderRadius: BorderRadius.all(
                    //       Radius.circular(7),
                    //     ),
                    //   ),
                    //   child: TextButton(
                    //     onPressed: () {
                    //       Navigator.pushNamed(context, "/screens/AddLaundry");
                    //     },
                    //     child: Text(
                    //       "Add Laundry".toUpperCase(),
                    //       style: TextStyle(
                    //         fontSize: 12,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
