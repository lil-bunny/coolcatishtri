class LaundryActive {
  int? status;
  List<Data>? data;

  LaundryActive({this.status, this.data});

  LaundryActive.fromJson(Map<String, dynamic> json) {
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
  List<AccepectedLaundry>? accepectedLaundry;
  List<RejectedLaundry>? rejectedLaundry;

  Data({this.accepectedLaundry, this.rejectedLaundry});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['accepectedLaundry'] != null) {
      accepectedLaundry = <AccepectedLaundry>[];
      json['accepectedLaundry'].forEach((v) {
        accepectedLaundry!.add(new AccepectedLaundry.fromJson(v));
      });
    }
    if (json['rejectedLaundry'] != null) {
      rejectedLaundry = <RejectedLaundry>[];
      json['rejectedLaundry'].forEach((v) {
        rejectedLaundry!.add(new RejectedLaundry.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accepectedLaundry != null) {
      data['accepectedLaundry'] =
          this.accepectedLaundry!.map((v) => v.toJson()).toList();
    }
    if (this.rejectedLaundry != null) {
      data['rejectedLaundry'] =
          this.rejectedLaundry!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AccepectedLaundry {
  int? id;
  String? firstName;
  String? lastName;
  Null? dob;
  String? primaryPhoneNo;
  String? address;
  int? pincode;
  int? status;
  String? cityName;
  String? newProfileImageName;

  AccepectedLaundry(
      {this.id,
      this.firstName,
      this.lastName,
      this.dob,
      this.primaryPhoneNo,
      this.address,
      this.pincode,
      this.status,
      this.cityName,
      this.newProfileImageName});

  AccepectedLaundry.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    dob = json['dob'];
    primaryPhoneNo = json['primary_phone_no'];
    address = json['address'];
    pincode = json['pincode'];
    status = json['status'];
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
    data['status'] = this.status;
    data['cityName'] = this.cityName;
    data['new_profile_image_name'] = this.newProfileImageName;
    return data;
  }
}

class RejectedLaundry {
  int? id;
  String? firstName;
  String? lastName;
  Null? dob;
  String? primaryPhoneNo;
  String? address;
  int? pincode;
  int? status;
  String? cityName;
  String? newProfileImageName;

  RejectedLaundry(
      {this.id,
      this.firstName,
      this.lastName,
      this.dob,
      this.primaryPhoneNo,
      this.address,
      this.pincode,
      this.status,
      this.cityName,
      this.newProfileImageName});

  RejectedLaundry.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    dob = json['dob'];
    primaryPhoneNo = json['primary_phone_no'];
    address = json['address'];
    pincode = json['pincode'];
    status = json['status'];
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
    data['status'] = this.status;
    data['cityName'] = this.cityName;
    data['new_profile_image_name'] = this.newProfileImageName;
    return data;
  }
}
