import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ishtri_db/statemanagemnt/provider/LaundryDataProvider.dart';
import 'package:ishtri_db/widgets/question.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' as Io;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddLaundryUploadDocument extends StatefulWidget {
  const AddLaundryUploadDocument({super.key});

  @override
  State<AddLaundryUploadDocument> createState() =>
      _AddLaundryUploadDocumentState();
}

class _AddLaundryUploadDocumentState extends State<AddLaundryUploadDocument> {
  var isOpen = false;
  File? image;
  var gstno = '', cgst = '', sgst = '';

  Uint8List Selimage = base64.decode(
      'iVBORw0KGgoAAAANSUhEUgAAAHQAAABoCAYAAAAgjtTHAAAACXBIWXMAACE4AAAhOAFFljFgAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAhMSURBVHgB7Z1hWts4EIYnbv4vewP3AIXmBGtOUPYEhBNAT0A4QekJCCcoPQHuCSAt/+s9wbL/ge587rhPkia2lMjyyNH7PMaGKBD8WdJoNCMRRXrFgALi7u4uJf88jkajRwoE1YJ++/Yt+/Hjxzu+POIjpe6AoPf8WT6/vLzcsMAFKUWloF+/fh3z6Zy6FbGO6fPz84VGYVUJiib11atXV3yZUQAMBoPJmzdvLkgRagQVMW9Jb61cx+X+/v57UoIKQQMWs0KNqAkpIHAxwdlsNjsjBXQuKFuymo0fY7g/Pe9oWLVAp4LiBvBQYEL9YE8Muk7pVFC+AefULzJ+SDPqkM4EleZpTD2j64e0M0F7WDsrOq2lnQja19pZ0eXD2omgPa6dFailb6kDvAva99pZwQ/tKXWAd0F3oHZWjPnh3SPPeBVUaucR7QhJknj3HnkVdDgcHvPJ+1PbFew9OvVdS70Kyl6hMe0We75rqTdB++KztUVqaUqecDp99vDw8Pbl5QXm+gH9FG/edE9ptynmzo/cWs1Y7Pvn5+fcZczS1oLOxf2MaYf6R8fkfFyLuAVtwcaCStwPjJyMIi7ZKl7JWlCpkegPM4q0yUbCGgsK81ucAipm5neEgo+L/f39qekbjATtQcxP0NhEFzYKCieziBkNnm654Sb4pMkirhU0iqkLDHOenp4O60Rd61iIYuqDjVFo8qmuzEpBpc/EG6OY+sh4yPhh3YsrBWUnOsRMKaKVMxZ15azVb4LC54qqTRHtXK2ayVkQtGdxsn0HfoHfmt4FQXcomqAvjJcjDH8JuiuxPn1juRIm616IBEM2P9863+RmFHFNzscJe3hGfBzimm2UghyTJMm4ui49RWICf6L+gAnkAp4VfMPX//Bpj7//g4+UJ+Fx3aolz3/z4uDgYLLqtdlsNuW/f0zuKNiB/xoXlaDImhpT2OQ2i1qIyf9Wnu6/IDS5Y8o3+KSuAA8Pb/nzZuQItALM/RDf4GnlX04Bgpr4kUW8tA3jkPK5HBD4iB0qpy5uMuYxm8qwT/aC7ZaMHMEPZsan+4HMc/5LgSFCTlyvIYRhAN+cq01rLH+ue25qRyZluWXEfXflXi1bBdTQoLxC6BtZSEwj5dQC8ntfcz83QVY2WcLvsXnAUNaJoJV3L+HaGZID/prFHLUl5jwwaLjpfL2BVZq2VLYWfpBKHRP+wCkFAKxGblLGPpdpg3HFD9ChpaipSX6oBNm5JMUXjEPV19C6IUDbbCIqG1cf6l4XR0ArjhwVy9rUAeOnKzErbEVFf8Y18HZVxPxc4EBKLTAkxeAGspjWUYYINUUEP/cr5fiSf0/VChVyfLENakZZFuNExDAh47LfWdgbRMnjB/g81LJHTrOgj6gVNm9Av8Q3D2NJiFn+bGl8ncp5zDcb5a1iX2GMsfX7EfkqZM4Rl/eWQqm2yUW/aXqj0YxxrbzjyytLlx6E/S6JVEZg7NuGP9YVKgWVpvbSpOzDw8MxmsFtoiwwqc+19btJlhisbBZVzWKNy6gUlGuZUVAx16xTvrlTcmOpl8HkhqLe8GfMSSHqBEXtNAn9lxwbo1psQWq6vBs/SJ9JIeoENXnyJfaprXX1Mrj9mgpJy+DNyWGKOkHZ6rxuKiNLxqTUEiZrI6AvreZbNaFN0McmP630cW1nwBmtjaCx2dUmaOMT73IOsQ6TsSYm00kZqgTlfvFLUxnHoRt17DU52TXuCqFKUBaraCrjM6qfm12Tv1WQItT1oXUviqHibXaIH7ADgzIFKUKVoGzhNg0DvE71cWvwJwWG+umziB2qBGULNm0o4nUgz81pcMFzQdVQCT/xJmo1j9lQJiVFaBu2mFiVOXmCx5kmnqCUFKFt2NJoVZqMVV2ASQIDr5W6EFhtTW7jDfLlFDeZJOA+PwragIl3pkx/oJYxSWdg3pEy1BlF7J1pjL9BLkubYSAm4S/i5PAWK2SKxvnQY5OpK6RDUAtIbsqkqRw3t+rEBBqHLXsmNwsGC998p7E9kjfzt2FxlRnvWsehRjcLgWRoHskBqJkIGzWZQZE0hpQUolXQ1HSDVUkqGm3Tp0pq4qHFdJja9SjUeopsNlhF5jILi5R02zUMcqx9gOh80yQo7ZshaI6crzZYNY6el2jBqSTtHvFxsMI1h753hvGsbSabRBpOSDGqc1tIFiq03bBcPDw5OaTlSENnhOCcP7NJVWiDkFb0DmK2Bc1cV6KGtjx7MNNnkn/ygTzSdi5nG4QWsXBmmlS0LcibYTGR0ZZSQGg3ilaRSgrg5Onp6dp1KGW1L43LRaF8AkHV5WeYgCaYhR2zAFMXwoYuZMXQcl0dbaQiLPpXRLF/tkm1h4h8+gvbYIayGkwNpY5DvgH3SE/vAXDoH0mqPf45hI8UsnBjCRZvpJ+LOGIpvPm1F/pAGS6DJreg/gGhMlxUay3ME+i6hrXw//Qfzom4vwqKhE6OL+WwxVfgVaQ92Ded41wKys2SurS4iDkSoVj2oaWgsAwp0OFLZDFCsRRUIukaU+EjOpmPUPzl+tOYjRwxYmHc/UtQzCFqXXsnsp7l+OEF5zy70BAaGfvScJgup2ssCIqq6yMqPeKEx1XR/St3+J3NZndt72sS2Q7EJK9aD3HlfKgEG8emVymyKPTlqtcG696EyDmLxX4jnmjaRmRtxAI6W+zKThE1VNH9dWVqQ1BYVKz4HJtfHeQS3V+rxYAMQAxPkiS3jvcHixgifaZRaohRkNjcrgjRPegX1MYTm40UjGroPLJQ/3msra2D7u69bbqGtaAVUdjWyGWnipw2YGNBKyQxaMzCYr2BPsXo+AQJVF822TZzmf8BQJZt7386y+AAAAAASUVORK5CYII=');
  bool isChecked = false;
  var imagesel = '';
  TextEditingController _txtGstNo = TextEditingController();
  TextEditingController _txtCgst = TextEditingController();
  TextEditingController _txtSgst = TextEditingController();

  void pickimage() async {
    var status2 = await Permission.mediaLibrary.request();
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 80,
      imageQuality: 10,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      final bytes = Io.File(pickedFile.path).readAsBytesSync();
      String img64 = base64Encode(bytes);

      // var Selimageto=base64.decode(img64);
      print(bytes);
      setState(() {
        image = imageFile;
        Selimage = base64.decode(img64);
        imagesel = pickedFile.path;
      });
      Navigator.of(context).pop(context);
    }
  }

  void pickimageCamera() async {
    var status2 = await Permission.camera.request();
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
      print(img64);
      setState(() {
        image = imageFile;
        Selimage = base64.decode(img64);
        imagesel = pickedFile.path;
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

  toast(String name) {
    return Fluttertoast.showToast(
        msg: name,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }

  taxAdd() async {
    var data = {};
    if (image == '') {
      toast('Please select your laundry shop picture');
    } else {
      var data = {
        "gst_number": _txtGstNo.text,
        "cgst": _txtCgst.text,
        "sgst": _txtSgst.text,
        "file": image,
      };

      await Provider.of<LaundryDataProvider>(context, listen: false)
          .taxData(context, data);
      Navigator.pushNamed(context, '/screens/AddLaundryService');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(92, 136, 218, 1),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Laundry Tax Details",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '2',
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
                          const SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                    color: Color.fromRGBO(239, 239, 239, 1.0),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18.0, 8, 18, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextQuestion(
                              "Shop Photograph – Front Side ",
                              FontWeight.bold,
                              12,
                              '*',
                              Colors.red,
                              Colors.black),
                          const SizedBox(
                            height: 25,
                          ),
                          InkWell(
                            onTap: () {
                              _settingModalBottomSheet(context);
                            },
                            child: Stack(
                              children: [
                                image == ''
                                    ? Image(
                                        // height: 100,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        image: AssetImage(
                                            'assets/images/addhar.png'),
                                        // fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 99,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: MemoryImage(Selimage),
                                          ),
                                        ),
                                      ),
                                Center(
                                  child: image == ''
                                      ? Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 42, 0, 0),
                                          child: Text(
                                            'Upload or Capture Shop Photograph',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  182, 182, 182, 1.0),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                    color: Color.fromRGBO(239, 239, 239, 1.0),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18.0, 19, 18, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "GST Nummber",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(
                            height: 42,
                            child: TextField(
                              maxLines: 1,
                              controller: _txtGstNo,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  fillColor: Colors.transparent,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  filled: false,
                                  hintText: "Enter GST number"),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "CGST (in %)",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 42,
                                    width: (MediaQuery.of(context).size.width -
                                            81) /
                                        2,
                                    child: TextField(
                                      controller: _txtCgst,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          fillColor: Colors.transparent,
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 2.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          filled: false,
                                          hintText: "00"),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "SGST (in %)",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 42,
                                    width: (MediaQuery.of(context).size.width -
                                            81) /
                                        2,
                                    child: TextField(
                                      controller: _txtSgst,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          fillColor: Colors.transparent,
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 2.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          filled: false,
                                          hintText: "00"),
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
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 105,
              decoration: BoxDecoration(
                color: Color.fromRGBO(236, 241, 255, 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 10, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 42,
                      width: MediaQuery.of(context).size.width - 290,
                      margin: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Go back",
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 42,
                      width: MediaQuery.of(context).size.width - 180,
                      margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(28, 41, 65, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          // Navigator.pushNamed(
                          //     context, '/screens/AddLaundryService');
                          taxAdd();
                        },
                        child: const Text(
                          "Next",
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
          ),
        ],
      ),
    );
  }
}
