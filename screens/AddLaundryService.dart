// ignore_for_file: use_build_context_synchronously

import 'dart:collection';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/Constent.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/services/local_storage.dart';
import 'package:ishtri_db/statemanagemnt/provider/LaundryDataProvider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import '../../widgets/question.dart';
import '../../widgets/CustomText.dart';
import '../models/Data.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class AddLaundryService extends StatefulWidget {
  const AddLaundryService({super.key});

  @override
  State<AddLaundryService> createState() => _AddLaundryServiceState();
}

class _AddLaundryServiceState extends State<AddLaundryService> {
  var delivery = [];
  var gender = [];
  var product = [];
  var product1 = [];

  Set<String> uniqueId = HashSet<String>();
  dynamic duplicates = [];

  bool isChecked = false;
  String currentindex = '0';
  String currentindexgen = '0';
  var _data = null;
  int page = 1, count = 10;
  List _users = [];
  String baseImage = '';
  String baseImageProduct = '';
  String cate_id = '';
  String subCate_id = '', delivery_charge = '';

  late ScrollController _controller = ScrollController();
  TextEditingController _txtinput = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // print("Hello");
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        // _firstLoad();
        print(_controller.position.pixels);
      }
    });
    Future.delayed(Duration(milliseconds: 1000), () {
      _category_list();
    });
    Future.delayed(Duration(milliseconds: 2000), () {
      _subcategory_list();
    });
  }

  _category_list() async {
    setState(() {
      delivery = [];
    });
    try {
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      String data1 = '';
      data1 = 'page=${page}' + '&' + 'limit=${count}';
      final data = await ApiService()
          .sendGetRequest('/v1/delivery-boy/product/category-list?${data1}');
      if (kDebugMode) {
        print(data);
      }
      hideLoader(context);
      var arr = [];
      var arr1 = [], arr2 = [], arr3 = [];
      log('@@${data['data']['data']}');
      if (data?['data']['status'] == 1) {
        int size = data['data']['data']?.length;
        log('@@ 144 ${size}');
        baseImage = data['data']['image_path'];
        for (int? i = 0; i! < size!; i++) {
          log('@@ 57 ${data['data']['data'][i]}');
          arr.add({
            "id": data['data']['data'][i]['id'],
            "name": data['data']['data'][i]['category_name'],
            "image": data['data']['data'][i]['new_category_image_name'],
          });
        }
        setState(() {
          delivery = arr;
          cate_id = arr[0]['id'].toString();
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

  _subcategory_list() async {
    setState(() {
      gender = [];
    });
    try {
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      String data1 = '';
      data1 = 'page=' + '1' + '&' + 'limit=' + '10';
      final data = await ApiService().sendGetRequest(
          '/v1/delivery-boy/product/sub-category-list?${data1}');
      if (kDebugMode) {
        print(data);
      }
      hideLoader(context);
      var arr = [];
      var arr1 = [], arr2 = [], arr3 = [];
      log('@@${data['data']['data']}');
      if (data?['data']['status'] == 1) {
        int size = data['data']['data']?.length;
        log('@@ 144 ${size}');
        for (int? i = 0; i! < size!; i++) {
          log('@@ 57 ${data['data']['data'][i]}');
          arr.add({
            "id": data['data']['data'][i]['id'],
            "sub_category_name":
                data['data']['data'][i]['sub_category_name'].toString(),
            "isSelect": false,
          });
        }
        setState(() {
          gender = arr;
        });
        setState(() {
          subCate_id = gender[0]['id'].toString();
        });
        _product_list(gender[0]['id']);
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
        // hideLoader(context);
      });
    } catch (e) {}
  }

  _product_list(id) async {
    log('@@ 179${id}');
    setState(() {
      product = [];
      product1 = [];
    });
    try {
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      String data1 = '';
      data1 = 'category_id=' +
          cate_id.toString() +
          '&' +
          'sub_category_id=' +
          id.toString();
      final data = await ApiService()
          .sendGetRequest('/v1/delivery-boy/product/product-list?${data1}');
      if (kDebugMode) {
        print(data);
      }
      hideLoader(context);
      var arr = [];
      var arr1 = [], arr2 = [], arr3 = [];
      log('@@${data['data']['data']}');
      if (data?['data']['status'] == 1) {
        int size = data['data']['data']?.length;
        log('@@ 144 ${size}');
        // baseImageProduct = data['data']['image_path'];
        for (int? i = 0; i! < size!; i++) {
          log('@@ 57 ${data['data']['data'][i]}');
          arr.add({
            "id": data['data']['data'][i]['id'].toString(),
            "name": data['data']['data'][i]['product_name'],
            "image": data['data']['data'][i]['new_product_image_name'],
            "rate": "",
          });
          arr1.add({
            "product_id": data['data']['data'][i]['id'].toString(),
            "rate": "",
          });
        }
        if (duplicates.length > 0) {
          for (int i = 0; i < arr.length; i++) {
            for (int j = 0; j < duplicates.length; j++) {
              log('>>>>>>>>>>>>>>>>>>>>>>>>>>>> ${arr[i]['id'].toString() == duplicates[j]['product_id'].toString()}');
              if (arr[i]['id'] == duplicates[j]['product_id'].toString()) {
                log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>${arr[i]['rate']}');
                arr[i]['rate'] = duplicates[j]['rate'];
                arr1[i]['rate'] = duplicates[j]['rate'];
              }
            }
          }
        } else {}
        setState(() {
          product = arr;
          product1 = arr1;
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
  void dispose() {
    // _controller.removeListener(_loadMore);
    _txtinput.clear();
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  final List<String> names = <String>[];
  final List<int> msgCount = <int>[2, 0, 10, 6, 52, 4, 0, 2];
  List<Map<String, dynamic>> cloths = [
    {"item": "Shirt", "qty": 2},
    {"item": "T Shirt", "qty": 2},
    {"item": "T Shirt", "qty": 2},
    {"item": "Jeans", "qty": 2},
    {"item": "Pant", "qty": 2},
    {"item": "Shirt", "qty": 2},
    {"item": "Jeans", "qty": 2},
  ];
  DateTime selectedDate = DateTime.now(); // TO tracking date

  int currentDateSelectedIndex = 0; //For Horizontal Date
  ScrollController scrollController = ScrollController();
  List<String> listOfMonths = [];
  List<String> listOfDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  List<FocusNode> _focusNodes = List.generate(10, (index) => FocusNode());

  bool isSelect = false;
  bool isSelect1 = false;
  bool isSelect2 = false;
  bool isSelect3 = false;

  // void apicall() {

  // }
  toast(String name) {
    return Fluttertoast.showToast(
        msg: name,
        // toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }

  submit() async {
    dynamic data = {};
    final laundery =
        await Provider.of<LaundryDataProvider>(context, listen: false).dataLS;
    final tax =
        await Provider.of<LaundryDataProvider>(context, listen: false).dataTax;
    data = {
      "laundryName": laundery['laundryName'],
      "ownerFirstName": laundery['ownerFirstName'],
      "ownerLastName": laundery['ownerLastName'],
      "owner_phone_no": laundery['owner_phone_no'],
      "laundry_phone_no": laundery['laundry_phone_no'],
      "address": laundery['address'],
      "street": laundery['street'],
      "city": laundery['city'],
      "pincode": laundery['pincode'],
      "gst_number": tax['gst_number'],
      "sgst": tax['sgst'],
      "cgst": tax['cgst'],
      // "service_list": product
    };
    showLoader(context);
    print(product);
    await Provider.of<LaundryDataProvider>(context, listen: false)
        .addLaundryData(context, data, product1, tax['file']);

    final res = await Provider.of<LaundryDataProvider>(context, listen: false)
        .addService;
    var msg = res?.data![0].message;
    log('@@ ${msg}');
    if (res?.status == 1) {
      var msg = res?.data![0].message;
      print(msg!);
      toast(msg!);
      hideLoader(context);
    } else {
      String? msg = res?.data![0].message;
      toast(msg!);
      hideLoader(context);
      // Navigator.of(context).pop(context);
      // Navigator.of(context).pop(context);
      // Navigator.pushNamed(context, '/screens/Laundrys');
    }
  }

  Future<void> submitRat() async {
    var token = await getTokenCustomer();
    try {
      var arr = [];
      var data1 = {};
      log('@@ ${duplicates}');
      for (var i = 0; i < duplicates.length; i++) {
        if (duplicates[i]['rate'] != '') {
          arr.add(duplicates[i]);
        }
      }
      log('@@@ ${product1}');
      final laundery =
          await Provider.of<LaundryDataProvider>(context, listen: false).dataLS;
      final tax = await Provider.of<LaundryDataProvider>(context, listen: false)
          .dataTax;
      if (arr.length == 0 || product1.length == 0) {
        showErrorPopup(context, 'Alert!',
            'Please enter rates in each of the Service segments before submitting and Enter amount should be graterthan 0');
      } else if (laundery['laundryName'] == '') {
        showErrorPopup(context, 'Alert!', 'Enter laundry first name');
      } else if (laundery['ownerFirstName'] == '') {
        showErrorPopup(context, 'Alert!', 'Enter owner first name');
      } else if (laundery['ownerLastName'] == '') {
        showErrorPopup(context, 'Alert!', 'Enter owner last name');
      } else if (laundery['owner_phone_no'] == '') {
        showErrorPopup(context, 'Alert!', 'Enter owner phone number ');
      } else if (laundery['laundry_phone_no'] == '') {
        showErrorPopup(context, 'Alert!', 'Enter laundry phone number');
      } else if (laundery['address'] == '') {
        showErrorPopup(context, 'Alert!', 'Enter address ');
      } else if (laundery['city'] == '') {
        showErrorPopup(context, 'Alert!', 'Enter city ');
      } else if (laundery['pincode'] == '') {
        showErrorPopup(context, 'Alert!', 'Enter pincode ');
      } else if (laundery['street'] == '') {
        showErrorPopup(context, 'Alert!', 'Enter street ');
      } else if (laundery['dob'] == '') {
        showErrorPopup(context, 'Alert!', 'Enter dob ');
      } else {
        Future.delayed(const Duration(microseconds: 700), () {
          showLoader(context);
        });

        var url = Uri.parse(
            '$base_url_dev/${"v1/delivery-boy/laundry-service/add-laundry-service"}');
        log('@@ ${tax['file']?.path.split('/').last}');
        var request = http.MultipartRequest('POST', url);
        var fileStream = http.ByteStream(tax['file']!.openRead());
        var fileLength = await tax['file']?.length();
        var multipartFile = http.MultipartFile('file', fileStream, fileLength!,
            filename: tax['file']?.path.split('/').last);
        request.files.add(multipartFile);
        log('@@! ${request}');
        request.headers['Authorization'] = 'Bearer $token';
        request.fields.addAll({
          'laundryName': laundery['laundryName'],
          'ownerFirstName': laundery['ownerFirstName'],
          'ownerLastName': laundery['ownerLastName'],
          'owner_phone_no': laundery['owner_phone_no'].toString(),
          'laundry_phone_no': laundery['laundry_phone_no'].toString(),
          'address': laundery['address'],
          'city': laundery['city'].toString(),
          'pincode': laundery['pincode'].toString(),
          'street': laundery['street'],
          'dob': laundery['dob'],
          'gst_number': tax['gst_number'],
          'sgst': tax['sgst'],
          'cgst': tax['cgst'],
          'service_list': jsonEncode(arr),
        });
        final response = await request.send().then((value) => value);
        final response1 = await http.Response.fromStream(response);
        log('response1 ${response1.body}');
        dynamic? val = '';
        dynamic res = {};
        dynamic resSuccess = [];
        setState(() {
          res = jsonDecode(response1.body);
          resSuccess = jsonDecode(response1.body);
        });

        // log('response2 ${res?["data"]}');
        if (response.statusCode == 200) {
          hideLoader(context);
          var arr = [];
          for (var i = 0; i < resSuccess['data'].length; i++) {
            log('@@@ ${resSuccess['data'][i]}');
            arr.add(resSuccess['data'][i]);
          }

          for (dynamic item in arr) {
            item.forEach((key, value) {
              print('Key: $key, Value: $value');
              val = '${val} ' + value.replaceAll('"', '') + '.';
            });
          }

          toast(val);

          Navigator.of(context).pop(context);
          Navigator.of(context).pop(context);
          Navigator.of(context).pop(context);
          Navigator.of(context).pop(context);
          Navigator.pushNamed(context, '/screens/Laundrys');
        } else if (response.statusCode == 400) {
          log('response2 ${res['data']}');
          var arr = [];
          for (var i = 0; i < res['data'].length; i++) {
            log('@@@ ${res['data'][i]}');
            arr.add(res['data'][i]);
          }

          for (dynamic item in arr) {
            item.forEach((key, value) {
              print('Key: $key, Value: $value');
              val = '${val} ' + value.replaceAll('"', '') + '.';
            });
          }

          toast(val);
          hideLoader(context);
          return json.decode(response1.body);
        } else {
          throw Exception('Failed to load data');
        }
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
    } catch (e) {
      hideLoader(context);
    }
  }

  void myRate(i, res, val) {
    for (dynamic obj in product1) {
      if (uniqueId.add(obj['product_id'].toString())) {
        // If the name is already in the Set, it's a duplicate.
        duplicates.add(obj);
      }
    }
    for (dynamic objres in duplicates) {
      log('@@@ obj${objres}');
      if (objres['product_id'] == product1[i]['id']) {
        int index1 = duplicates.indexOf(objres);
        log('@@@ index${index1}');
        duplicates[index1]['rate'] = val.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor:
              const Color.fromRGBO(92, 136, 218, 1), //const Color(0x5C88DA),
          automaticallyImplyLeading: false,
          title: const Text(
            "Add Laundry",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
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
      body: SingleChildScrollView(
        child: Stack(children: <Widget>[
          Column(
            children: [
              Container(
                height: 72,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 19),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Add Services and Rates",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '3',
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
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                color: const Color.fromRGBO(28, 41, 65, 1.0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(3.0, 0, 0, 0),
                  child: Center(
                    child: ListView.builder(
                      itemCount: delivery.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        print('delivery $delivery');
                        return InkWell(
                          onTap: () {
                            setState(() {
                              currentindex = index.toString();
                              cate_id = delivery[index]!['id'].toString();
                            });
                            _product_list(subCate_id);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(9)),
                                color: currentindex == ''
                                    ? const Color.fromRGBO(92, 136, 218, 1)
                                    : currentindex == index.toString()
                                        ? Colors.grey
                                        : const Color.fromRGBO(92, 136, 218, 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  children: [
                                    Image(
                                      image: NetworkImage(baseImage +
                                          '' +
                                          delivery[index]['image']),
                                      height: 25,
                                      width: 25,
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      delivery[index]['name'],
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 12),
                height: 35,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 14.0, 0),
                  child: ListView.builder(
                    itemCount: gender.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          log('@@@ ${gender}');
                          currentindexgen = index.toString();
                          _product_list(gender![index]['id'].toString());
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: currentindexgen == ''
                                  ? HexColor('#1C2941')
                                  : currentindexgen == index.toString()
                                      ? Colors.grey
                                      : HexColor('#1C2941'),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 19.0,
                                vertical: 10,
                              ),
                              child: Text(
                                gender![index]['sub_category_name'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 35,
                color: const Color.fromRGBO(210, 210, 210, 1.0),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Item",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
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
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(7.0, 0, 7, 0),
                  child: ListView.builder(
                    itemCount: product.length,
                    itemBuilder: (context, index) {
                      print((product[index]));
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 9,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            // color: Colors.red,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 10, 10, 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.network(
                                  product[index]['image'],
                                  height: 33,
                                  placeholderBuilder: (BuildContext context) =>
                                      Container(
                                          padding: const EdgeInsets.all(22.0),
                                          child:
                                              const CircularProgressIndicator()),
                                ),
                                // Text(
                                //   product[index]['name'],
                                //   style: const TextStyle(
                                //     fontSize: 12,
                                //     fontWeight: FontWeight.bold,
                                //     color: Colors.black,
                                //     // backgroundColor: Colors.amber,
                                //   ),
                                // ),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   crossAxisAlignment: CrossAxisAlignment.center,
                                //   children: [
                                //     Container(
                                //       height: 22,
                                //       width: 22,
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(12),
                                //         color: Colors.grey[400],
                                //       ),
                                //       child: const Center(
                                //         child: Text(
                                //           "-",
                                //           style: TextStyle(
                                //               // fontSize: 19,
                                //               ),
                                //         ),
                                //       ),
                                //     ),
                                //     SizedBox(
                                //       width: 12,
                                //     ),
                                //     Text(
                                //       cloths[index]['qty'].toString(),
                                //       style: const TextStyle(
                                //         fontSize: 12,
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.black,
                                //         // backgroundColor: Colors.amber,
                                //       ),
                                //     ),
                                //     SizedBox(
                                //       width: 12,
                                //     ),
                                //     Container(
                                //       height: 21,
                                //       width: 21,
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(12),
                                //         color: Colors.grey[400],
                                //       ),
                                //       child: const Icon(Icons.add, size: 12),
                                //     ),
                                //   ],
                                // ),
                                SizedBox(
                                  width: 45,
                                  height: 42,
                                  child: TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        product[index]['rate'] = value;
                                        product1[index]['rate'] = value;
                                      });
                                      for (dynamic obj in product1) {
                                        if (uniqueId.add(
                                            obj['product_id'].toString())) {
                                          // If the name is already in the Set, it's a duplicate.
                                          duplicates.add(obj);
                                        }
                                      }
                                      for (dynamic objres in duplicates) {
                                        log('@@@ obj${objres}');
                                        if (objres['product_id'].toString() ==
                                            product[index]['id'].toString()) {
                                          int index1 =
                                              duplicates.indexOf(objres);
                                          log('@@@ index ${index1}');
                                          duplicates[index1]['rate'] =
                                              value.toString();
                                        }
                                      }
                                      myRate(index, product1[index], value);
                                      // print('product 466 $product')
                                    },
                                    initialValue:
                                        product[index]['rate'].toString()!,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
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
                                      hintText: 'Rs.',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   child: Padding(
              //     padding: const EdgeInsets.fromLTRB(18.0, 18, 18.0, 7),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         const Text(
              //           "Delivery Charges",
              //           style: TextStyle(
              //             fontSize: 14,
              //             fontWeight: FontWeight.normal,
              //             color: Colors.black,
              //           ),
              //         ),
              //         SizedBox(
              //           height: 42,
              //           child: TextField(
              //             onChanged: (text) {
              //               delivery_charge = text;
              //             },
              //             decoration: const InputDecoration(
              //               fillColor: Colors.transparent,
              //               enabledBorder: UnderlineInputBorder(
              //                 borderSide: BorderSide(
              //                   width: 2.0,
              //                   color: Colors.grey,
              //                 ),
              //               ),
              //               filled: false,
              //               hintText: "Enter delivery charges",
              //             ),
              //             keyboardType: TextInputType.number,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(18.0, 18, 18.0, 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     const Text(
                      //       "Total",
                      //       style: TextStyle(
                      //         fontSize: 14,
                      //         fontWeight: FontWeight.normal,
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //     Row(
                      //       children: [
                      //         Text(
                      //           "Rs",
                      //           style: TextStyle(
                      //             fontSize: 14,
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.black,
                      //           ),
                      //         ),
                      //         SizedBox(
                      //           width: 21,
                      //         ),
                      //         Text(
                      //           "210",
                      //           style: TextStyle(
                      //             fontSize: 14,
                      //             fontWeight: FontWeight.normal,
                      //             color: Colors.black,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 105,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(236, 241, 255, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 52,
                          child: TextButton(
                            onPressed: () {
                              // Navigator.pushNamed(
                              //     context, '/screens/BottomTab');
                              submitRat();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(
                                  28, 41, 65, 1.0), // Background color
                              // padding: EdgeInsets.symmetric(
                              //     horizontal: 20, vertical: 10), // Padding
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(9), // Button shape
                              ),
                              // textStyle: TextStyle(fontSize: 16), // Text style
                              alignment: Alignment
                                  .center, // Alignment of text within the button
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(52.0, 4, 52, 4),
                              child: Text(
                                "Submit".toUpperCase(),
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
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
