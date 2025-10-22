class JobPostResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final List<JobPost>? data;
  final Meta? meta;

  JobPostResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
    this.meta,
  });

  factory JobPostResponse.fromJson(Map<String, dynamic> json) {
    return JobPostResponse(
      success: json['success'] as bool?,
      statusCode: json['statusCode'] as int?,
      message: json['message'] as String?,
      data: (json['data'] as List?)
          ?.map((e) => JobPost.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
      'meta': meta?.toJson(),
    };
  }
}

class JobPost {
  final String? id;
  final String? description;
  final int? salary;
  final bool? isActive;
  final DateTime? datePosted;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? shopName;
  final String? shopLogo;
  final String? saloonOwnerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  JobPost({
    this.id,
    this.description,
    this.salary,
    this.isActive,
    this.datePosted,
    this.startDate,
    this.endDate,
    this.shopName,
    this.shopLogo,
    this.saloonOwnerId,
    this.createdAt,
    this.updatedAt,
  });

  factory JobPost.fromJson(Map<String, dynamic> json) {
    return JobPost(
      id: json['id'] as String?,
      description: json['description'] as String?,
      salary: json['salary'] is int
          ? json['salary']
          : json['salary'] == null
              ? null
              : int.tryParse(json['salary'].toString()),
      isActive: json['isActive'] as bool?,
      datePosted: json['datePosted'] != null
          ? DateTime.tryParse(json['datePosted'])
          : null,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'])
          : null,
      shopName: json['shopName'] as String?,
      shopLogo: json['shopLogo'] as String?,
      saloonOwnerId: json['saloonOwnerId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'salary': salary,
      'isActive': isActive,
      'datePosted': datePosted?.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'shopName': shopName,
      'shopLogo': shopLogo,
      'saloonOwnerId': saloonOwnerId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Meta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPrevPage;

  Meta({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
    this.hasNextPage,
    this.hasPrevPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      total: json['total'] as int?,
      totalPages: json['totalPages'] as int?,
      hasNextPage: json['hasNextPage'] as bool?,
      hasPrevPage: json['hasPrevPage'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
      'hasNextPage': hasNextPage,
      'hasPrevPage': hasPrevPage,
    };
  }
}
