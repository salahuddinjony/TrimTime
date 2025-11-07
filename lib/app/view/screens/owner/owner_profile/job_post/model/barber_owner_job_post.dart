class BarberOwnerJobPost {
  bool? success;
  int? statusCode;
  String? message;
  List<JobPostData>? data;

  BarberOwnerJobPost({this.success, this.statusCode, this.message, this.data});

  BarberOwnerJobPost.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <JobPostData>[];
      json['data'].forEach((v) {
        data!.add(new JobPostData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JobPostData {
  String? id;
  String? userId;
  String? shopName;
  String? shopLogo;
  String? description;
  double? hourlyRate;
  int? salary;
  String? startDate;
  String? endDate;
  String? datePosted;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  JobPostData(
      {this.id,
      this.userId,
      this.shopName,
      this.shopLogo,
      this.description,
      this.hourlyRate,
      this.salary,
      this.startDate,
      this.endDate,
      this.datePosted,
      this.isActive,
      this.createdAt,
      this.updatedAt});

  JobPostData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    shopName = json['shopName'];
    shopLogo = json['shopLogo'];
    description = json['description'];
    hourlyRate = json['hourlyRate'] != null
        ? (json['hourlyRate'] is int
            ? (json['hourlyRate'] as int).toDouble()
            : json['hourlyRate'] as double?)
        : null;
    salary = json['salary'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    datePosted = json['datePosted'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['shopName'] = this.shopName;
    data['shopLogo'] = this.shopLogo;
    data['description'] = this.description;
    data['hourlyRate'] = this.hourlyRate;
    data['salary'] = this.salary;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['datePosted'] = this.datePosted;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
