// Models for Privacy Policy API response
import 'dart:convert';

class PrivacyResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<PrivacyItem> data;

  PrivacyResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory PrivacyResponse.fromJson(Map<String, dynamic> json) {
    return PrivacyResponse(
      success: json['success'] == true,
      statusCode: json['statusCode'] ?? (json['status'] is int ? json['status'] : 200),
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<PrivacyItem>.from((json['data'] as List).map((e) => PrivacyItem.fromJson(e)))
          : <PrivacyItem>[],
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'statusCode': statusCode,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() => jsonEncode(toJson());
}

class PrivacyItem {
  final String id;
  final String userId;
  final String heading;
  final String content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PrivacyItem({
    required this.id,
    required this.userId,
    required this.heading,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory PrivacyItem.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    return PrivacyItem(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      heading: json['heading'] ?? '',
      content: json['content'] ?? '',
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'heading': heading,
        'content': content,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  @override
  String toString() => toJson().toString();
}
