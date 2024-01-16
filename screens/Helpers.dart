import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/statemanagemnt/provider/HelperDataProvider.dart';
import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
import 'package:provider/provider.dart';
import '../../widgets/question.dart';
import '../../widgets/CustomText.dart';
import '../models/Data.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Helpers extends StatefulWidget {
  const Helpers({super.key});

  @override
  State<Helpers> createState() => _HelpersState();
}

class _HelpersState extends State<Helpers> {
  void submit() {
    showAlertDialog(context);
  }

  bool isChecked = true;
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {},
    );
    Widget remindButton = TextButton(
      child: const Text("Remind me later"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text(
          "Would you like to continue learning how to use Flutter alerts?"),
      actions: [cancelButton, continueButton, remindButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    void cancel() {
      Navigator.pop(context, false);
    }
  }

  var _data = null;
  var page = 1;
  List _users = [];
  late ScrollController _controller = ScrollController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    // _controller.removeListener(_loadMore);
    super.dispose();
  }

  final List<String> names = <String>[];
  final List<int> msgCount = <int>[2, 0, 10, 6, 52, 4, 0, 2];
  bool isSelect = false;
  var token = '';
  // void apicall() {
  _firstLoad() async {}

  _fetchData() async {}

  var delivery = [];
  Future<List<dynamic>> helper() async {
    List<String> arr = [];
    setState(() {
      delivery = [];
    });
    await Provider.of<HelperDataProvider>(context, listen: false)
        .helperData(context);
    var helper =
        await Provider.of<HelperDataProvider>(context, listen: false).helper;
    print('helper ${helper?.data?.toList()}');
    helper?.data
        ?.map((item) => {
              print('item  ${item?.address}'),
              delivery.add({
                'id': item.id,
                'firstName': item.firstName,
                'lastName': item.lastName,
                'dob': item.dob,
                'primary_phone_no': item.primaryPhoneNo,
                'address': item.address,
                'pincode': item.pincode,
                'cityName': item.cityName,
                'new_profile_image_name': item.newProfileImageName,
              })
              // delivery.add({})
            })
        .toList();
    print('delivery $delivery');
    return delivery;
    // setState(() {
    // delivery = arr;
    // });
  }

  void helperId(var id) async {
    await Provider.of<HelperDataProvider>(context, listen: false)
        .helperId(context, id);
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushNamed(context, '/screens/HelpersProfile');
    });
  }

  void dialog() {
    Get.defaultDialog(
      title: "Hi i test dialog",
      middleText:
          "FlutterDevs is a protruding flutter app development company with "
          "an extensive in-house team of 30+ seasoned professionals who know "
          "exactly what you need to strengthen your business across various dimensions",
      backgroundColor: Colors.teal,
      titleStyle: TextStyle(color: Colors.white),
      middleTextStyle: TextStyle(color: Colors.white),
      actions: [
        TextButton(onPressed: () => {Get.back()}, child: Text("Close"))
      ],
    );
  }
  // }

  @override
  Widget build(BuildContext context) {
    // helper(token);/
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Helper’s',
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(92, 136, 218, 1),
        leading: IconButton(
          icon: const Image(
            image: AssetImage("assets/images/ChevronLeft.png"),
            height: 22,
          ),
          onPressed: () {
            // Get.toNamed("/screens/DeliveryBoyProfile");
            Navigator.of(context).pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width - 10,
                  height: 49,
                  decoration: BoxDecoration(
                    color: HexColor('#1C2941'),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/screens/AddHelper');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Image(
                                image: AssetImage('assets/images/Add.png')),
                          ),
                          Text(
                            'Add Helpers',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 450,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: FutureBuilder(
                  future: helper(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text(""),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      // print(snapshot.hasData);
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          // print('delivery $delivery[$index]');
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
                              padding:
                                  const EdgeInsets.fromLTRB(12.0, 10, 10, 10.0),
                              child: InkWell(
                                onTap: () => {
                                  helperId(
                                      snapshot.data![index]['id'].toString()),
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 7,
                                          width: 7,
                                          margin:
                                              EdgeInsets.fromLTRB(0, 6, 12, 0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data![index]['firstName'] +
                                              ' ' +
                                              snapshot.data![index]['lastName'],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            // backgroundColor: Colors.amber,
                                            height: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // delivery[index]['Holiday'] != ""
                                    //     ? Text(
                                    //         delivery[index]['Holiday'],
                                    //         style: const TextStyle(
                                    //           fontSize: 12,
                                    //           color: Colors.black,
                                    //           // backgroundColor: Colors.amber,
                                    //           height: 2,
                                    //         ),
                                    //       )
                                    //     : Text(
                                    //         "Admin approval pending",
                                    //         style: const TextStyle(
                                    //           fontSize: 12,
                                    //           color: Colors.red,
                                    //           // backgroundColor: Colors.amber,
                                    //           height: 2,
                                    //         ),
                                    //       ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      print(snapshot.hasData);
                      return Center(
                        child: Container(
                          child: Text(
                            'No Helper found',
                            style: TextStyle(fontSize: 14, fontFamily: ''),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
