class Order {
  int? status;
  List<Data>? data;

  Order({this.status, this.data});

  Order.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? schuduleTime;
  String? scheduleDate;
  int? orderQuantity;
  int? pickupStatus;
  Customer? customer;

  Data(
      {this.id,
      this.schuduleTime,
      this.scheduleDate,
      this.orderQuantity,
      this.pickupStatus,
      this.customer});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    schuduleTime = json['schudule_time'];
    scheduleDate = json['schedule_date'];
    orderQuantity = json['order_quantity'];
    pickupStatus = json['pickup_status'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['schudule_time'] = this.schuduleTime;
    data['schedule_date'] = this.scheduleDate;
    data['order_quantity'] = this.orderQuantity;
    data['pickup_status'] = this.pickupStatus;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    return data;
  }
}

class Customer {
  int? id;
  String? firstName;
  String? lastName;

  Customer({this.id, this.firstName, this.lastName});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    return data;
  }
}
