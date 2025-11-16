
class DateTimeWiseBarberResponse {
	final bool success;
	final int statusCode;
	final String message;
	final List<DateTimeWiseBarber> data;

	DateTimeWiseBarberResponse({
		required this.success,
		required this.statusCode,
		required this.message,
		required this.data,
	});

	factory DateTimeWiseBarberResponse.fromJson(Map<String, dynamic> json) {
		return DateTimeWiseBarberResponse(
			success: json['success'] ?? false,
			statusCode: json['statusCode'] ?? 0,
			message: json['message'] ?? '',
			data: (json['data'] as List<dynamic>? ?? [])
					.map((e) => DateTimeWiseBarber.fromJson(e as Map<String, dynamic>))
					.toList(),
		);
	}
}

class DateTimeWiseBarber {
	final String id;
	final String userId;
	final String saloonOwnerId;
	final String currentWorkDes;
	final String bio;
	final List<String> portfolio;
	final bool isAvailable;
	final String experienceYears;
	final List<String> skills;
	final int followerCount;
	final int followingCount;
	final int ratingCount;
	final double avgRating;
	final DateTime createdAt;
	final DateTime updatedAt;
	final BarberUser user;

	DateTimeWiseBarber({
		required this.id,
		required this.userId,
		required this.saloonOwnerId,
		required this.currentWorkDes,
		required this.bio,
		required this.portfolio,
		required this.isAvailable,
		required this.experienceYears,
		required this.skills,
		required this.followerCount,
		required this.followingCount,
		required this.ratingCount,
		required this.avgRating,
		required this.createdAt,
		required this.updatedAt,
		required this.user,
	});

	factory DateTimeWiseBarber.fromJson(Map<String, dynamic> json) {
		return DateTimeWiseBarber(
			id: json['id'] ?? '',
			userId: json['userId'] ?? '',
			saloonOwnerId: json['saloonOwnerId'] ?? '',
			currentWorkDes: json['currentWorkDes'] ?? '',
			bio: json['bio'] ?? '',
			portfolio: (json['portfolio'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
			isAvailable: json['isAvailable'] ?? false,
			experienceYears: json['experienceYears']?.toString() ?? '',
			skills: (json['skills'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
			followerCount: json['followerCount'] ?? 0,
			followingCount: json['followingCount'] ?? 0,
			ratingCount: json['ratingCount'] ?? 0,
			avgRating: (json['avgRating'] is int)
					? (json['avgRating'] as int).toDouble()
					: (json['avgRating'] is double)
							? json['avgRating']
							: 0.0,
			createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
			updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
			user: BarberUser.fromJson(json['user'] ?? {}),
		);
	}
}

class BarberUser {
	final String id;
	final String fullName;
	final String status;

	BarberUser({
		required this.id,
		required this.fullName,
		required this.status,
	});

	factory BarberUser.fromJson(Map<String, dynamic> json) {
		return BarberUser(
			id: json['id'] ?? '',
			fullName: json['fullName'] ?? '',
			status: json['status'] ?? '',
		);
	}
}
