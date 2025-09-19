// Simple models for Terms & Conditions API response
import 'dart:convert';

class TermsResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<TermItem> data;

  TermsResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory TermsResponse.fromJson(Map<String, dynamic> json) {
    return TermsResponse(
      success: json['success'] == true,
      statusCode: json['statusCode'] ?? (json['status'] is int ? json['status'] : 200),
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<TermItem>.from((json['data'] as List).map((e) => TermItem.fromJson(e)))
          : <TermItem>[],
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

class TermItem {
  final String id;
  final String userId;
  final String heading;
  final String content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TermItem({
    required this.id,
    required this.userId,
    required this.heading,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory TermItem.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    return TermItem(
      id: json['_id'] ?? json['id'] ?? json['ID'] ?? '',
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
