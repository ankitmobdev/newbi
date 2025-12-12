class PaymentreceivedModel {
  String? result;
  String? message;
  String? italianMessage;
  String? profit;
  List<PaymentReceivedData>? data;

  PaymentreceivedModel({
    this.result,
    this.message,
    this.italianMessage,
    this.profit,
    this.data,
  });

  PaymentreceivedModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    italianMessage = json['italian_message'];
    profit = json['profit'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(PaymentReceivedData.fromJson(v));
      });
    }
  }
}

class PaymentReceivedData {
  String? id;
  String? driverId;
  String? amount;
  String? date;
  String? paid;
  String? createdDate;

  PaymentReceivedData({
    this.id,
    this.driverId,
    this.amount,
    this.date,
    this.paid,
    this.createdDate,
  });

  PaymentReceivedData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driverId = json['driver_id'];
    amount = json['amount'];
    date = json['date'];
    paid = json['paid'];
    createdDate = json['created_date'];
  }
}
