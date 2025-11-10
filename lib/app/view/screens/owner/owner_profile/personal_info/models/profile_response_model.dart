// GENERATED: Profile response models
import 'dart:convert';

class ProfileResponse {
  final bool success;
  final int statusCode;
  final String message;
  final ProfileData? data;

  ProfileResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProfileResponse(success: false, statusCode: 0, message: '', data: null);
    return ProfileResponse(
      success: json['success'] == true,
      statusCode: json['statusCode'] ?? (json['status'] is int ? json['status'] : 0),
      message: json['message'] ?? '',
      data: json['data'] != null ? ProfileData.fromJson(json['data'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'statusCode': statusCode,
        'message': message,
        'data': data?.toJson(),
      };

  @override
  String toString() => jsonEncode(toJson());
}

class ProfileData {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final DateTime? dateOfBirth;
  final String? phoneNumber;
  final String? address;
  final int followerCount;
  final int followingCount;
  final String? image;
  final String gender;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProfileData( {
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.gender,
    this.dateOfBirth,
    this.phoneNumber,
    this.address,
    required this.followerCount,
    required this.followingCount,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileData.fromJson(Map<String, dynamic>? json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      // If it's already a DateTime, return as-is
      if (v is DateTime) return v;

      final s = v.toString();

      // Try ISO parse first
      try {
        return DateTime.parse(s);
      } catch (_) {}

      // Try common dd/MM/yyyy format (e.g. 23/09/2002)
      final dmY = RegExp(r"^(\d{1,2})\/(\d{1,2})\/(\d{4})$");
      final m = dmY.firstMatch(s);
      if (m != null) {
        try {
          final day = int.parse(m.group(1)!);
          final month = int.parse(m.group(2)!);
          final year = int.parse(m.group(3)!);
          return DateTime(year, month, day);
        } catch (_) {
          return null;
        }
      }

      // Try parsing as milliseconds / seconds number
      try {
        final numVal = int.tryParse(s);
        if (numVal != null) {
          // Heuristic: if value is >= 1e12 treat as millis, else as seconds
          if (numVal >= 1000000000000) {
            return DateTime.fromMillisecondsSinceEpoch(numVal);
          } else if (numVal >= 1000000000) {
            return DateTime.fromMillisecondsSinceEpoch(numVal * 1000);
          }
        }
      } catch (_) {}

      return null;
    }

    if (json == null) return ProfileData(
      id: '',
      gender: '',
      fullName: '',
      email: '',
      role: '',
      dateOfBirth: null,
      phoneNumber: null,
      address: null,
      followerCount: 0,
      followingCount: 0,
      image: null,
      createdAt: null,
      updatedAt: null,
    );

    return ProfileData(
      id: json['_id'] ?? json['id'] ?? '',
      fullName: json['fullName'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      role: json['role'] ?? '',
      dateOfBirth: parseDate(json['dateOfBirth']),
      phoneNumber: json['phoneNumber'] != null ? json['phoneNumber'].toString() : null,
      address: json['address'] != null ? json['address'].toString() : null,
      followerCount: json['followerCount'] is int ? json['followerCount'] : int.tryParse('${json['followerCount'] ?? 0}') ?? 0,
      followingCount: json['followingCount'] is int ? json['followingCount'] : int.tryParse('${json['followingCount'] ?? 0}') ?? 0,
      image: json['image'] != null ? json['image'].toString() : null,
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  get isEmpty => null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'role': role,
        'gender': gender,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'phoneNumber': phoneNumber,
        'address': address,
        'followerCount': followerCount,
        'followingCount': followingCount,
        'image': image,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  @override
  String toString() => toJson().toString();
}
