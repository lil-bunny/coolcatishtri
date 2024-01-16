class DBdetails {
  int? status;
  List<Data>? data;

  DBdetails({this.status, this.data});

  DBdetails.fromJson(Map<String, dynamic> json) {
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
  DbDetails? dbDetails;

  Data({this.dbDetails});

  Data.fromJson(Map<String, dynamic> json) {
    dbDetails = json['dbDetails'] != null
        ? new DbDetails.fromJson(json['dbDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dbDetails != null) {
      data['dbDetails'] = this.dbDetails!.toJson();
    }
    return data;
  }
}

class DbDetails {
  int? dbId;
  String? firstName;
  String? lastName;
  String? email;
  String? dob;
  String? primaryPhoneNo;
  String? address;
  String? city;
  int? cityId;
  int? pincode;
  String? newProfileImageName;
  double? rating;
  int? serviceRate;

  DbDetails(
      {this.dbId,
      this.firstName,
      this.lastName,
      this.email,
      this.dob,
      this.primaryPhoneNo,
      this.address,
      this.city,
      this.cityId,
      this.pincode,
      this.newProfileImageName,
      this.rating,
      this.serviceRate});

  DbDetails.fromJson(Map<String, dynamic> json) {
    dbId = json['db_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    dob = json['dob'];
    primaryPhoneNo = json['primary_phone_no'];
    address = json['address'];
    city = json['city'];
    cityId = json['city_id'];
    pincode = json['pincode'];
    newProfileImageName = json['new_profile_image_name'];
    rating = json['rating'];
    serviceRate = json['serviceRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['db_id'] = this.dbId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['dob'] = this.dob;
    data['primary_phone_no'] = this.primaryPhoneNo;
    data['address'] = this.address;
    data['city'] = this.city;
    data['city_id'] = this.cityId;
    data['pincode'] = this.pincode;
    data['new_profile_image_name'] = this.newProfileImageName;
    data['rating'] = this.rating;
    data['serviceRate'] = this.serviceRate;
    return data;
  }
}
