class FeedResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<FeedItem> data;

  FeedResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory FeedResponse.fromJson(Map<String, dynamic> json) {
    return FeedResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => FeedItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class FeedItem {
  final String id;
  final String userId;
  final String userName;
  final String? userImage;
  final String caption;
  final List<String> images;
  final int favoriteCount;
  final SaloonOwner? saloonOwner;

  FeedItem({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.caption,
    required this.images,
    required this.favoriteCount,
    required this.saloonOwner,
  });

  factory FeedItem.fromJson(Map<String, dynamic> json) {
    return FeedItem(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userImage: json['userImage'],
      caption: json['caption'] ?? '',
      images: (json['images'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      favoriteCount: json['favoriteCount'] ?? 0,
      saloonOwner: json['saloonOwner'] != null ? SaloonOwner.fromJson(json['saloonOwner']) : null,
    );
  }
}

class SaloonOwner {
  final String userId;
  final String shopName;
  final String registration;
  final String shopAddress;
  final List<String> shopImages;
  final List<String> shopVideo;
  final String shopLogo;
  final double avgRating;
  final int ratingCount;

  SaloonOwner({
    required this.userId,
    required this.shopName,
    required this.registration,
    required this.shopAddress,
    required this.shopImages,
    required this.shopVideo,
    required this.shopLogo,
    required this.avgRating,
    required this.ratingCount,
  });

  factory SaloonOwner.fromJson(Map<String, dynamic> json) {
    return SaloonOwner(
      userId: json['userId'] ?? '',
      shopName: json['shopName'] ?? '',
      registration: json['registration'] ?? '',
      shopAddress: json['shopAddress'] ?? '',
      shopImages: (json['shopImages'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      shopVideo: (json['shopVideo'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      shopLogo: json['shopLogo'] ?? '',
      avgRating: (json['avgRating'] is int)
          ? (json['avgRating'] as int).toDouble()
          : (json['avgRating'] ?? 0.0),
      ratingCount: json['ratingCount'] ?? 0,
    );
  }
}
