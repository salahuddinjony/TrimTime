// Model for Feed API response

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

  factory FeedResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    final raw = json['data'];
    List<FeedItem> items = [];
    if (raw is List) {
      items = raw.map((e) => FeedItem.fromJson(e as Map<String, dynamic>?)).toList();
    }

    return FeedResponse(
      success: json['success'] is bool ? json['success'] as bool : false,
      statusCode: json['statusCode'] is int ? json['statusCode'] as int : int.tryParse('${json['statusCode']}') ?? 0,
      message: json['message']?.toString() ?? '',
      data: items,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'statusCode': statusCode,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class FeedItem {
  final String id;
  final String userId;
  final String userName;
  final String? userImage;
  final SaloonOwner? saloonOwner;
  final String caption;
  final List<String> images;
  final int? favoriteCount;
  final bool? isFavorite;

  FeedItem({
    required this.id,
    required this.userId,
    required this.userName,
    this.userImage,
    this.saloonOwner,
    required this.caption,
    required this.images,
    this.favoriteCount,
    this.isFavorite ,

  });

  factory FeedItem.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    final rawImgs = json['images'];
    List<String> imgs = [];
    if (rawImgs is List) imgs = rawImgs.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();

    return FeedItem(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      userImage: json['userImage']?.toString(),
      saloonOwner: json['saloonOwner'] is Map<String, dynamic> ? SaloonOwner.fromJson(json['saloonOwner'] as Map<String, dynamic>?) : null,
      caption: json['caption']?.toString() ?? '',
      images: imgs,
      favoriteCount: json['favoriteCount'] is int ? json['favoriteCount'] as int : int.tryParse('${json['favoriteCount']}'),
      isFavorite: json['isFavorite'] is bool ? json['isFavorite'] as bool : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'userName': userName,
        'userImage': userImage,
        'saloonOwner': saloonOwner?.toJson(),
        'caption': caption,
        'images': images,
        'favoriteCount': favoriteCount,
        'isFavorite': isFavorite,
      };
}

class SaloonOwner {
  final String userId;
  final String shopName;
  final String shopAddress;
  final List<String> shopImages;
  final List<String> shopVideo;
  final String? shopLogo;
  final double? avgRating;
  final int? ratingCount;

  SaloonOwner({
    required this.userId,
    required this.shopName,
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

    final rawVids = json['shopVideo'];
    List<String> vids = [];
    if (rawVids is List) vids = rawVids.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();

    double? avg;
    if (json['avgRating'] is num) {
      avg = (json['avgRating'] as num).toDouble();
    } else if (json['avgRating'] != null) {
      avg = double.tryParse('${json['avgRating']}');
    }

    return SaloonOwner(
      userId: json['userId']?.toString() ?? '',
      shopName: json['shopName']?.toString() ?? '',
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
        'shopAddress': shopAddress,
        'shopImages': shopImages,
        'shopVideo': shopVideo,
        'shopLogo': shopLogo,
        'avgRating': avgRating,
        'ratingCount': ratingCount,
      };
}
