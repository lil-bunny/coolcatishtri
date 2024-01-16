class Laundry {
  int? status;
  List<Data>? data;

  Laundry({this.status, this.data});

  Laundry.fromJson(Map<String, dynamic> json) {
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
  String? firstName;
  String? lastName;
  String? dob;
  String? primaryPhoneNo;
  String? address;
  int? pincode;
  String? cityName;
  String? newProfileImageName;

  Data(
      {this.id,
      this.firstName,
      this.lastName,
      this.dob,
      this.primaryPhoneNo,
      this.address,
      this.pincode,
      this.cityName,
      this.newProfileImageName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    dob = json['dob'];
    primaryPhoneNo = json['primary_phone_no'];
    address = json['address'];
    pincode = json['pincode'];
    cityName = json['cityName'];
    newProfileImageName = json['new_profile_image_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['dob'] = this.dob;
    data['primary_phone_no'] = this.primaryPhoneNo;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['cityName'] = this.cityName;
    data['new_profile_image_name'] = this.newProfileImageName;
    return data;
  }
}
