// Model for FavoriteFeed API response

class FavoriteFeedResponse {
  final bool success;
  final int statusCode;
  final String message;
  final FavoriteFeedDataContainer? data;

  FavoriteFeedResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory FavoriteFeedResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return FavoriteFeedResponse(
      success: json['success'] is bool ? json['success'] as bool : false,
      statusCode: json['statusCode'] is int
          ? json['statusCode'] as int
          : int.tryParse('${json['statusCode']}') ?? 0,
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? FavoriteFeedDataContainer.fromJson(json['data'] as Map<String, dynamic>?)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'statusCode': statusCode,
        'message': message,
        'data': data?.toJson(),
      };
}

class FavoriteFeedDataContainer {
  final List<FavoriteFeedItem> data;
  final FavoriteFeedMeta? meta;

  FavoriteFeedDataContainer({required this.data, this.meta});

  factory FavoriteFeedDataContainer.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    final rawList = json['data'];
    List<FavoriteFeedItem> items = [];
    if (rawList is List) {
      items = rawList
          .map((e) => FavoriteFeedItem.fromJson(e as Map<String, dynamic>?))
          .toList();
    }
    return FavoriteFeedDataContainer(
      data: items,
      meta: json['meta'] is Map<String, dynamic>
          ? FavoriteFeedMeta.fromJson(json['meta'] as Map<String, dynamic>?)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data.map((e) => e.toJson()).toList(),
        'meta': meta?.toJson(),
      };
}

class FavoriteFeedItem {
  final String id;
  final String feedId;
  final String caption;
  final List<String> images;
  final String userId;
  final String? profileImage;
  final SaloonOwner? saloonOwner;

  FavoriteFeedItem({
    required this.id,
    required this.feedId,
    required this.caption,
    required this.images,
    required this.userId,
    this.profileImage,
    this.saloonOwner,
  });

  factory FavoriteFeedItem.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    final rawImages = json['images'];
    List<String> imgs = [];
    if (rawImages is List) {
      imgs = rawImages.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
    }

    return FavoriteFeedItem(
      id: json['id']?.toString() ?? '',
      feedId: json['feedId']?.toString() ?? '',
      caption: json['caption']?.toString() ?? '',
      images: imgs,
      userId: json['userId']?.toString() ?? '',
      profileImage: json['profileImage']?.toString(),
      saloonOwner: json['saloonOwner'] is Map<String, dynamic>
          ? SaloonOwner.fromJson(json['saloonOwner'] as Map<String, dynamic>?)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'feedId': feedId,
        'caption': caption,
        'images': images,
        'userId': userId,
        'profileImage': profileImage,
        'saloonOwner': saloonOwner?.toJson(),
      };
}

class SaloonOwner {
  final String userId;
  final String shopName;
  final String registration;
  final String shopAddress;
  final List<String> shopImages;
  final List<String> shopVideo;
  final String? shopLogo;
  final double? avgRating;
  final int? ratingCount;

  SaloonOwner({
    required this.userId,
    required this.shopName,
    required this.registration,
    required this.shopAddress,
    required this.shopImages,
    required this.shopVideo,
    this.shopLogo,
    this.avgRating,
    this.ratingCount,
  });

  factory SaloonOwner.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    final rawImgs = json['shopImages'];
    List<String> imgs = [];
    if (rawImgs is List) imgs = rawImgs.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();

    final rawVideos = json['shopVideo'];
    List<String> vids = [];
    if (rawVideos is List) vids = rawVideos.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();

    double? avg;
    if (json['avgRating'] is num) {
      avg = (json['avgRating'] as num).toDouble();
    } else if (json['avgRating'] != null) {
      avg = double.tryParse('${json['avgRating']}');
    }

    return SaloonOwner(
      userId: json['userId']?.toString() ?? '',
      shopName: json['shopName']?.toString() ?? '',
      registration: json['registration']?.toString() ?? '',
      shopAddress: json['shopAddress']?.toString() ?? '',
      shopImages: imgs,
      shopVideo: vids,
      shopLogo: json['shopLogo']?.toString(),
      avgRating: avg,
      ratingCount: json['ratingCount'] is int ? json['ratingCount'] as int : int.tryParse('${json['ratingCount']}'),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'shopName': shopName,
        'registration': registration,
        'shopAddress': shopAddress,
        'shopImages': shopImages,
        'shopVideo': shopVideo,
        'shopLogo': shopLogo,
        'avgRating': avgRating,
        'ratingCount': ratingCount,
      };
}

class FavoriteFeedMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  FavoriteFeedMeta({required this.page, required this.limit, required this.total, required this.totalPages, required this.hasNextPage, required this.hasPrevPage});

  factory FavoriteFeedMeta.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return FavoriteFeedMeta(
      page: json['page'] is int ? json['page'] as int : int.tryParse('${json['page']}') ?? 0,
      limit: json['limit'] is int ? json['limit'] as int : int.tryParse('${json['limit']}') ?? 0,
      total: json['total'] is int ? json['total'] as int : int.tryParse('${json['total']}') ?? 0,
      totalPages: json['totalPages'] is int ? json['totalPages'] as int : int.tryParse('${json['totalPages']}') ?? 0,
      hasNextPage: json['hasNextPage'] is bool ? json['hasNextPage'] as bool : false,
      hasPrevPage: json['hasPrevPage'] is bool ? json['hasPrevPage'] as bool : false,
    );
  }

  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
        'total': total,
        'totalPages': totalPages,
        'hasNextPage': hasNextPage,
        'hasPrevPage': hasPrevPage,
      };
}
