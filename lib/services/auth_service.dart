import 'dart:io';
import '../SharedPreference/AppSession.dart';
import 'api_client.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

import 'api_constants.dart';

class AuthService {

  static Future<Map<String, dynamic>> login({
    required String contact,
    required String deviceToken,
    required String deviceType,
    required String user_type, required String country_code,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'phone': contact,
      'device_token': deviceToken,
      'device_type': deviceType,
      'country_code': country_code,
      'user_type': user_type,
    });

    print('📤 Sending login request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.login, data: formData,);
    
    print('📥 Login API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> register({
    required String contact,
    required String username,
    required String deviceToken,
    required String deviceType,
    required String user_type,
    required String country_code,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'phone': contact,
      'device_token': deviceToken,
      'device_type': deviceType,
      'username': username,
      'country_code': country_code,
      'user_type': user_type,
    });

    print('📤 Sending register request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.registration, data: formData,);

    print('📥 Login API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> logout() async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'user_id': AppSession().userId,
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

  static Future<Map<String, dynamic>> menuCategory() async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
    });
    print('📤 Sending menuCategory request with FormData: $formData');
    final response = await ApiClient.dio.post(
      ApiAction.menuCategory,
      data: formData,
    );
    print('📥 menuCategory API response: ${response.data}');
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> instamartCategory() async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
    });
    print('📤 Sending menuCategory request with FormData: $formData');
    final response = await ApiClient.dio.post(
      ApiAction.instamartCategory,
      data: formData,
    );
    print('📥 menuCategory API response: ${response.data}');
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> instamartSubcategory(String categoryName) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'category_name': categoryName,
    });
    print('📤 Sending menuCategory request with FormData: $formData');
    final response = await ApiClient.dio.post(
      ApiAction.instamartSubcategory,
      data: formData,
    );
    print('📥 menuCategory API response: ${response.data}');
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> menuItemList(String categoryName) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'category_name': categoryName,
      'user_id': AppSession().userId,
    });
    print('📤 Sending menuItemList request with category: $categoryName');
    final response = await ApiClient.dio.post(
      ApiAction.menuItemList,
      data: formData,
    );
    print('📥 menuItemList API response: ${response.data}');
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> instamartItemList(String categoryName) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'category_name': categoryName,
      'user_id': AppSession().userId,
    });

    print('📤 Sending menuItemList request with category: $categoryName');

    final response = await ApiClient.dio.post(
      ApiAction.instamartItemList,
      data: formData,
    );

    print('📥 menuItemList API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> ingredientsItem(String categoryName) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'category_name': categoryName,
    });
    print('📤 Sending menuCategory request with FormData: $formData');
    final response = await ApiClient.dio.post(
      ApiAction.ingredientsItem,
      data: formData,
    );
    print('📥 menuCategory API response: ${response.data}');
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> addItem({
    required File? itemImage,
    required String categoryName,
    required String itemName,
    required String itemDescription,
    required String normalPrice,
    required String offerPrice,
    required String gstCharge,
    required String preparationTime,
    required String vegType,
    required String ingredients,
  }) async {

    MultipartFile? profileMultipart;

    if (itemImage != null) {
      final fileName = itemImage.path.split('/').last;
      profileMultipart = await MultipartFile.fromFile(
        itemImage.path,
        filename: fileName,
      );
    }

    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'item_image': profileMultipart ?? '',
      'restaurants_id': AppSession().userId,
      'category_name': categoryName,
      'item_name': itemName,
      'item_description': itemDescription,
      'normal_price': normalPrice,
      'offer_price': offerPrice,
      'gst_charge': gstCharge,
      'prepartion_time': preparationTime,
      'veg_type': vegType,
      'ingredients': ingredients, // important for sending list
    });

    final response = await ApiClient.dio.post(
      ApiAction.addItemAccordingCategory,
      data: formData,
    );

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> updateItem({
    required File? itemImage,
    required String itemId,
    required String categoryName,
    required String itemName,
    required String itemDescription,
    required String normalPrice,
    required String offerPrice,
    required String gstCharge,
    required String preparationTime,
    required String vegType,
    required String ingredients,
  }) async {

    MultipartFile? profileMultipart;

    if (itemImage != null) {
      final fileName = itemImage.path.split('/').last;
      profileMultipart = await MultipartFile.fromFile(
        itemImage.path,
        filename: fileName,
      );
    }

    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'item_image': profileMultipart ?? '',
      'id': itemId,
      'restaurants_id': AppSession().userId,
      'category_name': categoryName,
      'item_name': itemName,
      'item_description': itemDescription,
      'normal_price': normalPrice,
      'offer_price': offerPrice,
      'gst_charge': gstCharge,
      'prepartion_time': preparationTime,
      'veg_type': vegType,
      'ingredients': ingredients, // important for sending list
    });

    final response = await ApiClient.dio.post(
      ApiAction.updateRestaurantProducts,
      data: formData,
    );

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> addInstamart({
    required File? itemImage,
    required String itemName,
    required String normalPrice,
    required String offerPrice,
    required String itemDescription,
    required String category,
    required String subcategory,
    required String color,
    required String ceramic,
    required String variantSize,
    required String variantColor,
    required String variantWeight,
    required String website,
    required String recommended,
  }) async {

    MultipartFile? profileMultipart;

    if (itemImage != null) {
      final fileName = itemImage.path.split('/').last;
      profileMultipart = await MultipartFile.fromFile(
        itemImage.path,
        filename: fileName,
      );
    }

    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'vendor_id': AppSession().userId,
      'product_image': profileMultipart ?? '',
      'category': "Grocery",
      'subcategory': "Hide&Seek",
      'product_name': itemName,
      'product_price': normalPrice,
      'discount_price': offerPrice,
      'product_description': itemDescription,
      'variants': "",
      'website': "",
      'recommended': "",
    });

    final response = await ApiClient.dio.post(
      ApiAction.addInstamartItem,
      data: formData,
    );

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> updateInstamart({
    required File? itemImage,
    required String itemName,
    required String normalPrice,
    required String offerPrice,
    required String itemDescription,
    required String category,
    required String subcategory,
    required String color,
    required String ceramic,
    required String variantSize,
    required String variantColor,
    required String variantWeight,
    required String website,
    required String recommended,
    required String productId,
  }) async {

    MultipartFile? profileMultipart;

    if (itemImage != null) {
      final fileName = itemImage.path.split('/').last;
      profileMultipart = await MultipartFile.fromFile(
        itemImage.path,
        filename: fileName,
      );
    }

    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'vendor_id': AppSession().userId,
      'product_image': profileMultipart ?? '',
      'category': "Grocery",
      'subcategory': "Hide&Seek",
      'product_name': itemName,
      'product_price': normalPrice,
      'discount_price': offerPrice,
      'product_description': itemDescription,
      'variants': "",
      'website': "",
      'recommended': "",
      'id': productId,
    });

    final response = await ApiClient.dio.post(
      ApiAction.updateInstamartProduct,
      data: formData,
    );

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> deleteProduct(String productId) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'id': productId,
    });
    print('📤 Sending menuCategory request with FormData: $formData');
    final response = await ApiClient.dio.post(
      ApiAction.deleteInstamartProduct,
      data: formData,
    );
    print('📥 menuCategory API response: ${response.data}');
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> deleteRestaurantProduct(String productId) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'id': productId,
    });
    print('📤 Sending menuCategory request with FormData: $formData');
    final response = await ApiClient.dio.post(
      ApiAction.deleteRestaurantProduct,
      data: formData,
    );
    print('📥 menuCategory API response: ${response.data}');
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> restaurantOrders(String type) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      //'restaurant_id': AppSession().userId,
      'restaurant_id': '2',
      'type': type,
    });
    print('📤 Sending menuItemList request with category: $type');
    final response = await ApiClient.dio.post(
      ApiAction.restaurantOrders,
      data: formData,
    );
    print('📥 menuItemList API response: ${response.data}');
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
     } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> orderDetail(String order_id) async {

    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'order_id': order_id,
    });
    print('📤 Sending menuItemList request with category: $order_id');
    final response = await ApiClient.dio.post(
      ApiAction.bookingDetail,
      data: formData,
    );
    print('📥 menuItemList API response: ${response.data}');
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> acceptOrder(String orderId) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'order_id': orderId,
    });
    print('📤 Sending menuItemList request with category: $orderId');
    final response = await ApiClient.dio.post(
      ApiAction.acceptOrder,
      data: formData,
    );
    print('📥 menuItemList API response: ${response.data}');
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> rejectOrder(String categoryName) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'order_id': "2",
    });
    print('📤 Sending menuItemList request with category: $categoryName');
    final response = await ApiClient.dio.post(
      ApiAction.rejectOrder,
      data: formData,
    );
    print('📥 menuItemList API response: ${response.data}');
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> restaurantOffers(String categoryName) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
    });
    print('📤 Sending menuItemList request with category: $categoryName');
    final response = await ApiClient.dio.post(
      ApiAction.restaurentOffer,
      data: formData,
    );
    print('📥 menuItemList API response: ${response.data}');
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    required String user_id,
    required String restaurant_id,
    required String name,
    required String phone,
    required String email,
    required String address,
    required String latitude,
    required String longitude,
    File? profileImageFile, // <-- Add this parameter
  }) async {
    MultipartFile? profileMultipart;

    if (profileImageFile != null) {
      final fileName = profileImageFile.path.split('/').last;
      profileMultipart = await MultipartFile.fromFile(
        profileImageFile.path,
        filename: fileName,
      );
    }

    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'user_id': user_id,
      'restaurant_id': restaurant_id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'profile_image': profileMultipart ?? '', // send empty string if null
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

  ///============getNearByDeliveries=============///

  static Future<Map<String, dynamic>> getNearByDeliveries({


    required String driver_id,


  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      "driver_id": driver_id,
      "latitude":"22.7196",
      "longitude":"75.8577"

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
  ///============acceptdriverorder=============///

  static Future<Map<String, dynamic>> driveracceptOrder({


    required String driver_id,
    required String order_id,
    required String source,


  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'driver_id':driver_id,
      "order_id": order_id,
      "source": source,

    });

    print('📤 Sending driveracceptOrder request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.driveracceptOrder, data: formData,);

    print('📥 driveracceptOrder API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }
  ///============driverrejectOrder=============///

  static Future<Map<String, dynamic>> driverrejectOrder({


    required String driver_id,
    required String order_id,
    required String source,


  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'driver_id':driver_id,
      "order_id": order_id,
      "source": source,

    });

    print('📤 Sending driverrejectOrder request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.driverrejectOrder, data: formData,);

    print('📥 driverrejectOrder API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }
  ///============driverpickOrder=============///

  static Future<Map<String, dynamic>> driverpickOrder({


    required String driver_id,
    required String order_id,
    required String source,


  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'driver_id':driver_id,
      'order_id':order_id,
      "source": source,

    });

    print('📤 Sending driverpickOrder request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.driverpickOrder, data: formData,);

    print('📥 driverpickOrder API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  ///============drivercompletetOrder=============///

  static Future<Map<String, dynamic>> drivercompletetOrder({


    required String driver_id,
    required String order_id,
    required String source,


  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'driver_id':driver_id,
      'order_id':order_id,
      "source": source,

    });

    print('📤 Sending drivercompletetOrder request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.drivercompletetOrder, data: formData,);

    print('📥 drivercompletetOrder API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }
  ///============driver_booking_list=============///

  static Future<Map<String, dynamic>> driver_booking_list({


    required String driver_id,
    required String type,


  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'driver_id':driver_id,
      "type": type,

    });

    print('📤 Sending driver_booking_list request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.driver_booking_list, data: formData,);

    print('📥 driver_booking_list API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }
  ///============combinebookingDetail=============///

  static Future<Map<String, dynamic>> combinebookingDetail({


    required String order_id,
    required String source,


  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'order_id':order_id,
      "source": source,

    });

    print('📤 Sending combinebookingDetail request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.combinebookingDetail, data: formData,);

    print('📥 combinebookingDetail API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  ///============filter_driver_booking_list=============///

  static Future<Map<String, dynamic>> filter_driver_booking_list({


    required String driver_id,
    required String type,


  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'driver_id':driver_id,
      "type": type,

    });

    print('📤 Sending filter_driver_booking_list request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.filter_driver_booking_list, data: formData,);

    print('📥 filter_driver_booking_list API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  ///============driver_incoming_profit=============///

  static Future<Map<String, dynamic>> driver_incoming_profit({


    required String driver_id,



  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'driver_id':driver_id,
    });

    print('📤 Sending driver_incoming_profit request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.driver_incoming_profit, data: formData,);

    print('📥 driver_incoming_profit API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  ///============Payout=============///

  static Future<Map<String, dynamic>> Payout({


    required String driver_id,
    required String amount,



  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'driver_id':driver_id,
      'amount':amount,
    });

    print('📤 Sending driver_incoming_profit request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.Payout, data: formData,);

    print('📥 driver_incoming_profit API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  ///============review=============///

  static Future<Map<String, dynamic>> all_reviews({


    required String driver_id,



  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'driver_id':driver_id,
    });

    print('📤 Sending all_reviews request with FormData: $formData');

    final response = await ApiClient.dio.post(ApiAction.all_reviews, data: formData,);

    print('📥 all_reviews API response: ${response.data}');

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }

  static Future<Map<String, dynamic>> dashboardDetail() async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'driver_id':  AppSession().userId,
    });
    final response = await ApiClient.dio.post(
      ApiAction.Driver_dashborad,
      data: formData,
    );
    print('📥 menuItemList API response: ${response.data}');
    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    } else {
      throw Exception('Unexpected response format: ${response.data}');
    }
  }
}