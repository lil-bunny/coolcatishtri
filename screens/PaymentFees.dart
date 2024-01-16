import 'dart:developer';

import 'package:easy_upi_payment/easy_upi_payment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:ishtri_db/services/Api.dart';
import 'package:ishtri_db/services/app_services.dart';

class PaymentFees extends StatefulWidget {
  const PaymentFees({super.key});

  @override
  State<PaymentFees> createState() => _PaymentFeesState();
}

class _PaymentFeesState extends State<PaymentFees> {
  bool _isChecked = false;
  dynamic upiDeta;
  // late ApplicationMeta appMeta;
  void upi() async {
    try {
      Future.delayed(Duration(microseconds: 700), () {
        showLoader(context);
      });
      dynamic data1;
      data1 = {
        'payment_status': 'done',
      };
      final data = await ApiService().sendPostRequest(
          '/v1/delivery-boy/order/update-db-service-fee', data1);
      if (kDebugMode) {
        print(data);
      }
      hideLoader(context);
      log('@@ 266${data['data']}');
      if (data?['data']['status'] == 1) {
      } else {
        log("error!");
      }
      Future.delayed(Duration(microseconds: 1200), () {});
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
      log('@@@ ${e}');
    }
  }

  void paymentdetail() async {
    try {
      Future.delayed(Duration(microseconds: 700), () {
        showLoader(context);
      });
      final data = await ApiService()
          .sendGetRequest('/v1/delivery-boy/order/get-db-service-fee');
      if (kDebugMode) {
        print(data);
      }
      hideLoader(context);
      log('@@ 266${data['data']}');
      if (data['data']['status'] == 1) {
        log('nbvdabsdfbasdn${data}');
        setState(() {
          upiDeta = data['data']['data'][0]['serviceFeeLogs'][0];
        });
      } else {
        log("error!");
      }
      Future.delayed(Duration(microseconds: 1200), () {});
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
      log('@@@ ${e}');
    }
  }

  void addupi() async {
    try {
      log('@@@${upiDeta?['additional_data']?['UPI']}');
      final res = await EasyUpiPaymentPlatform.instance.startPayment(
        EasyUpiPaymentModel(
          payeeVpa: upiDeta?['additional_data']?['UPI'],
          payeeName: "test",
          amount: double.parse(upiDeta['additional_data']['amount'].toString()),
          description: upiDeta?['message'],
        ),
      );
      upi();
      // final UpiTransactionResponse response = await UpiPay.initiateTransaction(
      //   amount: '100.00',
      //   app: appMeta.upiApplication,
      //   receiverName: 'John Doe',
      //   receiverUpiAddress: 'john@doe',
      //   transactionRef: 'UPITXREF0001',
      //   transactionNote: 'A UPI Transaction',
      // );
      // print(response.status);
      // TODO: add your success logic here
      print(res);
    } catch (e) {}
  }

  void upiapp() async {}

  // TODO: add your exception logic here
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    upiapp();
    paymentdetail();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: const Color.fromRGBO(92, 136, 218, 1),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Amount To Be Paid",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '\u20B9${upiDeta?['additional_data']?['amount'].toString()}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 28, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Payment Method",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 51,
                margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          // onChanged(!value);
                          setState(() {
                            _isChecked = true;
                          });
                        },
                        child: Container(
                          width: 24.0,
                          height: 24.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _isChecked ? Colors.blue : Colors.transparent,
                            border: Border.all(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                          child: _isChecked
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18.0,
                                )
                              : null,
                        ),
                      ),
                    ),
                    Text("UPI:" + ' ' + upiDeta?['additional_data']?['UPI'],
                        style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 180,
                height: 42,
                margin: const EdgeInsets.fromLTRB(0, 11, 0, 12),
                child: TextButton(
                  onPressed: () {
                    addupi();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(
                        28, 41, 65, 1.0), // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9), // Button shape
                    ),
                    alignment:
                        Alignment.center, // Alignment of text within the button
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 4, 12, 4),
                    child: Text(
                      "continue".toUpperCase(),
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
    );
  }
}
