class LoginModel {
  String? result;
  String? error;
  String? message;
  Data? data;

  LoginModel({this.result, this.error, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? userId;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? address;
  String? userType;
  String? vehicleType;
  String? profileImage;
  String? deviceToken;
  String? licenceImageFront;
  String? licenceImageBack;
  String? vehicleRegNo;
  String? licencePlateNo;
  String? socialType;
  String? socialId;
  String? latitude;
  String? longitude;
  String? deviceType;
  String? emailcheck;
  String? notification;
  String? withHelper;
  String? countryCode;
  String? phoneCode;
  String? aideName;
  String? aideEmail;
  String? aideProfile;
  String? aidePhone;
  String? helpAideStatus;
  String? aidePhoneCode;

  Data(
      {this.userId,
        this.firstname,
        this.lastname,
        this.email,
        this.phone,
        this.address,
        this.userType,
        this.vehicleType,
        this.profileImage,
        this.deviceToken,
        this.licenceImageFront,
        this.licenceImageBack,
        this.vehicleRegNo,
        this.licencePlateNo,
        this.socialType,
        this.socialId,
        this.latitude,
        this.longitude,
        this.deviceType,
        this.emailcheck,
        this.notification,
        this.withHelper,
        this.countryCode,
        this.phoneCode,
        this.aideName,
        this.aideEmail,
        this.aideProfile,
        this.aidePhone,
        this.helpAideStatus,
        this.aidePhoneCode});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    userType = json['user_type'];
    vehicleType = json['vehicle_type'];
    profileImage = json['profile_image'];
    deviceToken = json['device_token'];
    licenceImageFront = json['licence_image_front'];
    licenceImageBack = json['licence_image_back'];
    vehicleRegNo = json['vehicle_reg_no'];
    licencePlateNo = json['licence_plate_no'];
    socialType = json['social_type'];
    socialId = json['social_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    deviceType = json['device_type'];
    emailcheck = json['emailcheck'];
    notification = json['notification'];
    withHelper = json['withHelper'];
    countryCode = json['country_code'];
    phoneCode = json['phone_code'];
    aideName = json['aide_name'];
    aideEmail = json['aide_email'];
    aideProfile = json['aide_profile'];
    aidePhone = json['aide_phone'];
    helpAideStatus = json['help_aide_status'];
    aidePhoneCode = json['aide_phone_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['user_type'] = this.userType;
    data['vehicle_type'] = this.vehicleType;
    data['profile_image'] = this.profileImage;
    data['device_token'] = this.deviceToken;
    data['licence_image_front'] = this.licenceImageFront;
    data['licence_image_back'] = this.licenceImageBack;
    data['vehicle_reg_no'] = this.vehicleRegNo;
    data['licence_plate_no'] = this.licencePlateNo;
    data['social_type'] = this.socialType;
    data['social_id'] = this.socialId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['device_type'] = this.deviceType;
    data['emailcheck'] = this.emailcheck;
    data['notification'] = this.notification;
    data['withHelper'] = this.withHelper;
    data['country_code'] = this.countryCode;
    data['phone_code'] = this.phoneCode;
    data['aide_name'] = this.aideName;
    data['aide_email'] = this.aideEmail;
    data['aide_profile'] = this.aideProfile;
    data['aide_phone'] = this.aidePhone;
    data['help_aide_status'] = this.helpAideStatus;
    data['aide_phone_code'] = this.aidePhoneCode;
    return data;
  }
}
