class BusinessProfileResponse {
	final bool success;
	final int statusCode;
	final String message;
	final BusinessProfileData data;

	BusinessProfileResponse({
		required this.success,
		required this.statusCode,
		required this.message,
		required this.data,
	});

	factory BusinessProfileResponse.fromJson(Map<String, dynamic> json) {
		return BusinessProfileResponse(
			success: json['success'] as bool,
			statusCode: json['statusCode'] as int,
			message: json['message'] as String,
			data: BusinessProfileData.fromJson(json['data'] as Map<String, dynamic>),
		);
	}
}


class BusinessProfileData {
	final String id;
	final String userId;
	final String shopName;
	final String registrationNumber;
	final String shopAddress;
	final String shopBio;
	final double latitude;
	final double longitude;
	final String shopLogo;
	final List<String> shopImages;
	final List<String> shopVideo;
	final String? qrCode;
	final bool isQueueEnabled;
	final bool isVerified;
	final int followerCount;
	final int followingCount;
	final int ratingCount;
	final double avgRating;
	final int jobPostCount;
	final DateTime createdAt;
	final DateTime updatedAt;
	final List<Barber> barbers;
	final List<BusinessService> services;

	BusinessProfileData({
		required this.id,
		required this.userId,
		required this.shopName,
		required this.registrationNumber,
		required this.shopAddress,
		required this.shopBio,
		required this.latitude,
		required this.longitude,
		required this.shopLogo,
		required this.shopImages,
		required this.shopVideo,
		required this.qrCode,
		required this.isQueueEnabled,
		required this.isVerified,
		required this.followerCount,
		required this.followingCount,
		required this.ratingCount,
		required this.avgRating,
		required this.jobPostCount,
		required this.createdAt,
		required this.updatedAt,
		required this.barbers,
		required this.services,
	});

	factory BusinessProfileData.fromJson(Map<String, dynamic> json) {
		return BusinessProfileData(
			id: json['id'] as String,
			userId: json['userId'] as String,
			shopName: json['shopName'] as String,
			registrationNumber: json['registrationNumber'] as String,
			shopAddress: json['shopAddress'] as String,
			shopBio: json['shopBio'] as String,
			latitude: (json['latitude'] as num).toDouble(),
			longitude: (json['longitude'] as num).toDouble(),
			shopLogo: json['shopLogo'] as String,
			shopImages: (json['shopImages'] as List).map((e) => e.toString()).toList(),
			shopVideo: (json['shopVideo'] as List).map((e) => e.toString()).toList(),
			qrCode: json['qrCode'] as String?,
			isQueueEnabled: json['isQueueEnabled'] as bool,
			isVerified: json['isVerified'] as bool,
			followerCount: json['followerCount'] as int,
			followingCount: json['followingCount'] as int,
			ratingCount: json['ratingCount'] as int,
			avgRating: (json['avgRating'] as num).toDouble(),
			jobPostCount: json['jobPostCount'] as int,
			createdAt: DateTime.parse(json['createdAt'] as String),
			updatedAt: DateTime.parse(json['updatedAt'] as String),
			barbers: (json['Barbers'] as List)
					.map((e) => Barber.fromJson(e as Map<String, dynamic>))
					.toList(),
			services: (json['services'] as List)
					.map((e) => BusinessService.fromJson(e as Map<String, dynamic>))
					.toList(),
		);
	}
}

class Barber {
	final String id;
	final String fullName;
	final String email;
	final String image;
	final bool hasSchedule;
	final int scheduleCount;
	final List<Schedule> schedules;

	Barber({
		required this.id,
		required this.fullName,
		required this.email,
		required this.image,
		required this.hasSchedule,
		required this.scheduleCount,
		required this.schedules,
	});

	factory Barber.fromJson(Map<String, dynamic> json) {
		return Barber(
			id: json['id'] as String,
			fullName: json['fullName'] as String,
			email: json['email'] as String,
			image: json['image'] as String,
			hasSchedule: json['hasSchedule'] as bool,
			scheduleCount: json['scheduleCount'] as int,
			schedules: (json['schedules'] as List)
					.map((e) => Schedule.fromJson(e as Map<String, dynamic>))
					.toList(),
		);
	}
}

class Schedule {
	final String id;
	final String dayName;
	final String openingTime;
	final String closingTime;
	final String type;

	Schedule({
		required this.id,
		required this.dayName,
		required this.openingTime,
		required this.closingTime,
		required this.type,
	});

	factory Schedule.fromJson(Map<String, dynamic> json) {
		return Schedule(
			id: json['id'] as String,
			dayName: json['dayName'] as String,
			openingTime: json['openingTime'] as String,
			closingTime: json['closingTime'] as String,
			type: json['type'] as String,
		);
	}
}

class BusinessService {
	final String id;
	final String serviceName;

	BusinessService({
		required this.id,
		required this.serviceName,
	});

	factory BusinessService.fromJson(Map<String, dynamic> json) {
		return BusinessService(
			id: json['id'] as String,
			serviceName: json['serviceName'] as String,
		);
	}
}
