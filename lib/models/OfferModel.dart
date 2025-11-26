class OfferModel {
  String? result;
  String? message;
  List<Data>? data;

  OfferModel({this.result, this.message, this.data});

  OfferModel.fromJson(Map<String, dynamic> json) {
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
  String? id;
  String? couponName;
  String? couponCode;
  String? startDate;
  String? expiryDate;
  String? percentage;
  String? description;
  String? couponImage;

  Data(
      {this.id,
        this.couponName,
        this.couponCode,
        this.startDate,
        this.expiryDate,
        this.percentage,
        this.description,
        this.couponImage});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    couponName = json['coupon_name'];
    couponCode = json['coupon_code'];
    startDate = json['start_date'];
    expiryDate = json['expiry_date'];
    percentage = json['percentage'];
    description = json['description'];
    couponImage = json['coupon_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['coupon_name'] = this.couponName;
    data['coupon_code'] = this.couponCode;
    data['start_date'] = this.startDate;
    data['expiry_date'] = this.expiryDate;
    data['percentage'] = this.percentage;
    data['description'] = this.description;
    data['coupon_image'] = this.couponImage;
    return data;
  }
}