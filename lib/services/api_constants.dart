class BaseURl {
  static const String baseUrl = "https://portexglobal.com/portex/index.php/ApiController/";
}

class ApiAction {
  // ---------- AUTH ----------
  static const String Driver_Registration = "Driver_Registration";
  static const String edit_profile_driver = "edit_profile_driver";
  static const String Edit_Profile_User = "Edit_Profile_User";
  static const String User_Registration = "User_Registration";
  static const String profile = "profile";
  static const String login = "login";
  static const String forgetPassword = "forgetPassword";
  static const String getsettings = "getsettings";
  static const String booking = "Booking";
  static const String logout = "logout";
  static const String edit_profile = "Edit_Profile_Driver";
  static const String payout_total_earning = "payout_total_earning";
  static const String payment_received = "payment_received";
  static const String incoming_profit = "incoming_profit";
  static const String changePassword = "changePassword";
  static const String needHelp = "needHelp";
  static const String menuCategory = "category";
  static const String menuSubcategory = "subcategory";
  static const String notifications = "notifications";
  static const googleMapKey = 'AIzaSyAOh01_w1CVjtvSNClDYyYe3aO-JCnNgoQ';
  static const String add_money_to_wallet = "add_money_to_wallet";
  static const String transaction_history = "transaction_history";
  static const String paymentintent = "paymentintent";
  static const stripeKey = 'pk_live_51SZLQn6KBcsATMiQAISaqlRF1QNdXZDrxCpYRFal793Y1RvHoNSi57WdOhskvx6BsRZRl3Bd0BaXYmYgnCOlYq2E001RhcJLCx';

  // ---------- CATEGORY / SERVICES ----------
  static const String getNearByDeliveries = "getNearByDeliveries";
  static const String reportProblem = "reportProblem";
  static const String deliveryDetail = "deliveryDetail";
  static const String get_driver_deliveries = "get_driver_deliveries";
  static const String get_user_deliveries = "get_user_deliveries";
  static const String acceptDeliveryRequest = "acceptDeliveryRequest";
  static const String decline_order_driver = "decline_order_driver";
  static const String preference = "preference";
  static const String pickupdelivery = "pickupdelivery";
  static const String deliverOrder = "deliverOrder";
  static const String cancelDelivery = "cancelDelivery";
  static const String add_provider_service = "add_provider_service";
  static const String getProviderService = "get_provider_service";
  static const String deleteProviderService = "delete_provider_service";

  // ---------- ORDERS ----------
  static const String new_orders = "new_orders";
  static const String driver_onGoing_orders = "driver_onGoing_orders";
  static const String driver_orders = "driver_orders";
  static const String accept_order = "accept_order";
  static const String reject_order = "reject_order";
  static const String completeOrders = "completeOrders";
  static const String acceptParcelOrder = "accept_parcelOrder";
  static const String rejectParcelOrder = "reject_parcelOrder";
  static const String parcelOrders = "parcelOrders";
  static const String driver_orders_orderDetail = "driver_orders_orderDetail";
  static const String update_order_time = "update_order_time";
  static const String add_more_time = "add_more_time";

  // ---------- LOCATION / TRACKING ----------
  static const String update_lat_lon = "update_lat_lon";
  static const String latlon = "latlon";

  // ---------- WALLET / PAYOUT ----------
  static const String payout = "payout";
  static const String withdraw_request_list = "withdraw_request_list";
  static const String getWalletData = "get_wallet_data";
  static const String driver_total_earn = "driver_total_earn";
  static const String provider_revenue = "provider_revenue";
  static const String driver_total_income = "driver_total_income";

  // ---------- DELIVERIES ----------
  static const String driverpickupLocations = "driverpickupLocations";
  static const String getappointments = "getappointments";
  static const String getordersbydriver = "getordersbydriver";

  // ---------- NOTIFICATION ----------
  static const String notification_list = "notification_list";

  // ---------- BANNER ----------
  static const String getBannerData = "get_banner";

  // ---------- TIME HISTORY ----------
  static const String provider_time_history = "provider_time_history";
  static const String vendor_time_history = "vendor_time_history";
}


//add_provider_service
class GetDriverDeliveriesType {
  static const String current = "1";
  static const String history = "2";
}

class ApiCode {
    static const String kcode = "portax@12345";
   // static const String kcode = "Homestask";
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