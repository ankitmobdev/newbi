class ProfileModel {
  String? result;
  String? message;
  ProfileData? data;

  ProfileModel({this.result, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? new ProfileData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ProfileData {
  String? aidePhoneCode;
  String? aideName;
  String? aideEmail;
  String? aideProfile;
  String? aidePhone;
  String? helpAideStatus;
  String? userId;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? address;
  String? userType;
  String? vehicleType;
  String? licencePlateNo;
  String? vehicleRegNo;
  String? profileImage;
  String? licenceImageFront;
  String? licenceImageBack;
  String? emailcheck;
  String? online_status;
  String? notification;
  String? withHelper;
  String? countryCode;
  String? phoneCode;
  String? driverTotalEarning;

  ProfileData(
      {this.aidePhoneCode,
        this.aideName,
        this.aideEmail,
        this.aideProfile,
        this.aidePhone,
        this.helpAideStatus,
        this.userId,
        this.firstname,
        this.lastname,
        this.email,
        this.phone,
        this.address,
        this.userType,
        this.vehicleType,
        this.licencePlateNo,
        this.vehicleRegNo,
        this.profileImage,
        this.licenceImageFront,
        this.licenceImageBack,
        this.emailcheck,
        this.online_status,
        this.notification,
        this.withHelper,
        this.countryCode,
        this.phoneCode,
        this.driverTotalEarning});

  ProfileData.fromJson(Map<String, dynamic> json) {
    aidePhoneCode = json['aide_phone_code'];
    aideName = json['aide_name'];
    aideEmail = json['aide_email'];
    aideProfile = json['aide_profile'];
    aidePhone = json['aide_phone'];
    helpAideStatus = json['help_aide_status'];
    userId = json['user_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    userType = json['user_type'];
    vehicleType = json['vehicle_type'];
    licencePlateNo = json['licence_plate_no'];
    vehicleRegNo = json['vehicle_reg_no'];
    profileImage = json['profile_image'];
    licenceImageFront = json['licence_image_front'];
    licenceImageBack = json['licence_image_back'];
    emailcheck = json['emailcheck'];
    online_status = json['online_status'];
    notification = json['notification'];
    withHelper = json['withHelper'];
    countryCode = json['country_code'];
    phoneCode = json['phone_code'];
    driverTotalEarning = json['driver_total_earning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aide_phone_code'] = this.aidePhoneCode;
    data['aide_name'] = this.aideName;
    data['aide_email'] = this.aideEmail;
    data['aide_profile'] = this.aideProfile;
    data['aide_phone'] = this.aidePhone;
    data['help_aide_status'] = this.helpAideStatus;
    data['user_id'] = this.userId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['user_type'] = this.userType;
    data['vehicle_type'] = this.vehicleType;
    data['licence_plate_no'] = this.licencePlateNo;
    data['vehicle_reg_no'] = this.vehicleRegNo;
    data['profile_image'] = this.profileImage;
    data['licence_image_front'] = this.licenceImageFront;
    data['licence_image_back'] = this.licenceImageBack;
    data['emailcheck'] = this.emailcheck;
    data['online_status'] = this.online_status;
    data['notification'] = this.notification;
    data['withHelper'] = this.withHelper;
    data['country_code'] = this.countryCode;
    data['phone_code'] = this.phoneCode;
    data['driver_total_earning'] = this.driverTotalEarning;
    return data;
  }
}
