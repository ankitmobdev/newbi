class DashboardModel {
  String? result;
  String? message;
  Data? data;

  DashboardModel({this.result, this.message, this.data});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['result'] = result;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? totalEarn;
  String? monthlyEarning;
  List<MonthlyEarnings>? monthlyEarnings;
  String? totalOrder;
  String? completeOrder;
  String? cancelOrder;
  String? activeOrder;
  String? totalLoss;
  String? drivername;
  String? driver_profile_image;

  Data({
    this.totalEarn,
    this.monthlyEarning,
    this.monthlyEarnings,
    this.totalOrder,
    this.completeOrder,
    this.cancelOrder,
    this.activeOrder,
    this.totalLoss,
    this.drivername,
    this.driver_profile_image,
  });

  Data.fromJson(Map<String, dynamic> json) {
    totalEarn = json['total_earn'];
    monthlyEarning = json['monthly_earning'];
    if (json['monthly_earnings'] != null) {
      monthlyEarnings = List<MonthlyEarnings>.from(
        json['monthly_earnings'].map((v) => MonthlyEarnings.fromJson(v)),
      );
    }
    totalOrder = json['total_order'];
    completeOrder = json['complete_order'];
    cancelOrder = json['cancel_order'];
    activeOrder = json['active_order'];
    totalLoss = json['total_loss'];
    drivername = json['drivername'];
    driver_profile_image = json['driver_profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['total_earn'] = totalEarn;
    data['monthly_earning'] = monthlyEarning;
    if (monthlyEarnings != null) {
      data['monthly_earnings'] = monthlyEarnings!.map((v) => v.toJson()).toList();
    }
    data['total_order'] = totalOrder;
    data['complete_order'] = completeOrder;
    data['cancel_order'] = cancelOrder;
    data['active_order'] = activeOrder;
    data['total_loss'] = totalLoss;
    data['drivername'] = drivername;
    data['driver_profile_image'] = driver_profile_image;
    return data;
  }
}

class MonthlyEarnings {
  String? month;
  String? earning;

  MonthlyEarnings({this.month, this.earning});

  MonthlyEarnings.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    earning = json['earning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['month'] = month;
    data['earning'] = earning;
    return data;
  }
}
