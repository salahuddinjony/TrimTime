// GENERATED: simple FAQ models for API response
import 'dart:convert';

class FaqResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<FaqItem> data;

  FaqResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory FaqResponse.fromJson(Map<String, dynamic> json) {
    return FaqResponse(
      success: json['success'] == true,
      statusCode: json['statusCode'] ?? (json['status'] is int ? json['status'] : 200),
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<FaqItem>.from((json['data'] as List).map((e) => FaqItem.fromJson(e)))
          : <FaqItem>[],
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

class FaqItem {
  final String id;
  final String userId;
  final String question;
  final String answer;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FaqItem({
    required this.id,
    required this.userId,
    required this.question,
    required this.answer,
    this.createdAt,
    this.updatedAt,
  });

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    return FaqItem(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'question': question,
        'answer': answer,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  @override
  String toString() => toJson().toString();
}
