class ReviewModel {
  final String? result;
  final String? message;
  final String? overallRating;
  final int? totalGivenByUsers;
  final List<Data>? data;

  ReviewModel({
    this.result,
    this.message,
    this.overallRating,
    this.totalGivenByUsers,
    this.data,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      result: json['result'] as String?,
      message: json['message'] as String?,
      overallRating: json['overall_rating'] as String?,
      totalGivenByUsers: json['total_given_by_users'] as int?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => Data.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'overall_rating': overallRating,
      'total_given_by_users': totalGivenByUsers,
      'data': data?.map((v) => v.toJson()).toList(),
    };
  }
}

class Data {
  final String? rate;
  final String? userId;
  final String? username;
  final String? userProfileImage;
  final String? driverId;
  final String? drivername;
  final String? driverProfileImage;
  final String? review;
  final String? source;
  final String? createdAt;

  Data({
    this.rate,
    this.userId,
    this.username,
    this.userProfileImage,
    this.driverId,
    this.drivername,
    this.driverProfileImage,
    this.review,
    this.source,
    this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      rate: json['rate'] as String?,
      userId: json['user_id'] as String?,
      username: json['username'] as String?,
      userProfileImage: json['user_profile_image'] as String?,
      driverId: json['driver_id'] as String?,
      drivername: json['drivername'] as String?,
      driverProfileImage: json['driver_profile_image'] as String?,
      review: json['review'] as String?,
      source: json['source'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'user_id': userId,
      'username': username,
      'user_profile_image': userProfileImage,
      'driver_id': driverId,
      'drivername': drivername,
      'driver_profile_image': driverProfileImage,
      'review': review,
      'source': source,
      'created_at': createdAt,
    };
  }
}
