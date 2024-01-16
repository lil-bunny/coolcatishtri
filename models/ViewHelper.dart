class ViewHelper {
  int? status;
  List<Data>? data;

  ViewHelper({this.status, this.data});

  ViewHelper.fromJson(Map<String, dynamic> json) {
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
  UserDetails? userDetails;

  Data({this.userDetails});

  Data.fromJson(Map<String, dynamic> json) {
    userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  int? id;
  String? firstName;
  String? lastName;
  String? dob;
  String? primaryPhoneNo;
  String? alternatePhoneNo;
  String? address;
  int? pincode;
  String? newProfileImageName;
  String? cityName;

  UserDetails(
      {this.id,
      this.firstName,
      this.lastName,
      this.dob,
      this.primaryPhoneNo,
      this.alternatePhoneNo,
      this.address,
      this.pincode,
      this.newProfileImageName,
      this.cityName});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    dob = json['dob'];
    primaryPhoneNo = json['primary_phone_no'];
    alternatePhoneNo = json['alternate_phone_no'];
    address = json['address'];
    pincode = json['pincode'];
    newProfileImageName = json['new_profile_image_name'];
    cityName = json['cityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['dob'] = this.dob;
    data['primary_phone_no'] = this.primaryPhoneNo;
    data['alternate_phone_no'] = this.alternatePhoneNo;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['new_profile_image_name'] = this.newProfileImageName;
    data['cityName'] = this.cityName;
    return data;
  }
}
