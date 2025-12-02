class GetSelonsDataResponse {
	final bool success;
	final int statusCode;
	final String message;
	final List<Saloon> data;
	final Meta meta;

	GetSelonsDataResponse({
		required this.success,
		required this.statusCode,
		required this.message,
		required this.data,
		required this.meta,
	});

	factory GetSelonsDataResponse.fromJson(Map<String, dynamic> json) {
		return GetSelonsDataResponse(
			success: json['success'] ?? false,
			statusCode: json['statusCode'] ?? 0,
			message: json['message'] ?? '',
			data: (json['data'] as List<dynamic>? ?? [])
					.map((e) => Saloon.fromJson(e as Map<String, dynamic>))
					.toList(),
			meta: Meta.fromJson(json['meta'] ?? {}),
		);
	}
}

class Saloon {
	final String id;
	final String userId;
	final String shopName;
	final String shopAddress;
	final List<String> shopImages;
	final bool isVerified;
	final String shopLogo;
	final List<String> shopVideo;
	final double latitude;
	final double longitude;
	final int ratingCount;
	final double avgRating;
	final num distance;
	final int queue;
  bool isFavorite;

	Saloon({
		required this.id,
		required this.userId,
		required this.shopName,
		required this.shopAddress,
		required this.shopImages,
		required this.isVerified,
		required this.shopLogo,
		required this.shopVideo,
		required this.latitude,
		required this.longitude,
		required this.ratingCount,
		required this.avgRating,
		required this.distance,
		required this.queue,
    this.isFavorite = false,
	});

	factory Saloon.fromJson(Map<String, dynamic> json) {
		return Saloon(
			id: json['id'] ?? '',
			userId: json['userId'] ?? '',
			shopName: json['shopName'] ?? '',
			shopAddress: json['shopAddress'] ?? '',
			shopImages: (json['shopImages'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
			isVerified: json['isVerified'] ?? false,
			shopLogo: json['shopLogo'] ?? '',
			shopVideo: (json['shopVideo'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
			latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
			longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
			ratingCount: json['ratingCount'] ?? 0,
			avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
			distance: json['distance'] ?? 0,
			queue: json['queue'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
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
