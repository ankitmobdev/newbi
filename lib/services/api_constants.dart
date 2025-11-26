import 'package:flutter/material.dart';

class BaseURl {
  static const String baseUrl = "https://www.apptechmobile.com/apptech/GoEat/ApiController/";
}

class ApiAction {
  static const String login = "login";
  //static const String registration = "providerRegister";
  static const String forgetPassword = "forgetPassword";
  static const String logout = "logout";
  static const String profile = "get_driver_profile";
  //static const String login = "login";
  static const String registration = "Registration";
  //static const String profile = "profile";
  static const String edit_profile = "Edit_Profile_Driver";
  static const String menuCategory = "category";
  static const String menuCategoryItem = "category_menu_item_list";
  static const String addItemAccordingCategory = "add_category_according_item";
  static const String ingredientsItem = "ingredients";
  static const String menuItemList = "category_menu_item_list";
  static const String addInstamartItem = "add_products";
  static const String instamartItemList = "instamart_product_list";
  static const String instamartCategory = "instamart_category";
  static const String instamartSubcategory = "instamart_category_according_subcategory";
  static const String updateInstamartProduct = "update_instamart_products";
  static const String deleteInstamartProduct = "delete_instamart_product";
  static const String updateRestaurantProducts = "Update_restaurent_item";
  static const String deleteRestaurantProduct = "delete_restaurent_item";
  static const String restaurantOrders = "vendor_booking_list";
  static const String bookingDetail = "bookingDetail";
  static const String acceptOrder = "acceptOrder";
  static const String rejectOrder = "rejectOrder";
  static const String restaurentOffer = "restaurent_offer";
  static const String socialLoginURL = "social_login";
  static const String social_registration = "social_registration";
  static const String getnearbydelivery = "getnearbydelivery";
  static const String acceptbooking = "acceptbooking";
  static const String outForService = "outforservice";
  static const String arrivedlocation = "arrivedlocation";
  static const String startTrip = "startTrip";
  static const String cancelBooking = 'cancelBooking';
  static const String booking_detail = 'booking_detail';
  static const String driver_current_delivery = 'driver_current_delivery';
  static const String driver_history_delivery = 'driver_history_delivery';
  static const String payout = 'payout';
  static const String add_provider_service = 'add_provider_service';
  static const String get_provider_serive = 'get_provider_serive';
  static const String editProfile = 'update_driver_profile';
  static const String deliveryDetails = 'deliveryDetails';
  static const String incoming_profit = 'incoming_profit';
  static const String reviewlist = 'reviewlist';
  static const String delete_image = 'delete_image';
  static const String admin_percentage = 'admin_percentage';
  static const String getNearByDeliveries = 'getNearByDeliveries';
  static const String driveracceptOrder = 'driveracceptOrder';
  static const String driverrejectOrder = 'driverrejectOrder';
  static const String driver_booking_list = 'driver_booking_list';
  static const String driverpickOrder = 'driverpickOrder';
  static const String drivercompletetOrder = 'drivercompletetOrder';
  static const String combinebookingDetail = 'combinebookingDetail';
  static const String filter_driver_booking_list = 'filter_driver_booking_list';
  static const String driver_incoming_profit = 'driver_incoming_profit';
  static const String Payout = 'Payout';
  static const String all_reviews = 'all_reviews';
  static const String Driver_dashborad = 'Driver_dashborad';
}

//add_provider_service
class GetDriverDeliveriesType {
  static const String current = "1";
  static const String history = "2";
}

class ApiCode {
  static const String kcode = "Goeat12345";
}

class ApiConstantsKey {
  static const String kbookingId = "booking_id";
  static const String klat = "lat";
  static const String klong = "long";
  static const String kcode = "app_token";
  static const String kemail = "email";
  static const String kuserId = "user_id";
  static const String kdriverId = "driver_id";
  static const String kproviderService = "provider_service";
  static const String kserviceImage = "service_image";
  static const String kuserType = "user_type";
  static const String ktype = "type";
  static const String kusername = "username";
  static const String kcontact = "contact";
  static const String kdeviceToken = "device_token";
  static const String kdeviceType = "device_type";
  static const String kpassword = "password";
  static const String kphone_code = "country_code";
  static const String klicenceNumber = "licence_number";
  static const String kvehicleName = "vehicle_name";
  static const String kvehicleNumber = "vehicle_number";
  static const String kaddress = "address";
  static const String kbankAccountNumber = "bank_account_number";
  static const String klicenceFornt = "license_front_image";
  static const String klicenceBack = "license_back_image";
  static const String kvehicleImage = "vehicle_image";
  static const String kregistrationType = "registration_type";
  static const String kvehicleType = "vehicle_type";
  static const String ksupplier_id = "supplier_id";
  static const String kamount = "amount";
  static const String kuserLong = "user_long";
  static const String kuserLat= "user_lat";
  static const String kprice= "price";
  static const String kdescription= "description";
  static const String kprovider_id= "provider_id";
  static const String ktitle= "service_title";
 
  //static const String kuserType = "userType";

  static const String kvehiclePlateNumber = "vehicle_plate_number";
  static const String kimage = "image";
  static const String kFullName = 'fullname';
  static const String klastName = 'last_name';
}

class LoginCheck {
  static const String kLoggedIn = "login";
  static const String kuserId = "user_id";
  static const String kcurrency = "currency";
  static const String kusername = "username";
  static const String kprofile = "profile";
  static const String ktoken = "token";
}

class DeviceType {
  static const String kdeviceType = "ios";
}

class APIResponse {
  static const String failure = "false";
  static const String success = "success";
}
