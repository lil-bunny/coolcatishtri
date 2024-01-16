import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishtri_db/screens/Dashboard.dart';
import 'package:ishtri_db/screens/My%20Rate.dart';
import 'package:ishtri_db/screens/MySchedule.dart';
import 'package:ishtri_db/screens/Orders.dart';
import 'package:ishtri_db/screens/View%20My%20Rate.dart';
import '../../widgets/question.dart';
import '../../widgets/CustomText.dart';
import '../models/Data.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class BottomTab extends StatefulWidget {
  const BottomTab({super.key});

  @override
  State<BottomTab> createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
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

  int _selectedIndex = 0;
  var _previousIndex = [];
  void _onItemTapped(int index) {
    print(index);
    // Get.toNamed(_widgetOptions.elementAt(index).toString());
    setState(() {
      _previousIndex.add(_selectedIndex);
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    log('@@@ tab${_previousIndex}');
    if (_selectedIndex == 0) {
      return true; // Allow app exit
    } else {
      setState(() {
        _selectedIndex = _previousIndex[_previousIndex.length - 1];
        _previousIndex.removeAt(_previousIndex.length - 1);
      });
      return false; // Do not allow app exit
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            backgroundColor: Colors.grey[100],
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Image(
                    image: AssetImage("assets/images/Home.png"),
                    color: Colors.grey,
                  ),
                  label: 'Home',
                  activeIcon: Image(
                    image: AssetImage(
                      "assets/images/Home.png",
                    ),
                    color: Colors.black,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Image(
                    image: AssetImage("assets/images/Document.png"),
                    height: 25,
                    color: Colors.grey,
                  ),
                  activeIcon: Image(
                    image: AssetImage(
                      "assets/images/Document.png",
                    ),
                    color: Colors.black,
                    height: 25,
                  ),
                  label: 'My Orders',
                ),
                BottomNavigationBarItem(
                  icon: Image(
                    image: AssetImage("assets/images/Schedule.png"),
                    color: Colors.grey,
                    height: 25,
                  ),
                  activeIcon: Image(
                    image: AssetImage(
                      "assets/images/Schedule.png",
                    ),
                    color: Colors.black,
                    height: 27,
                  ),
                  label: 'My Schedule',
                ),
                BottomNavigationBarItem(
                  icon: Image(
                    image: AssetImage("assets/images/To_Do.png"),
                    height: 25,
                    color: Colors.grey,
                  ),
                  activeIcon: Image(
                    image: AssetImage(
                      "assets/images/To_Do.png",
                    ),
                    height: 25,
                    color: Colors.black,
                  ),
                  label: 'My Rates',
                ),
              ],
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.grey,
              iconSize: 40,
              onTap: _onItemTapped,
              elevation: 5,
            ),
            body: _selectedIndex == 0
                ? Dashboard()
                : _selectedIndex == 1
                    ? Orders()
                    : _selectedIndex == 2
                        ? MySchedule()
                        : ViewMyRate()));
  }
}
