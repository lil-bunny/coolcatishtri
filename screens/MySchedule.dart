import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/services/global.dart';
import 'package:ishtri_db/statemanagemnt/provider/OrderDataProvider.dart';
import 'package:ishtri_db/widgets/CButton.dart';
import 'package:provider/provider.dart';
import '../../widgets/question.dart';
import '../../widgets/CustomText.dart';
import '../models/Data.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:io' as Io;
import 'package:intl/intl.dart';

class MySchedule extends StatefulWidget {
  const MySchedule({super.key});

  @override
  State<MySchedule> createState() => _MyScheduleState();
}

class _MyScheduleState extends State<MySchedule> {
  var dropdownValue;
  DateTime selectedDate = DateTime.now();
  bool isChecked = false;

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.music_note),
                    title: new Text('Music'),
                    onTap: () => {}),
                new ListTile(
                  leading: new Icon(Icons.videocam),
                  title: new Text('Video'),
                  onTap: () => {},
                ),
              ],
            ),
          );
        });
  }

  var _data = null;
  var page = 1;
  List _users = [];

  late ScrollController _controller = ScrollController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // print("Hello");

    Future.delayed(Duration(microseconds: 500), () {
      showLoader(context);
      // _scheduletime(selectedDate);
      _timeAll();
      _societyAll();
      _towerAll();
    });
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        print(_controller.position.pixels);
      }
    });
    // setState(() {
    //   page++;
    // });
  }

  @override
  void dispose() {
    // _controller.removeListener(_loadMore);
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  final List<int> msgCount = <int>[2, 0, 10, 6, 52, 4, 0, 2];
  List<Map<String, dynamic>> cloths = [];
  // TO tracking date
  String date = '';
  String currentDateSelectedIndex = ''; //For Horizontal Date
  String currentDateSelectedIndex1 = ''; //For Horizontal Date
  String societySelectIndex = '';
  String towerSelectIndex = '';
  String societySel = '', towerSel = '', societyid = '', timeId = '';
  ScrollController scrollController = ScrollController();
  List<String> listOfMonths = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  List<String> listOfDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  List<FocusNode> _focusNodes = List.generate(10, (index) => FocusNode());
  dynamic widgetList = [];
  dynamic society = [];
  dynamic _tower = [], _time = [];
  // 'On Leave'
  bool isSelect = false;
  bool isSelect1 = false;
  bool isSelect2 = false;
  bool isSelect3 = false;

  var schedule_arr = [], temp_arr = [];
  // void apicall() {

  // }
  String formattedDate = '';
  var arr = [];

  List<Map<String, dynamic>> arr1 = [], arr2 = [], arr4 = [];
  var arr3 = [];
  List evenNumbers = [];
  List evenNumbers1 = [];
  String _txtSociety = '', _txtTower = '', time = '';
  void _scheduletime(DateTime time) async {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    formattedDate = formatter.format(time);
    var data = {"date": formattedDate};
    Future.delayed(Duration(microseconds: 500), () {
      showLoader(context);
    });
    setState(() {
      arr = [];
      arr1 = [];
      arr3 = [];
    });
    print(data);

    await Provider.of<OrderDataProvider>(context, listen: false)
        .fetchscheduleallData(context, data);
    final res = await Provider.of<OrderDataProvider>(context, listen: false)
        .scheduleSelect;

    // log('${jsonEncode(res)}');
    hideLoader(context);
    if (res?.status == 1) {
      // log('aa${jsonEncode(res?.data?.length)}');
      int? size = res?.data?.length;
      for (int? i = 0; i! < size!; i++) {
        int? count = res?.data![i]?.scheduleList?.length;

        for (int? j = 0; j! < count!; j++) {
          // log('item ${res?.data![i].scheduleList![j].isSchedule}');
          int? count1 = res?.data![i]?.scheduleList![j].socityArry?.length;

          arr.add({
            "schedule_range": res?.data![i].scheduleList![j].scheduleTime,
            "isSelect": res?.data![i].scheduleList![j].isSchedule,
            "masterId": res?.data![i].scheduleList![j].masterScheduleId,
            "society": res?.data![i].scheduleList![j].socityArry,
          });

          for (int? l = 0; l! < count1!; l++) {
            // log('@@ count ${res?.data![i]?.scheduleList![j]?.socityArry![l].isSelect}');

            arr1.add({
              "name": res?.data![i].scheduleList![j].socityArry![l].name,
              "isSchedule":
                  res?.data![i].scheduleList![j].socityArry![l].isSelect,
              "tower": res?.data![i].scheduleList![j].socityArry![l].towers,
              "id": res?.data![i].scheduleList![j].socityArry![l].id,
            });
          }

          // log('@@ len${arr1}');
        }
      }

      log('@@ $arr1');
      List<Map<String, dynamic>> dataList = [];

      // Create a Set to store unique elements
      Set<Map<String, dynamic>> uniqueList = {};

      for (var entry in arr1) {
        uniqueList.add(entry);
      }
      List<Map<String, dynamic>> isScheduleTrueData =
          arr1.where((element) => element["isSchedule"] == true).toList();

      List<Map<String, dynamic>> uniqueData2 = isScheduleTrueData.fold(
          <Map<String, dynamic>>[], (List<Map<String, dynamic>> accumulator,
              Map<String, dynamic> current) {
        bool isDuplicate = accumulator.any((element) {
          return element["name"] == current["name"] &&
              element["id"] == current["id"];
        });

        if (!isDuplicate) {
          accumulator.add(current);
        }

        return accumulator;
      });

      List<Map<String, dynamic>> isScheduleTrueData1 =
          arr1.where((element) => element["isSchedule"] == false).toList();

      List<Map<String, dynamic>> uniqueData1 = isScheduleTrueData1.fold(
          <Map<String, dynamic>>[], (List<Map<String, dynamic>> accumulator,
              Map<String, dynamic> current) {
        bool isDuplicate = accumulator.any((element) {
          return element["name"] == current["name"] &&
              element["id"] == current["id"];
        });

        if (!isDuplicate) {
          accumulator.add(current);
        }

        return accumulator;
      });

      arr3 = uniqueData1;
      if (uniqueData2.length != 0) {
        for (int i = 0; i < uniqueData2.length; i++) {
          for (int j = 0; j < uniqueData1.length; j++) {
            log('@@ =>>>${uniqueData2[i]['name']}');
            if (uniqueData2[i]['name'] == uniqueData1[j]['name']) {
              arr3[j]['isSchedule'] = uniqueData2[i]['isSchedule'];
            }
          }
        }
      }
      if (arr1.length != 0) {
        for (int i = 0; i < arr1.length; i++) {
          for (int j = 0; j < arr1[i]['tower'].length; j++) {
            // log('@@@=>>>>> ${jsonEncode(arr1[i]['tower'][j].isSelect)}');
            arr4.add({
              "id": arr1[i]['tower'][j].id,
              "name": arr1[i]['tower'][j].name,
              "isSelect": arr1[i]['tower'][j].isSelect,
            });
          }
        }
      }
      log('@@ =>>>${arr4.length}');
      var arr5 = [];
      List<Map<String, dynamic>> uniqueDataTower1 = [];
      List<Map<String, dynamic>> uniqueDataTower2 = [];
      List<Map<String, dynamic>> isTowerTrueData1 =
          arr4.where((element) => element["isSelect"] == false).toList();

      List<Map<String, dynamic>> isTowerTrueData2 =
          arr4.where((element) => element["isSelect"] == true).toList();

      if (arr4.length != 0) {
        uniqueDataTower1 = isTowerTrueData1.fold(<Map<String, dynamic>>[],
            (List<Map<String, dynamic>> accumulator,
                Map<String, dynamic> current) {
          bool isDuplicate = accumulator.any((element) {
            return element["name"] == current["name"];
          });

          if (!isDuplicate) {
            accumulator.add(current);
          }

          return accumulator;
        });

        uniqueDataTower2 = isTowerTrueData2.fold(<Map<String, dynamic>>[],
            (List<Map<String, dynamic>> accumulator,
                Map<String, dynamic> current) {
          bool isDuplicate = accumulator.any((element) {
            return element["name"] == current["name"];
          });

          if (!isDuplicate) {
            accumulator.add(current);
          }

          return accumulator;
        });

        arr5 = uniqueDataTower1;
        if (uniqueDataTower2.length != 0) {
          for (int i = 0; i < uniqueDataTower2.length; i++) {
            for (int j = 0; j < uniqueDataTower1.length; j++) {
              log('@@ =>>>${uniqueDataTower2[i]['name']}');
              if (uniqueDataTower2[i]['name'] == uniqueDataTower1[j]['name']) {
                arr5[j]['isSelect'] = uniqueDataTower2[i]['isSelect'];
              }
            }
          }
        }
        log('@@@=>>>${uniqueDataTower2}');
        // for(int i=0;i<arr4.length;i++)
      }
      if (uniqueData2.length == 0) {
        log('@@@ ${uniqueData1}');
        setState(() {
          widgetList = arr;
          society = uniqueData1;
          _tower = uniqueDataTower1;
        });
      } else {
        setState(() {
          widgetList = arr;
          society = arr3;
          _tower = arr5;
        });
      }
    } else {
      log('bb');
      hideLoader(context);
    }
    // });
    log('arr $arr');
  }

  _changescheduletime(date) async {
    showLoader(context);

    hideLoader(context);
  }

  void newSociety() {
    try {
      setState(() {
        society.add({"name": _txtSociety, "id": ""});
      });
      Navigator.pop(context);
    } catch (e) {}
  }

  void newTower() {
    try {
      setState(() {
        _tower.add({"name": _txtTower, "id": "", "isSelect": true});
      });
      Navigator.pop(context);
    } catch (e) {}
  }

  void _newTower() async {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: double.maxFinite,
              height: 260,
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: towerDialog(),
            ),
          );
        });
  }

  void _newSociety() async {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: double.maxFinite,
              height: 260,
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: societyDialog(),
            ),
          );
        });
  }

  Widget societyDialog() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState1) {
        return Container(
          height: 260,
          width: MediaQuery.of(context).size.width - 90,
          child: Column(
            children: [
              Container(
                height: 240,
                width: MediaQuery.of(context).size.width - 90,
                child: Column(
                  children: [
                    Container(
                      // height: 200,
                      margin: EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.only(
                          top: 12, left: 15, right: 15, bottom: 15),
                      // color: Colors.white,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0, top: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Enter your society name",
                                    style: TextStyle(
                                      color: lightBlackColor,
                                      fontFamily: "Poppins-bold",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 52,
                                  child: TextField(
                                    onChanged: (text) {
                                      _txtSociety = text;
                                    },
                                    decoration: InputDecoration(
                                      fillColor: Colors.transparent,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      filled: false,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(0),
                                      child: ActionButton(
                                        "Cancel",
                                        () {
                                          Navigator.pop(context);
                                        },
                                        MediaQuery.of(context).size.width *
                                            0.25,
                                        Colors.transparent,
                                        HexColor('#1C2941'),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: ActionButton(
                                        "Confirm ",
                                        () {
                                          newSociety();
                                        },
                                        MediaQuery.of(context).size.width *
                                            0.45,
                                        HexColor('#1C2941'),
                                        whiteColor,
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
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget towerDialog() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState1) {
        return Container(
          height: 260,
          width: MediaQuery.of(context).size.width - 90,
          child: Column(
            children: [
              Container(
                height: 240,
                width: MediaQuery.of(context).size.width - 90,
                child: Column(
                  children: [
                    Container(
                      // height: 200,
                      margin: EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.only(
                          top: 12, left: 15, right: 15, bottom: 15),
                      // color: Colors.white,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0, top: 3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Enter your tower / block",
                                    style: TextStyle(
                                      color: lightBlackColor,
                                      fontFamily: "Poppins-bold",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 52,
                                  child: TextField(
                                    onChanged: (text) {
                                      _txtTower = text;
                                    },
                                    decoration: InputDecoration(
                                      fillColor: Colors.transparent,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 2.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      filled: false,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(0),
                                      child: ActionButton(
                                        "Cancel",
                                        () {
                                          Navigator.pop(context);
                                        },
                                        MediaQuery.of(context).size.width *
                                            0.25,
                                        Colors.transparent,
                                        HexColor('#1C2941'),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: ActionButton(
                                        "Confirm ",
                                        () {
                                          newTower();
                                        },
                                        MediaQuery.of(context).size.width *
                                            0.45,
                                        HexColor('#1C2941'),
                                        whiteColor,
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
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _societyAll() async {
    print('hello');
    try {
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      final data1 = await ApiService()
          .sendGetRequest('/v1/delivery-boy/schedule/society-list');
      if (kDebugMode) {
        print('@@ ${data1['data']}');
      }
      if (data1['data']['status'] == 1) {
        setState(() {
          society = data1['data']['data'];
        });
        hideLoader(context);
      } else {
        var mes = '';
        mes = data1['data']['message'];
        hideLoader(context);
        toast(mes!);
      }
      hideLoader(context);
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
    Future.delayed(const Duration(seconds: 1), () {
      hideLoader(context);
    });
  }

  _towerAll() async {
    try {
      dynamic data = {}, arr = [];
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      final data1 = await ApiService()
          .sendGetRequest('/v1/delivery-boy/schedule/tower-list');
      if (kDebugMode) {
        print('@@ ${data1['data']['data']}');
      }
      if (data1['data']['status'] == 1) {
        for (int i = 0; i < data1['data']['data'].length; i++) {
          arr.add({
            "name": data1['data']['data'][i]['name'],
            "id": data1['data']['data'][i]['id'],
            "isSelect": false
          });
        }
        setState(() {
          _tower = arr;
        });
        hideLoader(context);
      } else {
        var mes = '';
        mes = data1['data']['data']['message'];
        hideLoader(context);
        toast(mes!);
      }
      hideLoader(context);
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
    Future.delayed(const Duration(seconds: 1), () {
      hideLoader(context);
    });
  }

  _timeAll() async {
    try {
      dynamic data = {};
      Future.delayed(const Duration(microseconds: 700), () {
        showLoader(context);
      });
      final data1 = await ApiService()
          .sendGetRequest('/v1/delivery-boy/schedule/schedule-timings');
      if (kDebugMode) {
        print('@@ ${data1['data']['data']}');
      }
      if (data1['data']['status'] == 1) {
        setState(() {
          _time = data1['data']['data'];
        });
        hideLoader(context);
      } else {
        var mes = '';
        mes = data1['data']['data']['message'];
        hideLoader(context);
        toast(mes!);
      }
      hideLoader(context);
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
    Future.delayed(const Duration(seconds: 1), () {
      hideLoader(context);
    });
  }

  // _scheduletime() {}
  void submit() async {
    showLoader(context);
    var data = {}, arr1 = [], arr2 = [], arr3 = [];
    List<Map<String, dynamic>> arr6 = [];
    // List isTimeTrueData =
    //     widgetList.where((element) => element["isSelect"] == true).toList();
    // log('@@@ =>>${isTimeTrueData}');

    log('@@@$arr3');
    if (date == '') {
      toast('Please select date');
    } else if (timeId == '') {
      toast('Please select time');
    } else if (societySel == '') {
      toast('Please select society');
    } else if (towerSel == '') {
      toast('Please select tower');
    } else {
      for (int i = 0; i < _tower.length; i++) {
        if (_tower[i]['isSelect'] == true) {
          if (_tower[i]['id'].toString() == '') {
            arr6.add({
              'tower_name': _tower[i]['name'],
            });
          } else {
            arr6.add({
              "id": _tower[i]['id'] == "" ? null : _tower[i]['id'],
            });
          }
        }
      }
      data = {
        "towers_list": arr6,
        "society_id": societyid == "" ? null : societyid,
        "society_name": societySel,
        "schedule_time_id": timeId,
        "schedule_date": date,
      };
      print(data);
      await Provider.of<OrderDataProvider>(context, listen: false)
          .addscheduleData(context, data);
      final res =
          await Provider.of<OrderDataProvider>(context, listen: false).schedule;

      hideLoader(context);
      log('@@@ ${res?.data![0]}');
      if (res?.status == 1) {
        var msg = res?.data![0].message;
        toast(msg!);
        hideLoader(context);
      } else {
        hideLoader(context);
      }
    }
    hideLoader(context);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 6;
    final double itemWidth = size.width / 2;
    double _crossAxisSpacing = 8, _mainAxisSpacing = 12, _aspectRatio = 2;
    int _crossAxisCount = 2;
    double screenWidth = MediaQuery.of(context).size.width;

    var width = (screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var height = width / _aspectRatio;
    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'My Schedule',
        ),
        backgroundColor: const Color.fromRGBO(92, 136, 218, 1),
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
        child: Stack(children: <Widget>[
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 25,
                  ),

                  // Container(
                  //   margin: const EdgeInsets.fromLTRB(15, 0, 0, 12),
                  //   child: const Text(
                  //     "Select Day*",
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   height: 37,
                  //   child: ListView.builder(
                  //     itemCount: listOfDays.length,
                  //     controller: scrollController,
                  //     scrollDirection: Axis.horizontal,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return Container(
                  //         height: 25,
                  //         decoration: BoxDecoration(
                  //           color: HexColor('#5C88DA'),
                  //           border: Border.all(
                  //             width: 1,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //         child: Center(
                  //           child: Padding(
                  //             padding:
                  //                 const EdgeInsets.symmetric(horizontal: 18.0),
                  //             child: Text(
                  //               listOfDays[index],
                  //               style: const TextStyle(
                  //                   fontSize: 12, color: Colors.white),
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 12,
                  // ),
                  // const Center(
                  //   child: Text(
                  //     "Select Time*",
                  //     style: TextStyle(
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   height: 128,
                  //   width: MediaQuery.of(context).size.width,
                  //   margin: const EdgeInsets.fromLTRB(1, 12, 11, 7),
                  //   child: GridView.count(
                  //     crossAxisCount: 4, // Number of columns in the grid
                  //     // mainAxisSpacing: 10.0, // Spacing between vertical items
                  //     // crossAxisSpacing:
                  //     //     10.0, // Spacing between horizontal items
                  //     childAspectRatio: (itemWidth /
                  //         itemHeight), // Ratio between item width and height

                  //     scrollDirection: Axis.vertical,
                  //     // controller: scrollController,
                  //     children: widgetList.map((String value) {
                  //       // List<String> textList = "08-10 AM".split(' ');

                  //       return Container(
                  //         height: 25,
                  //         child: Padding(
                  //           padding: const EdgeInsets.fromLTRB(8.0, 10, 0, 10),
                  //           child: InkWell(
                  //             onTap: () {
                  //               print(widgetList.indexOf(value));
                  //               setState(() {
                  //                 currentDateSelectedIndex ==
                  //                     widgetList.indexOf(value).toString();
                  //                 // selectedDate = DateTime.now()
                  //                 //     .add(const Duration(days: 0));
                  //                 // _addDate.add({"date": value});
                  //               });
                  //             },
                  //             child: Container(
                  //               height: 40,
                  //               // width: 125,
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(8),
                  //                 boxShadow: [
                  //                   currentDateSelectedIndex ==
                  //                           widgetList.indexOf(value).toString()
                  //                       ? const BoxShadow(
                  //                           color: Colors.grey,
                  //                           offset: Offset(2, 2),
                  //                           blurRadius: 5)
                  //                       : const BoxShadow(
                  //                           color: Colors.grey,
                  //                           offset: Offset(0, 0),
                  //                           blurRadius: 0,
                  //                         ),
                  //                 ],
                  //                 color: currentDateSelectedIndex ==
                  //                         widgetList.indexOf(value).toString()
                  //                     ? const Color.fromRGBO(92, 136, 218, 1.0)
                  //                     : const Color(0xFFEAEAEA),
                  //               ),
                  //               child: Container(
                  //                 padding: const EdgeInsets.all(2.0),
                  //                 width: 82,
                  //                 alignment: Alignment.center,
                  //                 child: Text(
                  //                   value,
                  //                   style: TextStyle(
                  //                       color: currentDateSelectedIndex ==
                  //                               widgetList
                  //                                   .indexOf(value)
                  //                                   .toString()
                  //                           ? Colors.white
                  //                           : Colors.black,
                  //                       fontSize: 16),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     }).toList(),
                  //   ),
                  // ),

                  const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Text(
                      'Select Date*',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    height: 90,
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                      color: const Color(0xFFEAEAEA),
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index1) {
                          return const SizedBox(width: 10);
                        },
                        itemCount: 7,
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              final DateFormat formatter =
                                  DateFormat('dd-MM-yyyy');
                              final String formatted = formatter.format(
                                  DateTime.now().add(Duration(days: index)));
                              print(formatted);
                              setState(() {
                                currentDateSelectedIndex = index.toString();
                                selectedDate =
                                    DateTime.now().add(Duration(days: index));
                                date = formatted;
                                // _scheduletime(selectedDate);
                              });
                              _changescheduletime(formatted);
                            },
                            child: Container(
                              height: 97,
                              width: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  currentDateSelectedIndex == ''
                                      ? const BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0, 0),
                                          blurRadius: 0,
                                        )
                                      : currentDateSelectedIndex ==
                                              index.toString()
                                          ? const BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(2, 2),
                                              blurRadius: 5)
                                          : const BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(0, 0),
                                              blurRadius: 0,
                                            ),
                                ],
                                color: currentDateSelectedIndex == ''
                                    ? const Color(0xFFEAEAEA)
                                    : currentDateSelectedIndex ==
                                            index.toString()
                                        ? const Color(0xFF5C88DA)
                                        : const Color(0xFFEAEAEA),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    listOfMonths[DateTime.now()
                                                .add(Duration(days: index))
                                                .month -
                                            1]
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: currentDateSelectedIndex == ''
                                            ? Colors.black
                                            : currentDateSelectedIndex ==
                                                    index.toString()
                                                ? Colors.white
                                                : Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    DateTime.now()
                                        .add(Duration(days: index))
                                        .day
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: currentDateSelectedIndex == ''
                                            ? Colors.black
                                            : currentDateSelectedIndex ==
                                                    index.toString()
                                                ? Colors.white
                                                : Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    listOfDays[DateTime.now()
                                                .add(Duration(days: index))
                                                .weekday -
                                            1]
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: currentDateSelectedIndex == ''
                                            ? Colors.black
                                            : currentDateSelectedIndex ==
                                                    index.toString()
                                                ? Colors.white
                                                : Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Text(
                      'Select Time Range*',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  Container(
                    height: 148,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.fromLTRB(1, 0, 11, 7),
                    child: GridView.count(
                      crossAxisCount: 4, // Number of columns in the grid
                      // mainAxisSpacing: 10.0, // Spacing between vertical items
                      // crossAxisSpacing:
                      //     10.0, // Spacing between horizontal items
                      childAspectRatio: (itemWidth /
                          itemHeight), // Ratio between item width and height

                      scrollDirection: Axis.vertical,
                      // controller: scrollController,
                      children: List.generate(_time.length, (index) {
                        // List<String> textList = "08-10 AM".split(' ');
                        print(_time[index]['isSelect']);
                        return Container(
                          // height: 25,
                          margin: EdgeInsets.fromLTRB(6, 6, 0, 6),
                          child: InkWell(
                            onTap: () {
                              print(_time[index]);
                              setState(() {
                                currentDateSelectedIndex1 = index.toString();
                                // time = widgetList[index]['name'];
                                timeId = _time[index]['id'].toString();
                              });
                              // _changescheduletime(date);
                            },
                            child: Container(
                              // height: 49,
                              // width: 125,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  currentDateSelectedIndex1 == ''
                                      ? const BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0, 0),
                                          blurRadius: 0,
                                        )
                                      : currentDateSelectedIndex1 ==
                                              index.toString()
                                          ? const BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(2, 2),
                                              blurRadius: 5)
                                          : const BoxShadow(
                                              color: Colors.grey,
                                              offset: Offset(0, 0),
                                              blurRadius: 0,
                                            ),
                                ],
                                color: currentDateSelectedIndex1 == ''
                                    ? const Color(0xFFEAEAEA)
                                    : currentDateSelectedIndex1 ==
                                            index.toString()
                                        ? const Color.fromRGBO(
                                            92, 136, 218, 1.0)
                                        : const Color(0xFFEAEAEA),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        _time[index]['schedule_range']
                                            .toString()
                                            .split(' ')[0],
                                        style: TextStyle(
                                          color: currentDateSelectedIndex1 == ''
                                              ? Colors.black
                                              : currentDateSelectedIndex1 ==
                                                      index.toString()
                                                  ? Colors.white
                                                  : Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        _time[index]['schedule_range']
                                            .toString()
                                            .split(' ')[1],
                                        style: TextStyle(
                                            color: currentDateSelectedIndex1 ==
                                                    ''
                                                ? Colors.black
                                                : currentDateSelectedIndex1 ==
                                                        index.toString()
                                                    ? Colors.white
                                                    : Colors.black,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  // Center(
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width - 180,
                  //     height: 52,
                  //     margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                  //     child: TextButton(
                  //       onPressed: () {
                  //         //  Navigator.pushNamed(context,'/screens/Payment');
                  //         _addDate.forEach((item) => {
                  //               print(item),
                  //               // if (_addDate1.contains(item["date"]))
                  //               //   {
                  //               //     // print("duplicate ${item["date"]}"),
                  //               //   }
                  //               // else
                  //               //   {
                  //               //     // print("duplicate ${item["date"]}"),
                  //               //     _addDate1.add(item)
                  //               //   }
                  //             });
                  //       },
                  //       style: TextButton.styleFrom(
                  //         backgroundColor: const Color.fromRGBO(
                  //             28, 41, 65, 1.0), // Background color
                  //         // padding: EdgeInsets.symmetric(
                  //         //     horizontal: 20, vertical: 10), // Padding
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius:
                  //               BorderRadius.circular(9), // Button shape
                  //         ),
                  //         // textStyle: TextStyle(fontSize: 16), // Text style
                  //         alignment: Alignment
                  //             .center, // Alignment of text within the button
                  //       ),
                  //       child: Padding(
                  //         padding: const EdgeInsets.fromLTRB(12.0, 4, 12, 4),
                  //         child: Text(
                  //           "Add".toUpperCase(),
                  //           style: const TextStyle(
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              SizedBox(
                height: 4,
                child: Container(
                  color: const Color.fromRGBO(210, 210, 210, 1.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 9),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Select Society*",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        height: 190,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: _aspectRatio,
                          ),
                          itemCount: society.length,
                          controller: scrollController,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  // society[index]['isSchedule'] =
                                  //     !society[index]['isSchedule'];
                                  // _tower = society[index]['tower'];
                                  societySelectIndex = index.toString();
                                  societySel = society[index]['name'];
                                  societyid = society[index]['id'].toString();
                                });
                                // log('@@@${society[index]['tower'][0]['socityArry']}');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: societySelectIndex == ''
                                      ? HexColor('#EAEAEA')
                                      : societySelectIndex == index.toString()
                                          ? HexColor('#5C88DA')
                                          : HexColor('#EAEAEA'),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.white,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    society[index]['name'].toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: societySelectIndex == ''
                                          ? Colors.black
                                          : societySelectIndex ==
                                                  index.toString()
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 42,
                        width: MediaQuery.of(context).size.width - 160,
                        margin: EdgeInsets.symmetric(vertical: 12),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(28, 41, 65, 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            _newSociety();
                          },
                          child: Text(
                            "Add new society".toUpperCase(),
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
              SizedBox(
                height: 4,
                child: Container(
                  color: const Color.fromRGBO(210, 210, 210, 1.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 9),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Select Tower/Block*",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        height: 190,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: _aspectRatio,
                          ),
                          itemCount: _tower.length,
                          controller: scrollController,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  towerSel = _tower[index]['name'];
                                  _tower[index]['isSelect'] =
                                      !_tower[index]['isSelect'];
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _tower[index]['isSelect']
                                      ? HexColor('#5C88DA')
                                      : HexColor('#EAEAEA'),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.white,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    _tower[index]['name'].toString(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: _tower[index]['isSelect'] == ''
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 42,
                        margin: EdgeInsets.symmetric(vertical: 12),
                        width: MediaQuery.of(context).size.width - 180,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(28, 41, 65, 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            // _assign_helper();
                            _newTower();
                          },
                          child: Text(
                            "Add new tower / block".toUpperCase(),
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
              SizedBox(
                height: 4,
                child: Container(
                  color: const Color.fromRGBO(210, 210, 210, 1.0),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 180,
                height: 52,
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 19),
                child: TextButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, '/screens/Orders');
                    submit();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(
                        28, 41, 65, 1.0), // Background color
                    // padding: EdgeInsets.symmetric(
                    //     horizontal: 20, vertical: 10), // Padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9), // Button shape
                    ),
                    // textStyle: TextStyle(fontSize: 16), // Text style
                    alignment:
                        Alignment.center, // Alignment of text within the button
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 4, 12, 4),
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
        ]),
      ),
    );
  }
}
