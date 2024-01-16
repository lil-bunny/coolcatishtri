class ScheduleSelect {
  int? status;
  List<Data>? data;

  ScheduleSelect({this.status, this.data});

  ScheduleSelect.fromJson(Map<String, dynamic> json) {
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
  String? scheduleTime;
  int? masterScheduleId;
  bool? isSchedule;
  List<SocityArry>? socityArry;

  ScheduleList(
      {this.scheduleTime,
      this.masterScheduleId,
      this.isSchedule,
      this.socityArry});

  ScheduleList.fromJson(Map<String, dynamic> json) {
    scheduleTime = json['schedule_time'];
    masterScheduleId = json['master_schedule_id'];
    isSchedule = json['isSchedule'];
    if (json['socityArry'] != null) {
      socityArry = <SocityArry>[];
      json['socityArry'].forEach((v) {
        socityArry!.add(new SocityArry.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schedule_time'] = this.scheduleTime;
    data['master_schedule_id'] = this.masterScheduleId;
    data['isSchedule'] = this.isSchedule;
    if (this.socityArry != null) {
      data['socityArry'] = this.socityArry!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SocityArry {
  String? name;
  int? id;
  bool? isSelect;
  List<Towers>? towers;

  SocityArry({this.name, this.id, this.isSelect, this.towers});

  SocityArry.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    isSelect = json['isSelect'];
    if (json['towers'] != null) {
      towers = <Towers>[];
      json['towers'].forEach((v) {
        towers!.add(new Towers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['isSelect'] = this.isSelect;
    if (this.towers != null) {
      data['towers'] = this.towers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Towers {
  int? id;
  String? name;
  bool? isSelect;

  Towers({this.id, this.name, this.isSelect});

  Towers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isSelect = json['isSelect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isSelect'] = this.isSelect;
    return data;
  }
}
