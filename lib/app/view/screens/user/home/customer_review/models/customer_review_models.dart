// Model for the API response
class CustomerReviewResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<CustomerReviewData> data;

  CustomerReviewResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory CustomerReviewResponse.fromJson(Map<String, dynamic> json) {
    return CustomerReviewResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => CustomerReviewData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'statusCode': statusCode,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

// Model for each review data item
class CustomerReviewData {
  final String id;
  final String userId;
  final String bookingId;
  final String barberId;
  final String saloonName;
  final String saloonAddress;
  final String saloonLogo;
  final List<String> saloonImages;
  final List<String> saloonVideo;
  final double latitude;
  final double longitude;
  final int ratingCount;
  final double avgRating;
  bool isFavorite;

  CustomerReviewData({
    required this.id,
    required this.userId,
    required this.bookingId,
    required this.saloonName,
    required this.barberId,
    required this.saloonAddress,
    required this.saloonLogo,
    required this.saloonImages,
    required this.saloonVideo,
    required this.latitude,
    required this.longitude,
    required this.ratingCount,
    required this.avgRating,
    this.isFavorite = false,
  });

  factory CustomerReviewData.fromJson(Map<String, dynamic> json) {
    return CustomerReviewData(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      bookingId: json['bookingId'] ?? '',
      barberId: json['barberId'] ?? '',
      saloonName: json['saloonName'] ?? '',
      saloonAddress: json['saloonAddress'] ?? '',
      saloonLogo: json['saloonLogo'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
      saloonImages: (json['saloonImages'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      saloonVideo: (json['saloonVideo'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      latitude: (json['latitude'] is int)
          ? (json['latitude'] as int).toDouble()
          : (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] is int)
          ? (json['longitude'] as int).toDouble()
          : (json['longitude'] ?? 0.0).toDouble(),
      ratingCount: json['ratingCount'] ?? 0,
      avgRating: (json['avgRating'] is int)
          ? (json['avgRating'] as int).toDouble()
          : (json['avgRating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'bookingId': bookingId,
        'saloonName': saloonName,
        'saloonAddress': saloonAddress,
        'saloonLogo': saloonLogo,
        'saloonImages': saloonImages,
        'saloonVideo': saloonVideo,
        'latitude': latitude,
        'isFavorite': isFavorite,
        'longitude': longitude,
        'ratingCount': ratingCount,
        'avgRating': avgRating,
        'barberId': barberId,
      };
}
