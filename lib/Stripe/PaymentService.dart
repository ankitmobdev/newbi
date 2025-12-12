import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../SharedPreference/AppSession.dart';
import '../constant.dart';
import '../pages/drawerScreen/wallet.dart';
import '../services/api_constants.dart';
import '../services/auth_service.dart';

class PaymentService {

  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() {
    return _instance;
  }
  PaymentService._internal();
  Map<String, dynamic>? paymentIntentData;

  String?totalAmount='';

  // Method to initialize Stripe
  void initializeStripe() {
    Stripe.publishableKey = ApiAction.stripeKey;
  }

  Future<void> makePayment(BuildContext context, String amount, String currency) async {
    try {
      print('payment_0...'+amount);
      totalAmount = amount;
      double amountDouble = double.parse(amount);
      int paymentAmount = (amountDouble * 100).toInt(); // Multiply by 100 and convert to cents
      paymentIntentData = await createPaymentIntent(paymentAmount.toString(), currency);
      print('payment_1...'+paymentIntentData!['client_secret']);
      // 2. Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          merchantDisplayName: 'Portex',
        ),
      );
      // 3. Display the payment sheet
      await displayPaymentSheet(context);
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {
      final url = ApiAction.paymentintent;
      print("STRIPE INTENT URL => $url");
      var request = http.MultipartRequest('POST', Uri.parse(BaseURl.baseUrl + ApiAction.paymentintent));

      request.fields['amount'] = amount;
      request.fields['currency'] = currency;

      var res = await request.send();
      var response = await http.Response.fromStream(res);
      return jsonDecode(response.body);
    } catch (err) {
      throw Exception('Error creating payment intent: $err');
    }
  }

  Future<void> displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      addMoneyToWallet(context);
      paymentIntentData = null; // Reset payment data
    } on StripeException catch (e) {
      _showErrorSnackBar(context, e.error.localizedMessage.toString());
    } catch (e) {
      _showErrorSnackBar(context, e.toString());
    }
  }

  /*Future<void> subscriptionAddApi(BuildContext context) async {
    print("amt_0" + totalAmount.toString());
    //SessionHelper session = await SessionHelper.getInstance(context);
    Map<String, String> data = {
      'app_token': 'booking12345',
      'user_id':SessionHelper().get(SessionHelper.USER_ID).toString(),
      'amount': totalAmount.toString(),
    };

    print("amt_1" + totalAmount.toString());

    if (res.statusCode == 200) {
      var jsonResponse = jsonDecode(res.body);

      print("amt_2" + res.statusCode.toString());
      String message = jsonResponse['message'];
      ToastMessage.msg(message.toString());

      Helper.moveToScreenwithPush(context, WalletWidget());

    } else {
      _showErrorSnackBar(context, "Error: ${res.statusCode}");
    }
  }*/

  Future<void> addMoneyToWallet(BuildContext context) async {
    try {

      final res = await AuthService.addMoneyToWallet(
        user_id: AppSession().userId,
        amount: totalAmount.toString(),
      );

      //Navigator.pop(context); // Close loader

      if (res["result"] == "success") {
        _showErrorSnackBar(context, "Money Added Successfully");
        //amountController.clear();
        //getTransactionHistory();
        Helper.moveToScreenwithPush(context, WalletScreen());
      } else {
        _showErrorSnackBar(context, res["message"] ?? "Failed to add money");
      }
    } catch (e) {
      //Navigator.pop(context);
      _showErrorSnackBar(context, "Error: $e");
    }
  }

  /*void showSnack(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }*/

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text("Error: $message"),
      ),
    );
  }

}