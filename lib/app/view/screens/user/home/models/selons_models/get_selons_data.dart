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
	final String userId;
	final String shopName;
	final String shopAddress;
	final List<String> shopImages;
	final String shopLogo;
	final List<String> shopVideo;
	final String phoneNumber;
	final String email;
	final double latitude;
	final double longitude;
	final num distance;
	final double avgRating;
	final int ratingCount;
	final bool isOpen;
	final String shopStatus;
	final String statusReason;
	final TodayWorkingHours? todayWorkingHours;
	final int totalQueueCount;
	final List<String> availableBarbers;
	final int totalAvailableBarbers;
	bool isFavorite;

	Saloon({
		required this.userId,
		required this.shopName,
		required this.shopAddress,
		required this.shopImages,
		required this.shopLogo,
		required this.shopVideo,
		required this.phoneNumber,
		required this.email,
		required this.latitude,
		required this.longitude,
		required this.distance,
		required this.avgRating,
		required this.ratingCount,
		required this.isOpen,
		required this.shopStatus,
		required this.statusReason,
		this.todayWorkingHours,
		required this.totalQueueCount,
		required this.availableBarbers,
		required this.totalAvailableBarbers,
		this.isFavorite = false,
	});

	factory Saloon.fromJson(Map<String, dynamic> json) {
		return Saloon(
			userId: json['userId'] ?? '',
			shopName: json['shopName'] ?? '',
			shopAddress: json['shopAddress'] ?? '',
			shopImages: (json['shopImages'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
			shopLogo: json['shopLogo'] ?? '',
			shopVideo: (json['shopVideo'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
			phoneNumber: json['phoneNumber'] ?? '',
			email: json['email'] ?? '',
			latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
			longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
			distance: json['distance'] ?? 0,
			avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
			ratingCount: json['ratingCount'] ?? 0,
			isOpen: json['isOpen'] ?? false,
			shopStatus: json['shopStatus'] ?? '',
			statusReason: json['statusReason'] ?? '',
			todayWorkingHours: json['todayWorkingHours'] != null 
				? TodayWorkingHours.fromJson(json['todayWorkingHours'])
				: null,
			totalQueueCount: json['totalQueueCount'] ?? 0,
			availableBarbers: (json['availableBarbers'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
			totalAvailableBarbers: json['totalAvailableBarbers'] ?? 0,
			isFavorite: json['isFavorite'] ?? false,
		);
	}
}

class TodayWorkingHours {
	final String? openingTime;
	final String? closingTime;

	TodayWorkingHours({
		this.openingTime,
		this.closingTime,
	});

	factory TodayWorkingHours.fromJson(Map<String, dynamic> json) {
		return TodayWorkingHours(
			openingTime: json['openingTime'],
			closingTime: json['closingTime'],
		);
	}
}

class Meta {
	final int total;
	final int page;
	final int limit;
	final int totalPages;
	final bool hasNextPage;
	final bool hasPrevPage;

	Meta({
		required this.total,
		required this.page,
		required this.limit,
		required this.totalPages,
		required this.hasNextPage,
		required this.hasPrevPage,
	});

	factory Meta.fromJson(Map<String, dynamic> json) {
		return Meta(
			total: json['total'] ?? 0,
			page: json['page'] ?? 1,
			limit: json['limit'] ?? 10,
			totalPages: json['totalPages'] ?? 0,
			hasNextPage: json['hasNextPage'] ?? false,
			hasPrevPage: json['hasPrevPage'] ?? false,
		);
	}
}
