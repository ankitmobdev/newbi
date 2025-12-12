import 'dart:convert';
//import 'package:fleek_go_user/flutter/flutter_util.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../SharedPreference/AppSession.dart';
import '../constant.dart';
import '../models/Global.dart';
import '../pages/drawerScreen/wallet.dart';
import '../services/api_constants.dart';
import '../services/auth_service.dart';
//import '../pages/Wallet/WalletWidget.dart';

class PaymentServiceBooking {

  static final PaymentServiceBooking _instance = PaymentServiceBooking._internal();
  factory PaymentServiceBooking() {
    return _instance;
  }
  PaymentServiceBooking._internal();
  Map<String, dynamic>? paymentIntentData;

  String?totalAmount='';

  // Method to initialize Stripe
  void initializeStripe() {
    Stripe.publishableKey = ApiAction.stripeKey;
  }

  /*Future<void> makePayment(BuildContext context, String amount, String currency) async {
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
  }*/

  Future<bool> makePayment(BuildContext context, String amount, String currency) async {
    try {
      print('payment_0...'+amount);
      totalAmount = amount;

      double amountDouble = double.parse(amount);
      int paymentAmount = (amountDouble * 100).toInt();

      paymentIntentData = await createPaymentIntent(paymentAmount.toString(), currency);

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          merchantDisplayName: 'Portex',
        ),
      );

      await displayPaymentSheet(context);
      return true;     // <-- SUCCESS
    } catch (e) {
      _showErrorDialog(context, e.toString());
      return false;    // <-- FAILURE
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
      //addMoneyToWallet(context);
      paymentIntentData = null; // Reset payment data
    } on StripeException catch (e) {
      _showErrorSnackBar(context, e.error.localizedMessage.toString());
    } catch (e) {
      _showErrorSnackBar(context, e.toString());
    }
  }

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