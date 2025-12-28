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
	final String shopId;
	final String saloonOwnerId;
	final String userId; // Keep for backward compatibility, defaults to saloonOwnerId
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
	final String? statusReason;
	final TodayWorkingHours? todayWorkingHours;
	final int totalQueueCount;
	final List<AvailableBarber> availableBarbers;
	final int totalAvailableBarbers;
	bool isFavorite;

	Saloon({
		required this.shopId,
		required this.saloonOwnerId,
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
		this.statusReason,
		this.todayWorkingHours,
		required this.totalQueueCount,
		required this.availableBarbers,
		required this.totalAvailableBarbers,
		this.isFavorite = false,
	});

	factory Saloon.fromJson(Map<String, dynamic> json) {
		final saloonOwnerIdValue = json['saloonOwnerId'] ?? json['userId'] ?? '';
		final userIdValue = json['userId'] ?? saloonOwnerIdValue;
		return Saloon(
			shopId: json['shopId'] ?? '',
			saloonOwnerId: saloonOwnerIdValue,
			userId: userIdValue,
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
			statusReason: json['statusReason'],
			todayWorkingHours: json['todayWorkingHours'] != null 
				? TodayWorkingHours.fromJson(json['todayWorkingHours'])
				: null,
			totalQueueCount: json['totalQueueCount'] ?? 0,
			availableBarbers: (json['availableBarbers'] as List<dynamic>? ?? [])
				.map((e) => AvailableBarber.fromJson(e as Map<String, dynamic>))
				.toList(),
			totalAvailableBarbers: json['totalAvailableBarbers'] ?? 0,
			isFavorite: json['isFavorite'] ?? false,
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'shopId': shopId,
			'saloonOwnerId': saloonOwnerId,
			'userId': userId,
			'shopName': shopName,
			'shopAddress': shopAddress,
			'shopImages': shopImages,
			'shopLogo': shopLogo,
			'shopVideo': shopVideo,
			'phoneNumber': phoneNumber,
			'email': email,
			'latitude': latitude,
			'longitude': longitude,
			'distance': distance,
			'avgRating': avgRating,
			'ratingCount': ratingCount,
			'isOpen': isOpen,
			'shopStatus': shopStatus,
			'statusReason': statusReason,
			'todayWorkingHours': todayWorkingHours?.toJson(),
			'totalQueueCount': totalQueueCount,
			'availableBarbers': availableBarbers.map((e) => e.toJson()).toList(),
			'totalAvailableBarbers': totalAvailableBarbers,
			'isFavorite': isFavorite,
		};
	}
}

class AvailableBarber {
	final String barberId;
	final String barberName;
	final String barberImage;
	final int queueCount;
	final bool availableForQueue;
	final bool availableForBooking;
	final String serviceType;
	final TodayWorkingHours? workingHours;

	AvailableBarber({
		required this.barberId,
		required this.barberName,
		required this.barberImage,
		required this.queueCount,
		required this.availableForQueue,
		required this.availableForBooking,
		required this.serviceType,
		this.workingHours,
	});

	factory AvailableBarber.fromJson(Map<String, dynamic> json) {
		return AvailableBarber(
			barberId: json['barberId'] ?? '',
			barberName: json['barberName'] ?? '',
			barberImage: json['barberImage'] ?? '',
			queueCount: json['queueCount'] ?? 0,
			availableForQueue: json['availableForQueue'] ?? false,
			availableForBooking: json['availableForBooking'] ?? false,
			serviceType: json['serviceType'] ?? '',
			workingHours: json['workingHours'] != null
				? TodayWorkingHours.fromJson(json['workingHours'])
				: null,
		);
	}

	Map<String, dynamic> toJson() {
		return {
			'barberId': barberId,
			'barberName': barberName,
			'barberImage': barberImage,
			'queueCount': queueCount,
			'availableForQueue': availableForQueue,
			'availableForBooking': availableForBooking,
			'serviceType': serviceType,
			'workingHours': workingHours?.toJson(),
		};
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

	Map<String, dynamic> toJson() {
		return {
			'openingTime': openingTime,
			'closingTime': closingTime,
		};
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
