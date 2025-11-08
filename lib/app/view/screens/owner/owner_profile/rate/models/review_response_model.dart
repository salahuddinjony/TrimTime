
// Generated model for review response with null-checks

class ReviewResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<ReviewData> data;

  ReviewResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    final rawData = json['data'];
    List<ReviewData> parsedData = [];
    if (rawData is List) {
      parsedData = rawData
          .map((e) => ReviewData.fromJson(e as Map<String, dynamic>?))
          .toList();
    }

    return ReviewResponse(
      success: json['success'] is bool ? json['success'] as bool : false,
      statusCode: json['statusCode'] is int
          ? json['statusCode'] as int
          : int.tryParse('${json['statusCode']}') ?? 0,
      message: json['message']?.toString() ?? '',
      data: parsedData,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'statusCode': statusCode,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
      };
}


class ReviewData {
  final String id;
  final String customerId;
  final int rating;
  final String comment;
  final String barberId;
  final String saloonOwnerId;
  final String saloonName;
  final String saloonAddress;
  final String saloonLogo;
  final String bookingId;
  final DateTime? createdAt;

  ReviewData({
    required this.id,
    required this.customerId,
    required this.rating,
    required this.comment,
    required this.barberId,
    required this.saloonOwnerId,
    required this.saloonName,
    required this.saloonAddress,
    required this.saloonLogo,
    required this.bookingId,
    required this.createdAt,
  });

  factory ReviewData.fromJson(Map<String, dynamic>? json) {
    json ??= {};

    DateTime? parsedDate;
    try {
      final raw = json['createdAt'];
      if (raw is String && raw.isNotEmpty) {
        parsedDate = DateTime.tryParse(raw);
      } else if (raw is int) {
        parsedDate = DateTime.fromMillisecondsSinceEpoch(raw);
      }
    } catch (_) {
      parsedDate = null;
    }

    return ReviewData(
      id: json['id']?.toString() ?? '',
      customerId: json['customerId']?.toString() ?? '',
      rating: json['rating'] is int
          ? json['rating'] as int
          : int.tryParse('${json['rating']}') ?? 0,
      comment: json['comment']?.toString() ?? '',
      barberId: json['barberId']?.toString() ?? '',
      saloonOwnerId: json['saloonOwnerId']?.toString() ?? '',
      saloonName: json['saloonName']?.toString() ?? '',
      saloonAddress: json['saloonAddress']?.toString() ?? '',
      saloonLogo: json['saloonLogo']?.toString() ?? '',
      bookingId: json['bookingId']?.toString() ?? '',
      createdAt: parsedDate,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerId': customerId,
        'rating': rating,
        'comment': comment,
        'barberId': barberId,
        'saloonOwnerId': saloonOwnerId,
        'saloonName': saloonName,
        'saloonAddress': saloonAddress,
        'saloonLogo': saloonLogo,
        'bookingId': bookingId,
        'createdAt': createdAt?.toIso8601String(),
      };
}
