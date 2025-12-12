import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';


class AppColor {
  // static  Color primeryColor = Color(0xFFFFC107);
  // static  Color secondaryColor = Color(0xFF333333);
  // static Color borderColor = Color(0xFF727272);
  // static  Color textfeildclr =  Color(0xFF383838);
  static Color ontap = Color(0xFF666666);
  static Color container = Color(0xff333333);
  static Color red = Color(0xffF02252);
  static Color green = Color(0xff3CE4A3);

  ///New Design
  static Color primaryColor = Color(0xFFF202126);
  static Color secondprimaryColor = Color(0xFFFFE5900);
  static Color secondaryColor = Color(0xFFFFFFFF);
  static Color borderColor = Color(0xFFE2E2E2);
  static Color textclr = Color(0xFF6F7C8E);
  static Color radiobutton = Color(0xFFD9D9D9);
}

class Helper {
  /*================ progress bar ================*/
  static Widget getProgressBar(BuildContext context, bool _isVisible) {
    return Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: _isVisible,
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: SpinKitFadingGrid(
                color: AppColor.secondaryColor,
                size: 40.0,
              ),
            ),
          ),
        ));
  }

  static Widget progressBar(BuildContext context, bool _isVisible) {
    return Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: _isVisible,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // margin: EdgeInsets.only(top: 20),
          color: Colors.black54,
          // child: Center(
          //   child: SpinKitSpinningLines(
          //     size: 60.0,
          //     color: AppColor.primeryColor,
          //     lineWidth: 3,
          //   ),
          // ),
        ));
  }

  static Widget getProgressBarWhite(BuildContext context, bool _isVisible) {
    return Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: _isVisible,
        child: Container(
          margin: EdgeInsets.only(top: 20),
            child: Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(child: CircularProgressIndicator(color: AppColor.primaryColor,),)
            )
        ));
  }

  /*================ check Internet ================*/

  static Future<void> checkInternet(Future<dynamic> callback) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      callback.asStream();
      // callback.call();
    } else {
      Fluttertoast.showToast(msg: StaticMessages.CHECK_INTERNET);
    }
  }

  static Future<bool> internet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
      // callback.call();
    } else {
      Fluttertoast.showToast(msg: StaticMessages.CHECK_INTERNET);
      return false;
    }
  }


  static void error1(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// ❌ Error snackbar (red)
  static void error(String message) {
    show(message, backgroundColor: Colors.black87);
  }

  static void show(String message, {Color? backgroundColor}) {
    MyApp.messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor ?? Colors.black87,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /*================ next Focus ================*/

  static void nextFocus(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  /*================ open web ================*/

  // static Future<bool> launchUrl(String url) async{

  //   if (await canLaunch(url)) {
  //     await launch(url);
  //     return true;
  //   } else {
  //     print( 'Could not launch $url');
  //     return false;
  //   }
  // }

  /*================ for navigation ================*/

  static Future<void> moveToScreenwithPush(
      BuildContext context, dynamic nextscreen) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => nextscreen));
  }

  static moveToScreenwithPushreplaceemt(
      BuildContext context, dynamic nextscreen) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => nextscreen));
  }

  static moveToScreenwithRoutClear(BuildContext context, Widget Function() nextScreen) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => nextScreen()),
          (Route<dynamic> route) => false,
    );
  }


  static popScreen(BuildContext context) {
    Navigator.pop(context);
  }

/*================ for navigation ================*/

/*================ share sheet ================*/

// static  void  shareSheet(  BuildContext context,String shareData)  {
//   {
//     Share.share(shareData);
//     // Share.share(shareData, subject: 'Look what I made!');
//     //  Share.shareFiles([shareData], text: 'Great picture');
//     // Share.shareFiles([shareData, shareData]);
//
//   }
// }

/*================ social media webviews ================*/
}

class Apis {
  static const BASEURL = "https://freawork.com/freawork/index.php/UserController/";

  // Customer screens API'S
  static const profile = BASEURL + "profile";
  static const stripeKey = 'pk_live_51Pv2lHKV9BwnYZ3icgt94144ooTKIDkX7w5bbR4TxD5cQ7ci3lvyTlmwrNtCOkfuxpERUMnngZIM6ZJXGzIVWRUg00LFEux6uq';
   static const paymentintent = BASEURL + "paymentintent";
  // static const paymentintent = BASEURL + "paymentintent_test";

  static const booking = BASEURL + "booking"; // Fix the booking endpoint
  static const faqList = BASEURL + "faq";

  static const chat_user_list = BASEURL + "chat_user_list";
  static const chat_user = BASEURL + "chat_user";
  static const sendNotification = BASEURL + "faq";
  static const subscriptionlist = BASEURL + "subscriptionlist";
  static const subscription_check_expiry = BASEURL + "subscription_check_expiry";
  static const subscription = BASEURL + "subscription";
  static const subscription_check = BASEURL + "subscription_check";
  static const mobile_number_check = BASEURL + "mobile_number_check";
  static const login_phone_number = BASEURL + "login_phone_number";
  static const notificationlist = BASEURL + "notificationlist";
  static const need_help = BASEURL + "need_help";
  static const delete_subscription = BASEURL + "delete_subscription";
  static const check_subscription_and_limit = BASEURL + "check_subscription_and_limit";
  static const subscription_hide = BASEURL + "subscription_hide";
  static const forgetuserpassword = BASEURL + "forgetuserpassword";
  static const paymentintent_test = BASEURL + "paymentintent_test";
  static const advertisement_list = BASEURL + "advertisement_list";
  static const firebaseServerKey =
      'AAAAObplcGo:APA91bEnJ1da4igcz6L4YVz_ND740-LFh0QJW2xywAqc4NMGjsZC4RMqIPQv2brlHM-f7xHzIz2TDy4G5KGQ81kd3yNmNu75DLFs4pohYaR6Ib2V1mNofk-VcfalOXcBoRxTuuaaMKNe';
  static const urlFirebase = 'https://fcm.googleapis.com/fcm/send';

}

class StaticMessages {
  static const CHECK_INTERNET = "Please Check Internet Connection";
  static const API_ERROR = "Something Went Wrong";
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class SessionHelper {
  static late SharedPreferences sharedPreferences;

  static late SessionHelper _sessionHelper;

  static const String USER_ID = "USER_ID";
  static const String NEW_PASSWORD = "NEW_PASSWORD";
  static const String FIRSTNAME = "FIRSTNAME";
  static const String COMPANY_NAME = "COMPANY_NAME";
  static const String LASTNAME = "LASTNAME";
  static const String PHONE = "PHONE";
  static const String IMAGE = "IMAGE";
  static const String ADDRESS = "STREETNAME";
  static const String LATITUDE = "CITY";
  static const String LONGITUDE = "STATE";
  static const String COUNTRY = "COUNTRY";
  static const String ZIPCODE = "ZIPCODE";
  static const String EMAIL = "EMAIL";
  static const String USERTYPE = "USERTYPE";
  static const String DEVICETOKEN = "DEVICETOKEN";
  static const stripeKey = 'pk_live_51Pv2lHKV9BwnYZ3icgt94144ooTKIDkX7w5bbR4TxD5cQ7ci3lvyTlmwrNtCOkfuxpERUMnngZIM6ZJXGzIVWRUg00LFEux6uq';

  static Future<SessionHelper> getInstance(BuildContext context) async {
    _sessionHelper = new SessionHelper();
    sharedPreferences = await SharedPreferences.getInstance();

    return _sessionHelper;
  }

  String? get(String key) {
    return sharedPreferences.getString(key);
  }

  put(String key, String value) {
    sharedPreferences.setString(key, value);
  }

  clear() {
    sharedPreferences.clear();
  }

  remove(String key) {
    sharedPreferences.remove(key);
  }
}

class ToastMessage {
  static void msg(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        fontSize: 16.0,
        backgroundColor: Color(0xFF6CAFD7),
        textColor: Colors.white);
  }

  static void alertmsg(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
        backgroundColor: AppColor.primaryColor,
        textColor: Colors.black);
  }
}


class HelperClass {
  /*================ progress bar ================*/
  static String _check = '';

  static Widget getProgressBar(BuildContext context, bool _isVisible) {
    return Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: _isVisible,
        child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.only(top: 20),
          child: Center(
            child: SpinKitSpinningLines(
              size: 60.0,
              color: AppColor.primaryColor,
              lineWidth: 3,
            ),
          ),
        ));
  }

  static Widget progressBar(BuildContext context, bool _isVisible) {
    return Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: _isVisible,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // margin: EdgeInsets.only(top: 20),
          color: Colors.black54,
          child: Center(
             // child: Lottie.asset("assets/animation/loader.json",
             //     width: 300, height: 300)
              // SpinKitSpinningLines(size: 60.0, color: AppColor.primaryColor, lineWidth: 3,),
              ),
        ));
  }




  static Widget getProgressBarWhite(BuildContext context, bool _isVisible) {
    return Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: _isVisible,
        child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.only(top: 20),
          child: Center(
              //child: Lottie.asset("assets/animation/loader.json",
                //  width: 300, height: 300)
              // child: Image.asset("assets/images/loader.gif")
              // child: SpinKitSpinningLines(size: 60.0, color: AppColor.primaryColor, lineWidth: 3,),
              ),
        ));
  }

  /*================ check Internet ================*/

  static Future<void> checkInternet(Future<dynamic> callback) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      callback.asStream();
      // callback.call();
    } else {
      ToastMessage.msg(StaticMessages.CHECK_INTERNET);
    }
  }

  static Future<bool> internet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
      // callback.call();
    } else {
      ToastMessage.msg(StaticMessages.CHECK_INTERNET);
      return false;
    }
  }

  /*================ next Focus ================*/

  static void nextFocus(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  /*================ for navigation ================*/

  static Future<void> moveToScreenwithPush(
      BuildContext context, dynamic nextscreen) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => nextscreen));
  }

  static moveToScreenwithPushreplaceemt(
      BuildContext context, dynamic nextscreen) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => nextscreen));
  }

  static moveToScreenwithRoutClear(BuildContext context, nextscreen) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => nextscreen()),
        (Route<dynamic> route) => false);
  }

  static popScreen(BuildContext context) {
    Navigator.pop(context);
  }

/*================ for navigation ================*/
}

class AlertMessage {

  static void showAlert(BuildContext context, String message) {
    print("========helloooooooo=========");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void showShortAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

}








