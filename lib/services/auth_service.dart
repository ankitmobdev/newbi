import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../SharedPreference/AppSession.dart';
import '../models/profilemodel.dart';
import 'api_client.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'api_constants.dart';

class AuthService {

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String deviceToken,
    required String deviceType,
    required String userType,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'email': email,
      'password': password,
      'device_token': deviceToken,
      'device_type': deviceType,
      'user_type': userType,
    });

    print('📤 Sending login request with FormData: $formData');

    final response = await ApiClient.dio.post(
      ApiAction.login,
      data: formData,
    );

    print('📥 Login API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    }
    else if (response.data is String) {
      return jsonDecode(response.data);
    }
    throw Exception('Unexpected response format: ${response.data}');
  }

  static Future<Map<String, dynamic>> driverRegister({
    required String firstname,
    required String lastname,
    required String email,
    required String phone,
    required String password,
    required String deviceToken,
    required String deviceType,
    required String countryCode,
    required String phoneCode,
    required String address,
    required String socialType,
    required String socialId,
    required String licencePlateNo,
    required String vehiclePlateNo,
    required String vehicleType,
    required XFile profileImage,
    required XFile licenceFrontImage,
    required XFile licenceBackImage,

    // Aide fields (optional)
    XFile? aideProfile,
    String? aideName,
    String? aideEmail,
    String? aidePhone,
    String? aidePhoneCode,
    required String helpAideStatus,
  }) async {

    final formData = FormData();

    // 🔵 REQUIRED FIELDS
    formData.fields.addAll([
      MapEntry("code", ApiCode.kcode),
      MapEntry("firstname", firstname),
      MapEntry("lastname", lastname),
      MapEntry("email", email),
      MapEntry("phone", phone),
      MapEntry("password", password),
      MapEntry("device_token", deviceToken),
      MapEntry("device_type", deviceType),
      MapEntry("country_code", countryCode),
      MapEntry("phone_code", phoneCode),
      MapEntry("address", address),
      MapEntry("social_type", socialType),
      MapEntry("social_id", socialId),
      MapEntry("licence_plate_no", licencePlateNo),
      MapEntry("vehicle_plate_no", vehiclePlateNo),
      MapEntry("vehicle_type", vehicleType),
      MapEntry("help_aide_status", helpAideStatus),
    ]);

    // 🔵 REQUIRED IMAGES
    formData.files.add(MapEntry(
      "profile_image",
      await MultipartFile.fromFile(profileImage.path),
    ));

    formData.files.add(MapEntry(
      "licence_front_image",
      await MultipartFile.fromFile(licenceFrontImage.path),
    ));

    formData.files.add(MapEntry(
      "licence_back_image",
      await MultipartFile.fromFile(licenceBackImage.path),
    ));

    // 🔥 ALWAYS SEND THESE FIELDS (backend requires them)
    formData.fields.addAll([
      MapEntry("aide_name", aideName ?? ""),
      MapEntry("aide_email", aideEmail ?? ""),
      MapEntry("aide_phone", aidePhone ?? ""),
      MapEntry("aide_phone_code", aidePhoneCode ?? ""),
    ]);

    // 🔥 OPTIONAL IMAGE (must send empty string if not provided)
    if (aideProfile != null && helpAideStatus == "1") {
      formData.files.add(
        MapEntry(
          "aide_profile",
          await MultipartFile.fromFile(aideProfile.path),
        ),
      );
    } else {
      formData.fields.add(MapEntry("aide_profile", ""));
    }

    print("📤 SENDING DRIVER REGISTRATION →");
    print("FIELDS: ${formData.fields}");
    print("FILES: ${formData.files.map((f) => f.key).toList()}");

    final response = await Dio().post(
      BaseURl.baseUrl + ApiAction.Driver_Registration,
      data: formData,
    );

    print("📥 RESPONSE → ${response.data}");

    if (response.data is Map<String, dynamic>) return response.data;
    if (response.data is String) return jsonDecode(response.data);

    throw Exception("Unexpected API response");
  }

  static Future<Map<String, dynamic>> addMoneyToWallet({
    required String user_id,
    required String amount,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'user_id': user_id,
      'amount': amount,
    });
    print('📤 Sending addMoneyToWallet request with FormData: $formData');
    final response = await ApiClient.dio.post(
      ApiAction.add_money_to_wallet,
      data: formData,
    );
    print('📥 addMoneyToWallet API response: ${response.data}');
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }
  static Future<Map<String, dynamic>> getTransactionHistory({
    required String user_id,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'user_id': user_id,
    });
    print('📤 Sending getTransactionHistory request with FormData: $formData');
    final response = await ApiClient.dio.post(
      ApiAction.transaction_history,
      data: formData,
    );
    print('📥 getTransactionHistory API response: ${response.data}');
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    required String userId,
    required String firstname,
    required String email,
    required String phone,
    required String address,
    required String countryCode,
    required String latitude,
    required String longitude,
    required String licencePlateNo,
    required String vehiclePlateNo,
    required String vehicleType,
    required String helpAideStatus,

    // AIDE fields
    String? aideName,
    String? aideEmail,
    String? aidePhone,
    String? aidePhoneCode,

    // Images
    File? profileImage,
    File? aideProfile,
    File? licenceFront,
    File? licenceBack,
  }) async {
    final formData = FormData.fromMap({
      "code": ApiCode.kcode,
      "user_id": userId,
      "firstname": firstname,
      "email": email,
      "phone": phone,
      "address": address,
      "country_code": countryCode,
      "latitude": latitude,
      "longitude": longitude,
      "licence_plate_no": licencePlateNo,
      "vehicle_plate_no": vehiclePlateNo,
      "vehicle_type": vehicleType,
      "help_aide_status": helpAideStatus,
      "aide_name": aideName ?? "",
      "aide_email": aideEmail ?? "",
      "aide_phone": aidePhone ?? "",
      "aide_phone_code": aidePhoneCode ?? "",
    });

    /// Attach Images If Selected
    if (profileImage != null) {
      formData.files.add(MapEntry(
        "profile_image",
        await MultipartFile.fromFile(profileImage.path),
      ));
    }

    if (aideProfile != null) {
      formData.files.add(MapEntry(
        "aide_profile",
        await MultipartFile.fromFile(aideProfile.path),
      ));
    }

    if (licenceFront != null) {
      formData.files.add(MapEntry(
        "licence_image_front",
        await MultipartFile.fromFile(licenceFront.path),
      ));
    }

    if (licenceBack != null) {
      formData.files.add(MapEntry(
        "licence_image_back",
        await MultipartFile.fromFile(licenceBack.path),
      ));
    }

    print("📤 Sending Edit Profile → $formData");

    final response = await ApiClient.dio.post(
      ApiAction.edit_profile_driver,
      data: formData,
    );

    print("📥 Edit Profile Response → ${response.data}");

    if (response.data is Map<String, dynamic>) return response.data;

    return jsonDecode(response.data);
  }

  static Future<ProfileModel> getProfile(String userId) async {
    final formData = FormData.fromMap({
      "code":ApiCode.kcode,
      "user_id": userId,
    });

    final response = await ApiClient.dio.post(ApiAction.profile, data: formData);

    if (response.data is Map<String, dynamic>) {
      return ProfileModel.fromJson(response.data);
    } else {
      return ProfileModel.fromJson(jsonDecode(response.data));
    }
  }

  static Future<Map<String, dynamic>> logout() async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'userid': AppSession().userId,
    });

    print('📤 Sending logout request with FormData: $formData');

    final response = await ApiClient.dio.post(
      ApiAction.logout,
      data: formData,
    );

    print('📥 same_category_menu_item_list API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> profile({
    required String user_id,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'user_id': user_id,
    });

    print('📤 Sending login request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.profile, data: formData,);

    print('📥 Profile API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> preference({
    required String user_id,
    required String type,
    required String value,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'user_id': user_id,
      'type': type,
      'value': value,
    });

    print('📤 Sending login request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.preference, data: formData,);

    print('📥 preference API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> nearbyDelivery({
    required String user_id,
    required String latitude,
    required String longitude,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'user_id': user_id,
      'latitude': latitude,
      'longitude': longitude,
    });

    print('📤 Sending getNearByDeliveries request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.getNearByDeliveries, data: formData,);

    print('📥 getNearByDeliveries API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> acceptDeliveryRequest({
    required String driver_id,
    required String order_id,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'driver_id': driver_id,
      'order_id': order_id,
    });

    print('📤 Sending acceptDeliveryRequest request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.acceptDeliveryRequest, data: formData,);

    print('📥 acceptDeliveryRequest API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> pickupdelivery({
    required String driver_id,
    required String order_id,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'driver_id': driver_id,
      'order_id': order_id,
    });

    print('📤 Sending acceptDeliveryRequest request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.pickupdelivery, data: formData,);

    print('📥 acceptDeliveryRequest API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> reportProblem({
    required String driver_id,
    required String comment,
    required String message,
    required String order_id,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'driver_id': driver_id,
      'comment': comment,
      'message': message,
      'order_id': order_id,
    });

    print('📤 Sending reportProblem request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.reportProblem, data: formData,);

    print('📥 reportProblem API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }


  static Future<Map<String, dynamic>> payout({
    required String driver_id,
    required String amount,
    required String message,
    required String order_id,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'driver_id': driver_id,
      'amount': amount,
    });

    print('📤 Sending payout request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.payout, data: formData,);

    print('📥 payout API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> payout_total_earning({
    required String driver_id,

  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'driver_id': driver_id,

    });

    print('📤 Sending payout_total_earning request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.payout_total_earning, data: formData,);

    print('📥 payout_total_earning API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> incoming_profit({
    required String driver_id,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'driver_id': driver_id,
    });

    print('📤 Sending incoming_profit request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.incoming_profit, data: formData,);

    print('📥 incoming_profit API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> changePassword({
    required String userid,
    required String old_password,
    required String new_password,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'userid': userid,
      'old_password': old_password,
      'new_password': new_password,
    });

    print('📤 Sending changePassword request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.changePassword, data: formData,);

    print('📥 changePassword API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> needHelp({
    required String name,
    required String email,
    required String phone,
    required String message,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'name': name,
      'email': email,
      'phone': phone,
      'message': message,

    });

    print('📤 Sending needHelp request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.needHelp, data: formData,);

    print('📥 needHelp API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> payment_received({
    required String driver_id,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'driver_id': driver_id,
    });

    print('📤 Sending payment_received request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.payment_received, data: formData,);

    print('📥 payment_received API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> deliverOrder({
    required String order_id,
    required XFile signature_image,
    required XFile client_image,
    required XFile parcel_image1,
    required XFile parcel_image2,
    required XFile parcel_image3
  }) async {
    final formData = FormData();
    formData.fields.addAll([
      MapEntry("code", ApiCode.kcode),
      MapEntry("order_id", order_id),
    ]);

    formData.files.add(MapEntry(
      "signature_image",
      await MultipartFile.fromFile(signature_image.path),
    ));
    formData.files.add(MapEntry(
      "client_image",
      await MultipartFile.fromFile(client_image.path),
    ));
    formData.files.add(MapEntry(
      "parcel_image1",
      await MultipartFile.fromFile(parcel_image1.path),
    ));
    formData.files.add(MapEntry(
      "parcel_image2",
      await MultipartFile.fromFile(parcel_image2.path),
    ));
    formData.files.add(MapEntry(
      "parcel_image3",
      await MultipartFile.fromFile(parcel_image3.path),
    ));

    print("📤 Sending deliverOrder...");
    print("DATA → ${formData.fields}");
    final response = await Dio().post(
      BaseURl.baseUrl + ApiAction.deliverOrder,
      data: formData,
    );
    print("📥 Response → ${response.data}");
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    }
    throw Exception("Unexpected API response");
  }

  static Future<Map<String, dynamic>> cancelDelivery({
    required String user_id,
    required String order_id,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'user_id': user_id,
      'order_id': order_id,
    });

    print('📤 Sending acceptDeliveryRequest request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.cancelDelivery, data: formData,);

    print('📥 cancelDelivery API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> deliveryDetail({
    required String delivery_id,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'delivery_id': delivery_id,
    });

    print('📤 Sending deliveryDetail request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.deliveryDetail, data: formData,);

    print('📥 deliveryDetail API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> notifications({
    required String user_id,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'user_id': user_id,
    });

    print('📤 Sending notifications request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.notifications, data: formData,);

    print('📥 notifications API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }
  static Future<Map<String, dynamic>> get_driver_deliveries({
    required String type,
    required String driver_id,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'driver_id': driver_id,
      'type': type,
    });

    print('📤 Sending get_driver_deliveries request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.get_driver_deliveries, data: formData,);

    print('📥 get_driver_deliveries API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> get_user_deliveries({
    required String type,
    required String user_id,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'user_id': user_id,
      'type': type,
    });

    print('📤 Sending get_user_deliveries request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.get_user_deliveries, data: formData,);

    print('📥 get_user_deliveries API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }
  static Future<Map<String, dynamic>> decline_order_driver({
    required String driver_id,
    required String order_id,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'driver_id': driver_id,
      'order_id': order_id,
    });

    print('📤 Sending decline_order_driver request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.decline_order_driver, data: formData,);

    print('📥 decline_order_driver API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> booking({
    required String userId,
    required String vehicleType,
    required String fromTime,
    required String toTime,
    required String date,
    required String bookingTime,
    required String sellerName,
    required String sellerNumber,
    required String unitOrApartment2,
    required String staircase2,
    required String elevator2,
    required String numberOfStairs2,
    required String storeName,
    required String itemPurchaseBy,
    required String purchaserName,
    required String purchaserNumber,
    required String unitOrApartment,
    required String pickupAddress,
    required String pickupLat,
    required String pickupLong,
    required String dropoffAddress,
    required String dropoffLat,
    required String dropoffLong,
    required String staircase,
    required String numberOfStairs,
    required String elevators,
    required String aideAndDriver,
    required String bookingType,
    required String packageInfoJson, // Kotlin → json
    required String deliveryCost,
    required String adminCost,
    required String driverCost,
    required String driverPlusAideCost,
    //required String stripeAmount,
    //required String stripeToken,
    required String paymentType,
  }) async {
    FormData formData = FormData.fromMap({
      "code": ApiCode.kcode,
      "user_id": userId,
      "vehicle_type": "Car",
      "from_time": fromTime,
      "to_time": toTime,
      "date": date,
      "booking_time": bookingTime,
      "seller_name": sellerName,
      "seller_number": sellerNumber,
      "unit_or_apartment2": unitOrApartment2,
      "staircase2": staircase2,
      "elevator2": elevator2,
      "number_of_stairs2": numberOfStairs2,
      "store_name": storeName,
      "item_purchase_by": itemPurchaseBy,
      "purchaser_name": purchaserName,
      "purchaser_number": purchaserNumber,
      "unit_or_apartment": unitOrApartment,
      "pickupaddress": pickupAddress,
      "pickup_lat": pickupLat,
      "pickup_long": pickupLong,
      "dropoffaddress": dropoffAddress,
      "dropoff_lat": dropoffLat,
      "dropoff_long": dropoffLong,
      "staircase": staircase,
      "number_of_stairs": numberOfStairs,
      "elevators": elevators,
      "aide_and_driver": aideAndDriver,
      "booking_type": bookingType,
      "packageInfo": packageInfoJson,
      "delivery_cost": deliveryCost,
      "admin_cost": adminCost,
      "driver_cost": driverCost,
      "driver_plus_aide_cost": driverPlusAideCost,
      //"stripe_amount": stripeAmount,
      //"stripe_token": stripeToken,
      "payment_type": paymentType,
    });
    print("📤 Booking Request: $formData");
    final response = await ApiClient.dio.post(
      ApiAction.booking,
      data: formData,
    );
    print("📥 Booking API Response: ${response.data}");
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception("Unexpected response format");
    }
  }

  static Future<Map<String, dynamic>> userRegister({
    required String firstname,
    required String lastname,
    required String email,
    required String phone,
    required String password,
    required String deviceToken,
    required String deviceType,
    required String countryCode,
    required String phoneCode,
    required String address,
    required String socialType,
    required String socialId,
    required XFile profileImage,
  }) async {
    final formData = FormData();
    formData.fields.addAll([
      // MapEntry("code", "portax@12345"),
      MapEntry("code", ApiCode.kcode),
      MapEntry("firstname", firstname),
      MapEntry("lastname", lastname),
      MapEntry("email", email),
      MapEntry("phone", phone),
      MapEntry("password", password),
      MapEntry("device_token", deviceToken),
      MapEntry("device_type", deviceType),
      MapEntry("country_code", countryCode),
      MapEntry("phone_code", phoneCode),
      MapEntry("address", address),
      MapEntry("social_type", socialType),
      MapEntry("social_id", socialId),
    ]);
    // Profile Image
    formData.files.add(MapEntry(
      "profile_image",
      await MultipartFile.fromFile(profileImage.path),
    ));

    print("📤 Sending driver registration...");
    print("DATA → ${formData.fields}");
    final response = await Dio().post(
      BaseURl.baseUrl + ApiAction.User_Registration,
      data: formData,
    );
    print("📥 Response → ${response.data}");
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    }
    throw Exception("Unexpected API response");
  }

  static Future<Map<String, dynamic>> updateProfileuser({
    required String userId,
    required String firstname,
    required String lastname,
    required String email,
    required String phone,
    required String address,
    required String countryCode,
    required String latitude,
    required String longitude,
    File? profileImage,
  }) async {
    final formData = FormData.fromMap({
      "code": ApiCode.kcode,
      "user_id": userId,
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      "phone": phone,
      "address": address,
      "country_code": countryCode,
      "latitude": latitude,
      "longitude": longitude,
    });

    print("📦 PROFILE IMAGE RECEIVED IN API METHOD → $profileImage");
    if (profileImage != null) {
      print("📤 ATTACHING IMAGE → ${profileImage.path}");
    } else {
      print("⚠️ NO IMAGE ATTACHED");
    }

    /// Attach Images If Selected
    if (profileImage != null) {
      formData.files.add(MapEntry(
        "profile_image",
        await MultipartFile.fromFile(profileImage.path),
      ));
    }

    print("📤 Sending Edit Profile → $formData");
    final response = await ApiClient.dio.post(
      ApiAction.Edit_Profile_User,
      data: formData,
    );
    print("📥 Edit Profile Response → ${response.data}");
    if (response.data is Map<String, dynamic>) return response.data;
    return jsonDecode(response.data);
  }

  static Future<Map<String, dynamic>> updateprofile({
    required String user_id,
    required String username,
    required String email,
    required String phone,
    required String dob,
    required String gender,
    required String country_code,
    File? profileImageFile, // <-- Add this parameter
    File? licence_front, // <-- Add this parameter
    File? licence_back, // <-- Add this parameter
  }) async {
    MultipartFile? profileMultipart;
    MultipartFile? licence_frontmulti;
    MultipartFile? licence_backmulti;

    if (profileImageFile != null) {
      final fileName = profileImageFile.path.split('/').last;
      profileMultipart = await MultipartFile.fromFile(
        profileImageFile.path,
        filename: fileName,
      );
    }

    if (licence_front != null) {
      final fileName = licence_front.path.split('/').last;
      licence_frontmulti = await MultipartFile.fromFile(
        licence_front.path,
        filename: fileName,
      );
    }
    if (licence_back != null) {
      final fileName = licence_back.path.split('/').last;
      licence_backmulti = await MultipartFile.fromFile(
        licence_back.path,
        filename: fileName,
      );
    }

    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'user_id': user_id,
      'username': username,
      'email': email,
      'phone': phone,
      'dob': dob,
      'gender': gender,
      'country_code': country_code,
      'profile_image': profileMultipart ?? '', // send empty string if null
      'licence_front': licence_frontmulti ?? '', // send empty string if null
      'licence_back': licence_backmulti ?? '', // send empty string if null
    });

    print('📤 Sending update profile request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.edit_profile, data: formData);

    print('📥 Profile API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

}