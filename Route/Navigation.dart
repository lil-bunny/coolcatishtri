import 'package:ishtri_db/screens/Add%20Customer.dart';
import 'package:ishtri_db/screens/Add%20Helper%20Aadhar%20Card.dart';
import 'package:ishtri_db/screens/Add%20Issue.dart';
import 'package:ishtri_db/screens/AddHelper.dart';
import 'package:ishtri_db/screens/AddLaundry.dart';
import 'package:ishtri_db/screens/AddLaundryService.dart';
import 'package:ishtri_db/screens/AddLaundryUploadDocument.dart';
import 'package:ishtri_db/screens/AddService.dart';
import 'package:ishtri_db/screens/CS%20Add%20Request.dart';
import 'package:ishtri_db/screens/Change%20Helper.dart';
import 'package:ishtri_db/screens/Customer%20Orders.dart';
import 'package:ishtri_db/screens/Customers%20Profile.dart';
import 'package:ishtri_db/screens/Customers.dart';
import 'package:ishtri_db/screens/Dashboard.dart';
import 'package:ishtri_db/screens/Bottom Tab.dart';
import 'package:ishtri_db/screens/Delivery%20Boy.dart';
import 'package:ishtri_db/screens/DeliveryBoyProfile.dart';
import 'package:ishtri_db/screens/EditDBProfile.dart';
import 'package:ishtri_db/screens/GoogleMapApp.dart';
import 'package:ishtri_db/screens/Helpers%20Profile.dart';
import 'package:ishtri_db/screens/Helpers.dart';
import 'package:ishtri_db/screens/Laundry%20Orders.dart';
import 'package:ishtri_db/screens/Laundry%20Profile.dart';
import 'package:ishtri_db/screens/LaundryServiceRate.dart';
import 'package:ishtri_db/screens/Laundrys.dart';
import 'package:ishtri_db/screens/Link%20Ls.dart';
import 'package:ishtri_db/screens/Location.dart';
import 'package:ishtri_db/screens/My Rate.dart';
import 'package:ishtri_db/screens/MySchedule.dart';
import 'package:ishtri_db/screens/Order%20Details.dart';
import 'package:ishtri_db/screens/Orders.dart';
import 'package:ishtri_db/screens/Payment.dart';
import 'package:ishtri_db/screens/PaymentFees.dart';
import 'package:ishtri_db/screens/PaymentVerify.dart';
import 'package:ishtri_db/screens/PaymentVerifyReq.dart';
import 'package:ishtri_db/screens/PaymentVerifySuccess.dart';
import 'package:ishtri_db/screens/Permission.dart';
import 'package:ishtri_db/screens/PickupOrder.dart';
import 'package:ishtri_db/screens/Service%20Item%20List.dart';
import 'package:ishtri_db/screens/Special%20Service%20Rate.dart';
import 'package:ishtri_db/screens/Splash.dart';
import 'package:ishtri_db/screens/Thank you helper.dart';
import 'package:ishtri_db/screens/Thank%20you.dart';
import 'package:ishtri_db/screens/View%20My%20Rate.dart';
import 'package:ishtri_db/screens/Welcome.dart';
import 'package:ishtri_db/screens/auth/Aadhar%20Card.dart';
import 'package:ishtri_db/screens/auth/CompleteProfile.dart';
import 'package:ishtri_db/screens/auth/DbLogin.dart';
import 'package:ishtri_db/screens/auth/Otp.dart';
import 'package:ishtri_db/screens/auth/TermsConditions.dart';
import 'package:ishtri_db/screens/auth/WelcomeSignup.dart';

class Navigation {
  static var screen = {
    "/screens": (context) => const Splash(),
    "/screens/Dashboard": (context) => const Dashboard(),
    "/screens/AddService": (context) => const AddService(),
    "/screens/MyRates": (context) => const MyRate(),
    "/screens/LaundryServiceMyRate": (context) => const LaundryServiceMyRate(),
    "/screens/ViewMyRates": (context) => const ViewMyRate(),
    "/screens/BottomTab": (context) => const BottomTab(),
    "/screens/AddLaundry": (context) => const AddLaundry(),
    "/screens/WelcomeSignup": (context) => const WelcomeSignup(),
    "/screens/AddHelperAadharCard": (context) => const AddHelperAadharCard(),
    "/screens/AddCustomer": (context) => const AddCustomer(),
    "/screens/Welcome": (context) => const Welcome(),
    "/screens/AddLaundryUploadDocument": (context) =>
        const AddLaundryUploadDocument(),
    "/screens/MySchedule": (context) => const MySchedule(),
    "/screens/Orders": (context) => const Orders(),
    "/screens/PickupOrder": (context) => const PickupOrder(),
    "/screens/AddIssue": (context) => const AddIssue(),
    "/screens/OrderDetails": (context) => const OrderDetails(),
    "/screens/AddLaundryService": (context) => const AddLaundryService(),
    "/screens/DeliveryBoy": (context) => const DeliveryBoy(),
    "/screens/LaundryProfile": (context) => const LaundryProfile(),
    "/screens/LaundryOrders": (context) => const LaundryOrders(),
    "/screens/ServiceItemList": (context) => const ServiceItemList(),
    "/screens/Customers": (context) => const Customers(),
    "/screens/CSAddRequest": (context) => const CSAddRequest(),
    "/screens/CustomersProfile": (context) => const CustomersProfile(),
    "/screens/Laundrys": (context) => const Laundrys(),
    "/screens/SpecialServiceRate": (context) => const SpecialServiceRate(),
    "/screens/DeliveryBoyProfile": (context) => const DeliveryBoyProfile(),
    "/screens/CustomerOrders": (context) => const CustomerOrders(),
    "/screens/ChangeHelper": (context) => const ChangeHelper(),
    "/screens/Helpers": (context) => const Helpers(),
    "/screens/HelpersProfile": (context) => const HelpersProfile(),
    "/screens/Permission": (context) => const PermissionScreen(),
    "/screens/LoginPage": (context) => const LoginPage(),
    "/screens/EditDBProfile": (context) => const EditDBProfile(),
    "/screens/DbLogin": (context) => const DbLogin(),
    "/screens/Otp": (context) => const Otp(),
    "/screens/AadharCard": (context) => const AadharCard(),
    "/screens/TermsConditions": (context) => const TermsConditions(),
    "/screens/Payment": (context) => const Payment(),
    "/screens/AddHelper": (context) => const AddHelper(),
    "/screens/Linkls": (context) => const Linkls(),
    "/screens/Thankyouhelper": (context) => const Thankyouhelper(),
    "/screens/Thankyou": (context) => const Thankyou(),
    "/screens/PaymentVerify": (context) => const PaymentVerify(),
    "/screens/PaymentVerifyReq": (context) => const PaymentVerifyReq(),
    "/screens/PaymentVerifySuccess": (context) => const PaymentVerifySuccess(),
    "/screens/Location": (context) => const Location(),
    "/screens/GoogleMapApp": (context) => const GoogleMapApp(),
    "/screens/PaymentFees": (context) => const PaymentFees(),
  };
}
