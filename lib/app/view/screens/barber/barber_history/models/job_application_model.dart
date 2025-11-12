import 'dart:convert';

class JobApplicationResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<JobApplication> data;
  final Meta meta;

  JobApplicationResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory JobApplicationResponse.fromMap(Map<String, dynamic> map) {
    return JobApplicationResponse(
      success: map['success'] as bool? ?? false,
      statusCode: map['statusCode'] as int? ?? (map['status_code'] as int? ?? 0),
      message: map['message'] as String? ?? '',
      data: map['data'] != null
          ? List<JobApplication>.from((map['data'] as List)
              .map((x) => JobApplication.fromMap(x as Map<String, dynamic>)))
          : <JobApplication>[],
      meta: map['meta'] != null
          ? Meta.fromMap(map['meta'] as Map<String, dynamic>)
          : Meta.empty(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.map((x) => x.toMap()).toList(),
      'meta': meta.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  factory JobApplicationResponse.fromJson(String source) =>
      JobApplicationResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class JobApplication {
  final String id;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Barber barber;
  final JobPost jobPost;

  JobApplication({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.barber,
    required this.jobPost,
  });

  factory JobApplication.fromMap(Map<String, dynamic> map) {
    DateTime? parseDate(Object? value) {
      if (value == null) return null;
      try {
        return DateTime.parse(value as String);
      } catch (_) {
        return null;
      }
    }

    return JobApplication(
      id: map['id'] as String? ?? '',
      status: map['status'] as String? ?? '',
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
      barber: map['barber'] != null
          ? Barber.fromMap(map['barber'] as Map<String, dynamic>)
          : Barber.empty(),
      jobPost: map['jobPost'] != null
          ? JobPost.fromMap(map['jobPost'] as Map<String, dynamic>)
          : JobPost.empty(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'barber': barber.toMap(),
      'jobPost': jobPost.toMap(),
    };
  }
}

class Barber {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? image;

  Barber({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.image,
  });

  factory Barber.fromMap(Map<String, dynamic> map) {
    return Barber(
      id: map['id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? (map['full_name'] as String? ?? ''),
      email: map['email'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? (map['phone_number'] as String? ?? ''),
      image: map['image'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'image': image,
    };
  }

  factory Barber.empty() =>
      Barber(id: '', fullName: '', email: '', phoneNumber: '', image: null);
}

class JobPost {
  final String id;
  final String description;
  final double? hourlyRate;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? datePosted;
  final String shopName;
  final String? shopAddress;
  final double? shopAverageRating;
  final double? saloonOwnerAvgRating;
  final int? saloonOwnerRatingCount;

  JobPost({
    required this.id,
    required this.description,
    required this.hourlyRate,
    required this.startDate,
    required this.endDate,
    required this.datePosted,
    required this.shopName,
    required this.shopAddress,
    required this.shopAverageRating,
    this.saloonOwnerAvgRating,
    this.saloonOwnerRatingCount,
  });

  factory JobPost.fromMap(Map<String, dynamic> map) {
    DateTime? parseDate(Object? value) {
      if (value == null) return null;
      try {
        return DateTime.parse(value as String);
      } catch (_) {
        return null;
      }
    }

    double? toDouble(Object? value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return JobPost(
      id: map['id'] as String? ?? '',
      description: map['description'] as String? ?? '',
      hourlyRate: toDouble(map['hourlyRate']),
      startDate: parseDate(map['startDate']),
      endDate: parseDate(map['endDate']),
      datePosted: parseDate(map['datePosted']),
      shopName: map['shopName'] as String? ?? '',
      shopAverageRating: toDouble(map['shopAverageRating']),
      shopAddress: map['shopAddress'] as String?,
      saloonOwnerAvgRating: toDouble(map['saloonOwnerAvgRating']),
      saloonOwnerRatingCount: map['saloonOwnerRatingCount'] is int ? map['saloonOwnerRatingCount'] as int : int.tryParse(map['saloonOwnerRatingCount']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'hourlyRate': hourlyRate,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'datePosted': datePosted?.toIso8601String(),
      'shopName': shopName,
      'shopAddress': shopAddress,
      'shopAverageRating': shopAverageRating,
      'saloonOwnerAvgRating': saloonOwnerAvgRating,
      'saloonOwnerRatingCount': saloonOwnerRatingCount,
    };
  }

  factory JobPost.empty() => JobPost(
    id: '',
    description: '',
    hourlyRate: null,
    startDate: null,
    endDate: null,
    datePosted: null,
    shopName: '',
    shopAverageRating: null,
    shopAddress: null,
    saloonOwnerAvgRating: null,
    saloonOwnerRatingCount: null);
}

class Meta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory Meta.fromMap(Map<String, dynamic> map) {
    return Meta(
      page: map['page'] as int? ?? 0,
      limit: map['limit'] as int? ?? 0,
      total: map['total'] as int? ?? 0,
      totalPages: map['totalPages'] as int? ?? (map['total_pages'] as int? ?? 0),
      hasNextPage: map['hasNextPage'] as bool? ?? (map['has_next_page'] as bool? ?? false),
      hasPrevPage: map['hasPrevPage'] as bool? ?? (map['has_prev_page'] as bool? ?? false),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
      'hasNextPage': hasNextPage,
      'hasPrevPage': hasPrevPage,
    };
  }

  factory Meta.empty() => Meta(
      page: 0,
      limit: 0,
      total: 0,
      totalPages: 0,
      hasNextPage: false,
      hasPrevPage: false);
}
