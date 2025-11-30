import 'package:meta/meta.dart';

class FavouriteShopResponse {
	final bool success;
	final int statusCode;
	final String message;
	final List<FavouriteShopModel> data;
	final Meta meta;

	FavouriteShopResponse({
		required this.success,
		required this.statusCode,
		required this.message,
		required this.data,
		required this.meta,
	});

	factory FavouriteShopResponse.fromJson(Map<String, dynamic> json) {
		return FavouriteShopResponse(
			success: json['success'] ?? false,
			statusCode: json['statusCode'] ?? 0,
			message: json['message'] ?? '',
			data: (json['data'] as List<dynamic>?)?.map((e) => FavouriteShopModel.fromJson(e)).toList() ?? [],
			meta: Meta.fromJson(json['meta'] ?? {}),
		);
	}
}

class FavouriteShopModel {
	final String id;
	final String userId;
	final String shopName;
	final String shopAddress;
	final List<String> shopImages;
	final String shopLogo;
	final List<dynamic> shopVideo;
	final double latitude;
	final double longitude;
	final int ratingCount;
	final double avgRating;

	FavouriteShopModel({
		required this.id,
		required this.userId,
		required this.shopName,
		required this.shopAddress,
		required this.shopImages,
		required this.shopLogo,
		required this.shopVideo,
		required this.latitude,
		required this.longitude,
		required this.ratingCount,
		required this.avgRating,
	});

	factory FavouriteShopModel.fromJson(Map<String, dynamic> json) {
		return FavouriteShopModel(
			id: json['id'] ?? '',
			userId: json['userId'] ?? '',
			shopName: json['shopName'] ?? '',
			shopAddress: json['shopAddress'] ?? '',
			shopImages: (json['shopImages'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
			shopLogo: json['shopLogo'] ?? '',
			shopVideo: json['shopVideo'] ?? [],
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
}

class Meta {
	final int total;
	final int page;
	final int limit;
	final int totalPages;

	Meta({
		required this.total,
		required this.page,
		required this.limit,
		required this.totalPages,
	});

	factory Meta.fromJson(Map<String, dynamic> json) {
		return Meta(
			total: json['total'] ?? 0,
			page: json['page'] ?? 0,
			limit: json['limit'] ?? 0,
			totalPages: json['totalPages'] ?? 0,
		);
	}
}
