class CustomerDetails {
  int? status;
  Data? data;

  CustomerDetails({this.status, this.data});

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
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
  String? alternatePhoneNo;
  String? address;
  int? pincode;
  String? newProfileImageName;
  String? street;
  dynamic? activeOrderId;
  int? pendingAmount;

  Data(
      {this.id,
      this.firstName,
      this.lastName,
      this.dob,
      this.primaryPhoneNo,
      this.alternatePhoneNo,
      this.address,
      this.pincode,
      this.newProfileImageName,
      this.street,
      this.activeOrderId,
      this.pendingAmount});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    dob = json['dob'];
    primaryPhoneNo = json['primary_phone_no'];
    alternatePhoneNo = json['alternate_phone_no'] ?? '';
    address = json['address'];
    pincode = json['pincode'];
    newProfileImageName = json['new_profile_image_name'];
    street = json['street'];
    activeOrderId = json['active_order_id'];
    pendingAmount = json['pending_amount'];
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
    data['street'] = this.street;
    data['active_order_id'] = this.activeOrderId;
    data['pending_amount'] = this.pendingAmount;
    return data;
  }
}
