class FollowingResponse {
	final bool success;
	final int statusCode;
	final String message;
	final List<Following> data;

	FollowingResponse({
		required this.success,
		required this.statusCode,
		required this.message,
		required this.data,
	});

	factory FollowingResponse.fromJson(Map<String, dynamic> json) {
		return FollowingResponse(
			success: json['success'] ?? false,
			statusCode: json['statusCode'] ?? 0,
			message: json['message'] ?? '',
			data: (json['data'] as List<dynamic>? ?? [])
					.map((e) => Following.fromJson(e as Map<String, dynamic>))
					.toList(),
		);
	}
}

class Following {
	final String id;
	final String followingId;
	final String followingName;
	final String followingEmail;
	final String followingPhoneNumber;
	final String followingImage;
	final String followingGender;
	final String followingAddress;
	final String followingRole;

	Following({
		required this.id,
		required this.followingId,
		required this.followingName,
		required this.followingEmail,
		required this.followingPhoneNumber,
		required this.followingImage,
		required this.followingGender,
		required this.followingAddress,
    required this.followingRole,
	});

	factory Following.fromJson(Map<String, dynamic> json) {
		return Following(
			id: json['id'] ?? '',
			followingId: json['followingId'] ?? '',
			followingName: json['followingName'] ?? '',
			followingEmail: json['followingEmail'] ?? '',
			followingPhoneNumber: json['followingPhoneNumber'] ?? '',
			followingImage: json['followingImage'] ?? '',
			followingGender: json['followingGender'] ?? '',
			followingAddress: json['followingAddress'] ?? '',
      followingRole: json['followingRole'] ?? '',
		);
	}
}
