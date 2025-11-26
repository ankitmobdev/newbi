class UserModel {
  final String email;
  final String countryCode;
  final String customerId;
  final String userId;
  final String username;
  final String name;
  final String phone;
  final String profile_image;
  final String licence_front;
  final String licence_back;
  final String contact;
  final String deviceType;
  final String address;
  final String latitude;
  final String longitude;
  final String gender;

  UserModel({
    required this.email,
    required this.countryCode,
    required this.customerId,
    required this.userId,
    required this.username,
    required this.name,
    required this.phone,
    required this.profile_image,
    required this.licence_front,
    required this.licence_back,
    required this.contact,
    required this.deviceType,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      countryCode: json['country_code'] ?? '',
      customerId: json['customerId'] ?? '',
      licence_front: json['licence_front'] ?? '',
      licence_back: json['licence_back'] ?? '',
      userId: json['user_id'] ?? '',
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      profile_image: json['profile_image'] ?? '',
      contact: json['phone'] ?? '',
      deviceType: json['device_type'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      gender: json['gender'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'country_code': countryCode,
      'customerId': customerId,
      'user_id': userId,
      'username': username,
      'licence_back': licence_back,
      'licence_front': licence_front,
      'name': name,
      'phone': phone,
      'profile_image': profile_image,
      'contact': contact,
      'device_type': deviceType,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'gender': gender,
    };
  }
}