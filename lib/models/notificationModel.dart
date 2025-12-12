class NotificationModel {
  String? result;
  String? message;
  List<Data>? data;

  NotificationModel({this.result, this.message, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? profileImage;
  String? lastname;
  String? firstname;
  String? message;
  String? vehicleType;
  String? deliveryCost;

  Data(
      {this.profileImage,
        this.lastname,
        this.firstname,
        this.message,
        this.vehicleType,
        this.deliveryCost});

  Data.fromJson(Map<String, dynamic> json) {
    profileImage = json['profile_image'];
    lastname = json['lastname'];
    firstname = json['firstname'];
    message = json['message'];
    vehicleType = json['vehicle_type'];
    deliveryCost = json['delivery_cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_image'] = this.profileImage;
    data['lastname'] = this.lastname;
    data['firstname'] = this.firstname;
    data['message'] = this.message;
    data['vehicle_type'] = this.vehicleType;
    data['delivery_cost'] = this.deliveryCost;
    return data;
  }
}
