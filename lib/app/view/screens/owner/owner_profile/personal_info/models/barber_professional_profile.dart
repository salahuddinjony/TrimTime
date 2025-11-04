class BarberProfileResponse {
  final bool success;
  final int statusCode;
  final String message;
  final BarberProfile data;

  BarberProfileResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory BarberProfileResponse.fromJson(Map<String, dynamic> json) {
    return BarberProfileResponse(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: BarberProfile.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'statusCode': statusCode,
        'message': message,
        'data': data.toJson(),
      };
}

class BarberProfile {
  final String id;
  final String userId;
  final String saloonOwnerId;
  final String? currentWorkDes;
  final String? bio;
  final List<String> portfolio;
  final bool isAvailable;
  final String? experienceYears;
  final List<String> skills;
  final int followerCount;
  final int followingCount;
  final int ratingCount;
  final double avgRating;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final BarberUser? user;
  final bool isFollowing;

  BarberProfile({
    required this.id,
    required this.userId,
    required this.saloonOwnerId,
    this.currentWorkDes,
    this.bio,
    required this.portfolio,
    required this.isAvailable,
    this.experienceYears,
    required this.skills,
    required this.followerCount,
    required this.followingCount,
    required this.ratingCount,
    required this.avgRating,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.isFollowing = false,
  });

  factory BarberProfile.fromJson(Map<String, dynamic> json) {
    return BarberProfile(
      id: json['id'] as String,
      userId: json['userId'] as String,
      saloonOwnerId: json['saloonOwnerId'] as String,
      currentWorkDes: json['currentWorkDes'] as String?,
      bio: json['bio'] as String?,
      portfolio: (json['portfolio'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          <String>[],
      isAvailable: json['isAvailable'] as bool? ?? false,
      experienceYears: json['experienceYears'] as String?,
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          <String>[],
      followerCount: (json['followerCount'] as num?)?.toInt() ?? 0,
      followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      user: json['user'] != null
          ? BarberUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      isFollowing: json['isFollowing'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'saloonOwnerId': saloonOwnerId,
        'currentWorkDes': currentWorkDes,
        'bio': bio,
        'portfolio': portfolio,
        'isAvailable': isAvailable,
        'experienceYears': experienceYears,
        'skills': skills,
        'followerCount': followerCount,
        'followingCount': followingCount,
        'ratingCount': ratingCount,
        'avgRating': avgRating,
        'createdAt': createdAt?.toUtc().toIso8601String(),
        'updatedAt': updatedAt?.toUtc().toIso8601String(),
        'user': user?.toJson(),
        'isFollowing': isFollowing,
      };
}

class BarberUser {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? image;

  BarberUser({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.image,
  });

  factory BarberUser.fromJson(Map<String, dynamic> json) {
    return BarberUser(
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'image': image,
      };
}