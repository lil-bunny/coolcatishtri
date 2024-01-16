import 'package:ishtri_db/statemanagemnt/provider/CustomerDataProvider.dart';
import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:ishtri_db/ApiRequest/ApiRequestPost.dart';
import 'package:provider/provider.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: 'AIzaSyDeK9JLWPV_0-BCT3A63jji-NymGtLWVW4');
  var location = '';
  var isSelect = '0';
  List<Prediction> _predictions = [];
  Future<void> _autocompletePlaces(String input) async {
    print(input.isEmpty);
    if (input.isEmpty) {
      setState(() {
        _predictions = [];
      });
      return;
    }

    PlacesAutocompleteResponse response =
        await _places.autocomplete(input, types: []);
    // print('response${response.predictions[0]}');
    if (response.isOkay) {
      setState(() {
        _predictions = response.predictions;
      });
    }
  }

  locationSet(String locationres) async {
    await Provider.of<CustomerDataProvider>(context, listen: false)
        .locationShareGet(context, locationres);
    Navigator.pushNamed(context, '/screens/AddCustomer');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
        backgroundColor: const Color.fromRGBO(92, 136, 218, 1),
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
      body: SingleChildScrollView(
        child: Container(
          // height: 200,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "Enter Location",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 42,
                          width: MediaQuery.of(context).size.width - 40,
                          child: TextField(
                            onChanged: (text) {
                              // value = text;
                              _autocompletePlaces(text);
                              setState(() {
                                isSelect = '1';
                              });
                              if (text.isEmpty) {
                                setState(() {
                                  _predictions = [];
                                });
                                setState(() {
                                  isSelect = '0';
                                });
                              } else {
                                setState(() {
                                  isSelect = '1';
                                });
                              }
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              // icon: Icon(""),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2.0,
                                  color: Colors.grey,
                                ),
                              ),
                              filled: false,
                              // labelText: "",
                              hintText:
                                  "Flat no, Building name, Area, Street name...",
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 19,
                              ),
                            ),
                            style: const TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                            onTap: () => {
                              print('hjfgfhsvndfvdns'),
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Column(
                        //   children: [
                        //     InkWell(
                        //       onTap: () {
                        //         Navigator.pushNamed(
                        //             context, "/screens/GoogleMapApp");
                        //       },
                        //       child: Container(
                        //         margin: const EdgeInsets.only(top: 10),
                        //         child: Padding(
                        //           padding: const EdgeInsets.symmetric(
                        //               horizontal: 0.0),
                        //           child: Row(
                        //             children: const [
                        //               Image(
                        //                 image: AssetImage(
                        //                     'assets/images/Collect.png'),
                        //               ),
                        //               Text(
                        //                 "   Current Location using GPS",
                        //                 style: TextStyle(
                        //                   fontSize: 16,
                        //                   color:
                        //                       Color.fromRGBO(92, 136, 218, 1),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 6,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[400],
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Container(
                  height: isSelect == '1' ? 250 : 10,
                  child: ListView.builder(
                    itemCount: _predictions.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: InkWell(
                          child: Row(
                            children: [
                              const Image(
                                image:
                                    AssetImage('assets/images/Locationmap.png'),
                                height: 22,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 90,
                                child: Text(
                                  _predictions[index].description.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () async {
                            // Handle selection

                            location = await _predictions[index]
                                .description
                                .toString();
                            locationSet(location);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
