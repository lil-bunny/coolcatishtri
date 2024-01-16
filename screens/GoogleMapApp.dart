import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ishtri_db/extensions/color.dart';
import 'package:ishtri_db/models/City.dart';
import 'package:ishtri_db/statemanagemnt/provider/CustomerDataProvider.dart';
import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
import 'package:provider/provider.dart';

class GoogleMapApp extends StatefulWidget {
  const GoogleMapApp({super.key});

  @override
  State<GoogleMapApp> createState() => _GoogleMapAppState();
}

class _GoogleMapAppState extends State<GoogleMapApp> {
  bool _isChecked = false;
  var _numberForm = GlobalKey<FormState>();
  var fullName = '',
      fname = '',
      lname = '',
      address = '',
      landmark = '',
      state = '',
      stateId = 0,
      city = '',
      cityId = 0,
      pincode = '',
      token = '',
      phone_no = '',
      alter_no = '';
  var cityArr = [];
  var stateArr = [];

  String dob = '';
  City city1 = City();
  DateTime? selectedDate;
  dynamic flat = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<SignupDataProvider>(context, listen: false)
        .getDataState(context);
    getCity('1');
  }

  toast(String name) {
    return Fluttertoast.showToast(
        msg: name,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }

  void signup() async {
    if (fullName == '') {
      toast('Please enter your full name');
    } else if (fname == '') {
      toast('Please enter your mobile number');
    } else if (lname == '') {
      toast('Please enter your mobile number');
    } else if (phone_no == '') {
      toast('Please enter your mobile number');
    } else if (alter_no == '') {
      toast('Please enter your mobile number');
    } else if (landmark == '') {
      toast('Please enter your area');
    } else if (address == '') {
      toast('Please select your state');
    } else if (city == '') {
      toast('Please select your city');
    } else if (pincode == '') {
      toast('Please enter your pincode');
    } else {
      var data = {
        "firstName": fname,
        "lastName": lname,
        "primary_phone_no": phone_no,
        "alternate_phone_no": phone_no,
        "address": flat,
        "street": landmark,
        "city": cityId.toString(),
        "pincode": pincode,
      };

      try {
        final reg =
            await Provider.of<CustomerDataProvider>(context, listen: false)
                .customer;
        print('reg ${reg?.status}');
        if (reg?.status == 1) {
          print('reg ${reg?.status}');
          var mes = reg?.data![0].message;
          toast(mes!);
        } else {
          var mes = reg?.data![0].message;
          toast(mes!);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  getCity(id) async {
    var data = {
      "id": id,
    };
    Provider.of<SignupDataProvider>(context, listen: false)
        .getDataCity(context, data);
  }

  getCityD() {
    cityArr = [];
    final postMdl = Provider.of<SignupDataProvider>(context);
    print('postMdl${postMdl.loading}');
    postMdl.city?.data
        ?.map((item) => {
              print('city ${item.id}'),
              // print('postMdl  ${postMdl.city!.data}')
              cityArr.add({
                "id": item.id,
                "name": item.name,
                "isSelect": false,
              })
            })
        .toList();

    print(cityArr);
  }

  getState() {
    stateArr = [];
    final postMdl = Provider.of<SignupDataProvider>(context);
    print('postMdl${postMdl.loading}');
    postMdl.state?.data
        ?.map((item) => {
              print('city ${item.id}'),
              // print('postMdl  ${postMdl.city!.data}')
              stateArr.add({
                "id": item.id,
                "name": item.name,
                "isSelect": false,
              })
            })
        .toList();

    print(stateArr);
  }

  CustomDialogCity(BuildContext context) {
    // DialogHelper();

    return Dialog(
      // Add your custom dialog content here
      child: Container(
        // padding: EdgeInsets.all(0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Select City',
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
              height: 100,
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
                        }),
                        Navigator.of(context).pop()
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              height: 22,
                              width: 22,
                              margin: const EdgeInsets.fromLTRB(0, 0, 9, 0),
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
                                        color: HexColor('#5C88DA'),
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
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomDialogCity(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogCity(context); // Use the custom dialog widget here
      },
    );
  }

  GoogleMapController? mapController;
  static final LatLng _kMapCenter =
      LatLng(19.018255973653343, 72.84793849278007);

  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);

  @override
  Widget build(BuildContext context) {
    getCityD();
    getState();
    flat = Provider.of<CustomerDataProvider>(context, listen: false).location;
    token = Provider.of<SignupDataProvider>(context, listen: false).storedName;
    print(token);
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromRGBO(92, 136, 218, 1), //const Color(0x5C88DA),
        title: const Text("Add Customer"),
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
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 400,
              width: MediaQuery.of(context).size.width,
              // color: Colors.amber,
              child: GoogleMap(
                onMapCreated: (controller) {
                  setState(() {
                    mapController = controller;
                  });
                },
                mapType: MapType.satellite,

                // markers: this.myMarker(),
                initialCameraPosition: _kInitialPosition,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Location",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontFamily: '',
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter Exact Details*",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(
                        child: TextField(
                          onChanged: (text) {
                            pincode = text;
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
                              hintText: "Flat no, Building Name..."),
                        ),
                      ),
                      const SizedBox(
                        height: 19,
                      ),
                      Text(
                        "Selected Location",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
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
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 105,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                    context, "/screens/AddCustomer");
                              },
                              child: Text(
                                "confirm location".toUpperCase(),
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
          ],
        ),
      ),
    );
  }
}
