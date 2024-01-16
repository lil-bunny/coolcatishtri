import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/screens/PickupOrder.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/statemanagemnt/provider/OrderDataProvider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' as Io;

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddIssue extends StatefulWidget {
  final dynamic orid, product;
  const AddIssue({super.key, this.orid, this.product});

  @override
  State<AddIssue> createState() => _AddIssueState();
}

class _AddIssueState extends State<AddIssue> {
  Uint8List Selimage = base64.decode(
      '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');
  bool isChecked = false;
  Uint8List imagesel = base64.decode('iVBORw0KGgoAAAANSUhEUgAAAHQA');
  var city = '', cityId = 0, prod_id = 0, pro_name = '', pro_qty = '', qty = '';
  var cityArr = [], proArr = [], arr = [];
  String details = '', file_name = '';
  String image = '';
  String _currindex1 = '', _currindex = '';
  void pickimage() async {
    var status2 = await Permission.mediaLibrary.request();
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 10,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final bytes = Io.File(pickedFile.path).readAsBytesSync();
      String img64 = base64Encode(bytes);
      // var Selimageto=base64.decode(img64);
      print(bytes);
      setState(() {
        image = img64;
        imagesel = base64.decode(img64);
        file_name =
            DateTime.now().toUtc().microsecondsSinceEpoch.toString() + '.jpg';
      });
      Navigator.of(context).pop(context);
    }
  }

  void pickimageCamera() async {
    var status2 = await Permission.mediaLibrary.request();
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 10,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final bytes = await Io.File(pickedFile.path).readAsBytesSync();
      String img64 = base64Encode(bytes);
      // var Selimageto = base64.decode(img64);
      print('@@@ ${img64}');
      setState(() {
        image = img64;
        imagesel = base64.decode(img64);
        file_name =
            DateTime.now().toUtc().microsecondsSinceEpoch.toString() + '.jpg';
      });
      Navigator.of(context).pop(context);
    }
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        context: context,
        builder: (BuildContext bc) {
          return SizedBox(
            height: 120,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 19.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12),
                    child: InkWell(
                      onTap: () => {
                        pickimage(),
                      },
                      child: const Text(
                        "Select from gallary",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12),
                    child: InkWell(
                      onTap: () => {
                        pickimageCamera(),
                      },
                      child: const Text(
                        "Capture photo using camera",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  CustomDialog(BuildContext context) {
    // DialogHelper();

    return Dialog(
      // Add your custom dialog content here
      child: Container(
        // padding: EdgeInsets.all(0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Select Issue',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: '',
                ),
              ),
            ),
            Container(
              height: 2,
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: cityArr.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => {
                        setState(() {
                          city = cityArr[index]['name'];
                          cityId = int.parse(cityArr[index]['id'].toString());
                          Navigator.of(context).pop();
                          _currindex1 = index.toString();
                        })
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              height: 22,
                              width: 22,
                              margin: EdgeInsets.fromLTRB(0, 0, 9, 0),
                              decoration: BoxDecoration(
                                  color: HexColor('#D9D9D9'),
                                  borderRadius: BorderRadius.circular(17)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 14,
                                    width: 14,
                                    decoration: BoxDecoration(
                                        color: _currindex1 == ''
                                            ? Colors.grey
                                            : _currindex1 == index.toString()
                                                ? HexColor('#5C88DA')
                                                : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              cityArr[index]['name'],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // To close the dialog
              },
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(context); // Use the custom dialog widget here
      },
    );
  }

  void _showProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomProductDialog(
            context); // Use the custom dialog widget here
      },
    );
  }

  CustomProductDialog(BuildContext context) {
    return Dialog(
      // Add your custom dialog content here
      child: Container(
        // padding: EdgeInsets.all(0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Select Product',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: '',
                ),
              ),
            ),
            Container(
              height: 2,
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: proArr.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => {
                        setState(() {
                          pro_name = proArr[index]['name'];
                          prod_id = int.parse(proArr[index]['id'].toString());
                          qty = proArr[index]['quentity'].toString();
                          Navigator.of(context).pop();
                          _currindex = index.toString();
                        }),
                        log('@@@ ${proArr[index]}')
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              height: 22,
                              width: 22,
                              margin: EdgeInsets.fromLTRB(0, 0, 9, 0),
                              decoration: BoxDecoration(
                                  color: HexColor('#D9D9D9'),
                                  borderRadius: BorderRadius.circular(17)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 14,
                                    width: 14,
                                    decoration: BoxDecoration(
                                        color: _currindex == ''
                                            ? Colors.grey
                                            : _currindex == index.toString()
                                                ? HexColor('#5C88DA')
                                                : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              proArr[index]['name'],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // To close the dialog
              },
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  _category_list() async {
    setState(() {
      cityArr = [];
    });
    try {
      Future.delayed(Duration(microseconds: 700), () {
        showLoader(context);
      });
      String data1 = '';
      data1 = 'page=' + '1' + '&' + 'limit=' + '10';
      final data = await ApiService()
          .sendGetRequest('/v1/delivery-boy/order/issue-type-list');
      if (kDebugMode) {
        print(data);
      }
      hideLoader(context);
      var arr = [];
      var arr1 = [], arr2 = [], arr3 = [];
      if (data?['data']['status'] == 1) {
        int size = data['data']['data']?.length;
        for (int? i = 0; i! < size!; i++) {
          arr.add({
            "id": data['data']['data'][i]['id'],
            "name": data['data']['data'][i]['type'],
          });
        }
        setState(() {
          cityArr = arr;
        });
      } else {
        log("error!");
      }
    } catch (ex) {
      if (kDebugMode) {
        print('x');
      }
      if (kDebugMode) {
        print(ex);
      }
      Future.delayed(const Duration(milliseconds: 200), () {
        hideLoader(context);
      });
    } catch (e) {}
  }

  _product_list() async {
    setState(() {
      proArr = [];
    });
    try {
      Future.delayed(Duration(microseconds: 700), () {
        showLoader(context);
      });
      String data1 = '';
      data1 = 'page=' + '1' + '&' + 'limit=' + '10';
      final data = await ApiService()
          .sendGetRequest('/v1/delivery-boy/order/issue-type-list');
      if (kDebugMode) {
        print(data);
      }
      hideLoader(context);
      var arr = [];
      var arr1 = [], arr2 = [], arr3 = [];
      if (data?['data']['status'] == 1) {
        int size = data['data']['data']?.length;
        for (int? i = 0; i! < size!; i++) {
          arr.add({
            "id": data['data']['data'][i]['id'],
            "name": data['data']['data'][i]['type'],
          });
        }
        setState(() {
          proArr = arr;
        });
      } else {
        log("error!");
      }
    } catch (ex) {
      if (kDebugMode) {
        print('x');
      }
      if (kDebugMode) {
        print(ex);
      }
      Future.delayed(const Duration(milliseconds: 200), () {
        hideLoader(context);
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _category_list();
    // log('@@@ ${widget.product}');

    for (var i = 0; i < widget.product.length; i++) {
      log('@@@ ${widget.product[i]['quentity'] != '0' && widget.product[i]['quentity'] != ''}');
      if (widget.product[i]['quentity'] != '0' &&
          widget.product[i]['quentity'] != '') {
        arr.add(widget.product[i]);
      }
    }
    // log('@@@ 444${arr}');
    setState(() {
      proArr = arr;
    });
  }

  addIsssue() async {
    dynamic data = {};
    if (cityId == 0) {
      toast('Select issue');
    } else if (prod_id == 0) {
      toast('Select product');
    }
    // else if (pro_qty == '') {
    //   toast('Enter product quentity');
    // }
    // else if (int.parse(pro_qty) >= int.parse(qty)) {
    //   toast(
    //       'Enter issue product quentity can not be graterthan added product quentity');
    // }
    else if (details == '') {
      toast('Enter issue details');
    } else if (image == '') {
      toast('Select image');
    } else {
      data = {
        "issue_id": cityId.toString(),
        "issue_details": details.toString(),
        "file_name": file_name.toString(),
        "file_content": image.toString(),
        "quantity": '1',
        "product_id": prod_id.toString(),
      };
      var arr = [];
      Provider.of<OrderDataProvider>(context, listen: false)
          .issueData(context, data);

      // SharedPreferences sharedPreferences =
      //     await SharedPreferences.getInstance();
      // sharedPreferences.setStringList("issue", json.encode(data));
      Navigator.pop(context, data);
      // PickupOrder(
      //   data: "Foo",
      // );
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (_) => PickupOrder(
      //               data: "Foo",
      //             )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Issue",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(92, 136, 218, 1),
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
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 82,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(28, 41, 65, 1.0),
                ),
                child: Container(
                  margin: EdgeInsets.fromLTRB(12, 16, 12, 16),
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order ID",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.orid,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(18, 28, 18, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Issue",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: 42,
                      width: (MediaQuery.of(context).size.width - 0),
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 2.0, // Adjust the width as needed
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          _showCustomDialog(context);
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            city == '' ? "Select Issue" : city,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Select Product",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: 42,
                      width: (MediaQuery.of(context).size.width - 0),
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 2.0, // Adjust the width as needed
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          _showProductDialog(context);
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            pro_name == '' ? "Select Product" : pro_name,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    // Text(
                    //   "Enter Quentity",
                    //   style: TextStyle(
                    //     fontSize: 12,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 42,
                    //   child: TextField(
                    //     onChanged: (text) {
                    //       setState(() {
                    //         pro_qty = text;
                    //       });
                    //     },
                    //     decoration: InputDecoration(
                    //       fillColor: Colors.transparent,
                    //       enabledBorder: UnderlineInputBorder(
                    //         borderSide: BorderSide(
                    //           width: 2.0,
                    //           color: Colors.grey,
                    //         ),
                    //       ),
                    //       hintStyle: TextStyle(
                    //         color: Colors.grey.withOpacity(0.5),
                    //       ),
                    //       hintText: "Enter product quentity",
                    //     ),
                    //     keyboardType: TextInputType.number,
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 12,
                    // ),
                    Text(
                      "Enter Details",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 42,
                      child: TextField(
                        onChanged: (text) {
                          setState(() {
                            details = text;
                          });
                        },
                        decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                width: 2.0,
                                color: Colors.grey,
                              ),
                            ),
                            // filled:false,
                            hintStyle: TextStyle(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            hintText: "Enter more details here"),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Send Proof",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: () {
                        _settingModalBottomSheet(context);
                      },
                      child: Stack(
                        children: [
                          image == ''
                              ? Image.asset(
                                  'assets/images/addhar.png',
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                )
                              : Container(
                                  // width: MediaQuery.of(context).size.width,
                                  child: Image(
                                    height: 90,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                    image: MemoryImage(imagesel as Uint8List),
                                  ),
                                ),
                          Container(
                            color: Colors.black.withOpacity(0.5),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 49, 0, 0),
                            child: Center(
                              child: image == ''
                                  ? Text(
                                      'Capture or Upload Photo',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color:
                                            Color.fromRGBO(182, 182, 182, 1.0),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: Container(
                        height: 42,
                        width: MediaQuery.of(context).size.width - 110,
                        margin: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(28, 41, 65, 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            addIsssue();
                            // Navigator.pushNamed(context, '/screens/PickupOrder');
                          },
                          child: Text(
                            "Add".toUpperCase(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
