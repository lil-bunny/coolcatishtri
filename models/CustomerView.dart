class CustomerView {
  int? status;
  List<Data>? data;

  CustomerView({this.status, this.data});

  CustomerView.fromJson(Map<String, dynamic> json) {
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
  List<AccepectedCustomer>? accepectedCustomer;
  List<RejectedCustomer>? rejectedCustomer;

  Data({this.accepectedCustomer, this.rejectedCustomer});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['active_users'] != null) {
      accepectedCustomer = <AccepectedCustomer>[];
      json['active_users'].forEach((v) {
        accepectedCustomer!.add(new AccepectedCustomer.fromJson(v));
      });
    }
    if (json['inactive_users'] != null) {
      rejectedCustomer = <RejectedCustomer>[];
      json['inactive_users'].forEach((v) {
        rejectedCustomer!.add(new RejectedCustomer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accepectedCustomer != null) {
      data['active_users'] =
          this.accepectedCustomer!.map((v) => v.toJson()).toList();
    }
    if (this.rejectedCustomer != null) {
      data['inactive_users'] =
          this.rejectedCustomer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AccepectedCustomer {
  int? id;
  String? firstName;
  String? lastName;
  String? dob;
  String? primaryPhoneNo;
  String? address;
  int? pincode;
  String? cityName;
  String? newProfileImageName;

  AccepectedCustomer(
      {this.id,
      this.firstName,
      this.lastName,
      this.dob,
      this.primaryPhoneNo,
      this.address,
      this.pincode,
      this.cityName,
      this.newProfileImageName});

  AccepectedCustomer.fromJson(Map<String, dynamic> json) {
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

class RejectedCustomer {
  int? id;
  String? firstName;
  String? lastName;
  String? dob;
  String? primaryPhoneNo;
  String? address;
  int? pincode;
  String? cityName;
  String? newProfileImageName;

  RejectedCustomer(
      {this.id,
      this.firstName,
      this.lastName,
      this.dob,
      this.primaryPhoneNo,
      this.address,
      this.pincode,
      this.cityName,
      this.newProfileImageName});

  RejectedCustomer.fromJson(Map<String, dynamic> json) {
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
