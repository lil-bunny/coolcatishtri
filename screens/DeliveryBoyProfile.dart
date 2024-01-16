import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ishtri_db/screens/Permission.dart';
import 'package:ishtri_db/screens/auth/DbLogin.dart';
import 'package:ishtri_db/screens/auth/WelcomeSignup.dart';
import 'package:ishtri_db/services/app_services.dart';
import 'package:ishtri_db/statemanagemnt/provider/DBProfileDataProvider.dart';
import 'package:ishtri_db/statemanagemnt/provider/SignupDataProvider.dart';
import 'package:provider/provider.dart';

class DeliveryBoyProfile extends StatefulWidget {
  const DeliveryBoyProfile({super.key});

  @override
  State<DeliveryBoyProfile> createState() => _DeliveryBoyProfileState();
}

class _DeliveryBoyProfileState extends State<DeliveryBoyProfile> {
  ScrollController scrollController = ScrollController();
  var arr = [];
  var token = '';
  String? firstName = '',
      lastName = '',
      email = '',
      image = '',
      primary_phone_no = '',
      alternate_phone_no = '',
      address = '',
      city = '',
      pincode = '';
  double rating = 0.0;
  bool loading = false;
  void logoutDb() async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const PermissionScreen()),
        (Route route) => false);
    await Provider.of<SignupDataProvider>(context, listen: false).logout();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _details();
  }

  @override
  void dispose() {
    // _controller.removeListener(_loadMore);
    super.dispose();
  }

  _details() async {
    setState(() {
      arr = [];
      loading = true;
    });
    Future.delayed(Duration(seconds: 1), () {
      showLoader(context);
    });
    // Future.delayed(Duration(seconds: 2), () {
    await Provider.of<DBProfileDataProvider>(context, listen: false)
        .profileData(context);
    var res = await Provider.of<DBProfileDataProvider>(context, listen: false)
        .dBdetails;

    // arr = [res?.data![0].dbDetails == null ? [] : res?.data![0].dbDetails];
    if (res?.status == 1) {
      setState(() {
        firstName = (res?.data![0].dbDetails?.firstName == ''
            ? ''
            : '${res?.data![0].dbDetails?.firstName} ${res?.data![0].dbDetails?.lastName}')!;
        address = (res?.data![0].dbDetails?.address == ''
            ? ''
            : res?.data![0].dbDetails?.address)!;
        image = (res?.data![0].dbDetails?.newProfileImageName == ''
            ? ''
            : res?.data![0].dbDetails?.newProfileImageName)!;
        rating = (res?.data![0].dbDetails?.rating == ''
            ? 0
            : res?.data![0].dbDetails?.rating)!;
        loading = false;
      });

      // });
      Future.delayed(Duration(seconds: 1), () {
        hideLoader(context);
      });
      print(firstName);
    } else {
      Future.delayed(Duration(seconds: 1), () {
        hideLoader(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // _details();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor:
              const Color.fromRGBO(92, 136, 218, 1), //const Color(0x5C88DA),
          flexibleSpace: const FlexibleSpaceBar(
            background: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 29, 0, 0),
              child: Image(
                color: Colors.white,
                height: 25,
                width: 90,
                image: AssetImage(
                    'assets/images/base_logo_transparent_background.png'),
              ),
            ),
          ),
          leading: Container(
            margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: IconButton(
              icon: const Image(
                image: AssetImage("assets/images/Close.png"),
                height: 25,
                width: 25,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: const Color.fromRGBO(236, 241, 255, 1.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 9),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  // height: 90,
                                  // width: 90,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: image == ''
                                      ? Image(
                                          height: 120,
                                          width: 120,
                                          image: AssetImage(
                                              "assets/images/AccountLaundry.png"),
                                        )
                                      : ClipOval(
                                          child: Image.network(
                                            height: 90,
                                            width: 90,
                                            fit: BoxFit.cover,
                                            image.toString(),
                                          ),
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        firstName!,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Laundry Associate",
                                        style: TextStyle(
                                          fontSize: 14,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(
                            //   height: 12,
                            // ),
                            InkWell(
                              onTap: () => {
                                Navigator.pushNamed(
                                    context, '/screens/EditDBProfile')
                              },
                              child: Column(
                                children: const [
                                  Image(
                                    height: 30,
                                    width: 30,
                                    image:
                                        AssetImage('assets/images/Pencil.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   width: 12,
                            // )
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   width: 12,
                      // ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color.fromRGBO(92, 136, 218, 1),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7.0, vertical: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Image(
                                image:
                                    AssetImage('assets/images/locationgps.png'),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 71,
                                child: Text(
                                  address!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 25,
                          ),
                          Text(
                            "Ratings: " + "${rating.toString()}/5",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Container(
                            height: 25,
                            width: 125,
                            margin: const EdgeInsets.fromLTRB(7, 0, 0, 0),
                            alignment: Alignment.center,
                            child: Align(
                              alignment: Alignment.center,
                              child: ListView.builder(
                                itemCount: int.parse(rating.toStringAsFixed(0)),
                                physics: const ScrollPhysics(),
                                controller: scrollController,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return const Image(
                                    height: 15,
                                    width: 15,
                                    image: AssetImage(
                                        "assets/images/Hand Drawn Star.png"),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28.0, vertical: 12),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/screens/Customers");
                      },
                      child: Row(
                        children: [
                          const Image(
                            image: AssetImage('assets/images/Users.png'),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          const Text(
                            "My Customers",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/screens/AddService");
                      },
                      child: Row(
                        children: [
                          const Image(
                            image: AssetImage(
                                'assets/images/Washing Machine gray.png'),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          const Text(
                            "My Own Laundry Services",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/screens/Helpers");
                      },
                      child: Row(
                        children: [
                          const Image(
                            image: AssetImage('assets/images/Supplier.png'),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          const Text(
                            "My Own Laundry Helpers",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/screens/Laundrys");
                      },
                      child: Row(
                        children: const [
                          Image(
                            image: AssetImage(
                                'assets/images/Washing Machine gray.png'),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "Add Other Laundries",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/screens/PaymentFees");
                      },
                      child: Row(
                        children: const [
                          Image(
                            image: AssetImage(
                                'assets/images/Washing Machine gray.png'),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "Service Fees",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/screens/Linkls');
                      },
                      child: Row(
                        children: const [
                          Image(
                            image: AssetImage(
                                'assets/images/Networking Manager.png'),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "Link Laundries Services",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        const Image(
                          image: AssetImage(
                              'assets/images/Mechanistic Analysis.png'),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text(
                          "Settings",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: () => logoutDb(),
                      child: Row(
                        children: [
                          const Image(
                            image: AssetImage('assets/images/Logout.png'),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          const Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: const Color.fromRGBO(236, 241, 255, 1.0),
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 12, 12, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Image(
                          image: AssetImage('assets/images/Phone.png'),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Call Admin",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const Text(
                              "App version 1.01",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
