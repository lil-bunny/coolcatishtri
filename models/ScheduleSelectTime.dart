class ScheduleSelectTime {
  int? status;
  List<Data>? data;

  ScheduleSelectTime({this.status, this.data});

  ScheduleSelectTime.fromJson(Map<String, dynamic> json) {
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
  List<ScheduleList>? scheduleList;

  Data({this.scheduleList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['scheduleList'] != null) {
      scheduleList = <ScheduleList>[];
      json['scheduleList'].forEach((v) {
        scheduleList!.add(new ScheduleList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.scheduleList != null) {
      data['scheduleList'] = this.scheduleList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ScheduleList {
  String? scheduleDate;
  List<ScheduleTime>? scheduleTime;

  ScheduleList({this.scheduleDate, this.scheduleTime});

  ScheduleList.fromJson(Map<String, dynamic> json) {
    scheduleDate = json['schedule_date'];
    if (json['scheduleTime'] != null) {
      scheduleTime = <ScheduleTime>[];
      json['scheduleTime'].forEach((v) {
        scheduleTime!.add(new ScheduleTime.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schedule_date'] = this.scheduleDate;
    if (this.scheduleTime != null) {
      data['scheduleTime'] = this.scheduleTime!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ScheduleTime {
  int? masterScheduleId;

  ScheduleTime({this.masterScheduleId});

  ScheduleTime.fromJson(Map<String, dynamic> json) {
    masterScheduleId = json['master_schedule_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['master_schedule_id'] = this.masterScheduleId;
    return data;
  }
}
