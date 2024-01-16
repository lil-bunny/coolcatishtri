import 'package:flutter/material.dart';

class ServiceItemList extends StatefulWidget {
  const ServiceItemList({super.key});

  @override
  State<ServiceItemList> createState() => _ServiceItemListState();
}

class _ServiceItemListState extends State<ServiceItemList> {
  List<Map<String, dynamic>> cloths = [
    {"item": "Shirt", "qty": 2},
    {"item": "T Shirt", "qty": 2},
    {"item": "T Shirt", "qty": 2},
    {"item": "Jeans", "qty": 2},
    {"item": "Pant", "qty": 2},
    {"item": "Shirt", "qty": 2},
    {"item": "Jeans", "qty": 2},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(92, 136, 218, 1),
        title: const Text(
          "Service Item List",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Image(
            image: AssetImage("assets/images/Hover.png"),
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/screens/DeliveryBoyProfile");
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            Container(
              color: Color.fromRGBO(28, 41, 65, 1.0),
              height: 52,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18.0, 0, 0, 0),
                    child: Container(
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Steam Iron",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      height: 33,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        color: Color.fromRGBO(92, 136, 218, 1),
                      ),
                    ),
                  ),
                  Container(
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Dry Clean",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    height: 33,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(9)),
                      color: Color.fromRGBO(92, 136, 218, 1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0, 18.0, 0),
                    child: Container(
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Washing",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      height: 33,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        color: Color.fromRGBO(92, 136, 218, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 35,
              color: const Color.fromRGBO(210, 210, 210, 1.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Item",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      "Service Rate",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: const Color.fromRGBO(236, 241, 255, 1.0),
              height: 450,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 0, 18, 0),
                child: ListView.builder(
                  itemCount: cloths.length,
                  itemBuilder: (context, index) {
                    print((cloths[index]));
                    return Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: index == 0
                            ? const EdgeInsets.fromLTRB(0.0, 10, 0, 7.0)
                            : const EdgeInsets.fromLTRB(0.0, 28, 0, 7.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              cloths[index]['item'],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                // backgroundColor: Colors.amber,
                                height: 2,
                              ),
                            ),
                            const SizedBox(
                              width: 45,
                              height: 25,
                              child: TextField(
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .grey), // Color of the bottom border when not focused
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .black), // Color of the bottom border when focused
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 18, 18.0, 7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Delivery Charges",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
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
                          hintText: "Enter delivery charges",
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        height: 42,
                        width: MediaQuery.of(context).size.width - 180,
                        margin: EdgeInsets.fromLTRB(0, 22, 12, 0),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(92, 136, 218, 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            // Get.toNamed("/screens/AddLaundryService");
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 12,
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
          ]),
        ),
      ),
    );
  }
}
