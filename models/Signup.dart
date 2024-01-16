class Registration {
  int? status;
  List<Data>? data;

  Registration({this.status, this.data});

  Registration.fromJson(Map<String, dynamic> json) {
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
  String? firstName;
  String? lastName;
  String? dob;
  String? primaryPhoneNo;
  String? address;
  String? city;
  String? pincode;
  String? messages;

  Data(
      {this.firstName,
      this.lastName,
      this.dob,
      this.primaryPhoneNo,
      this.address,
      this.city,
      this.pincode,
      this.messages});

  Data.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    dob = json['dob'];
    primaryPhoneNo = json['primary_phone_no'];
    address = json['address'];
    city = json['city'];
    pincode = json['pincode'];
    messages = json['messages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['dob'] = this.dob;
    data['primary_phone_no'] = this.primaryPhoneNo;
    data['address'] = this.address;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['messages'] = this.messages;
    return data;
  }
}
