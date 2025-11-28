
class LoyalityResponse {
	final bool success;
	final int statusCode;
	final String message;
	final List<LoyalityItem> data;

	LoyalityResponse({
		required this.success,
		required this.statusCode,
		required this.message,
		required this.data,
	});

	factory LoyalityResponse.fromJson(Map<String, dynamic> json) {
		return LoyalityResponse(
			success: json['success'] ?? false,
			statusCode: json['statusCode'] ?? 0,
			message: json['message'] ?? '',
			data: json['data'] != null
					? List<LoyalityItem>.from(
							(json['data'] as List).map((e) => LoyalityItem.fromJson(e)))
					: [],
		);
	}
}

class LoyalityItem {
	final String id;
	final String userId;
	final String serviceId;
	final String serviceName;
	final int points;
	final bool isActive;
	final String createdAt;
	final String updatedAt;

	LoyalityItem({
		required this.id,
		required this.userId,
		required this.serviceId,
		required this.serviceName,
		required this.points,
		required this.isActive,
		required this.createdAt,
		required this.updatedAt,
	});

	factory LoyalityItem.fromJson(Map<String, dynamic> json) {
		return LoyalityItem(
			id: json['id'] ?? '',
			userId: json['userId'] ?? '',
			serviceId: json['serviceId'] ?? '',
			serviceName: json['serviceName'] ?? '',
			points: json['points'] ?? 0,
			isActive: json['isActive'] ?? false,
			createdAt: json['createdAt'] ?? '',
			updatedAt: json['updatedAt'] ?? '',
		);
	}
}
