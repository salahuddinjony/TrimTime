class FollowersResponse {
	final bool success;
	final int statusCode;
	final String message;
	final List<Follower> data;

	FollowersResponse({
		required this.success,
		required this.statusCode,
		required this.message,
		required this.data,
	});

	factory FollowersResponse.fromJson(Map<String, dynamic> json) {
		return FollowersResponse(
			success: json['success'] ?? false,
			statusCode: json['statusCode'] ?? 0,
			message: json['message'] ?? '',
			data: (json['data'] as List<dynamic>? ?? [])
					.map((e) => Follower.fromJson(e as Map<String, dynamic>))
					.toList(),
		);
	}
}

class Follower {
	final String id;
	final String followerId;
	final String followerName;
	final String followerEmail;
	final String followerPhoneNumber;
	final String followerImage;
	final String followerAddress;
	final String followerGender;
  final String? followerRole;

	Follower({
		required this.id,
		required this.followerId,
		required this.followerName,
		required this.followerEmail,
		required this.followerPhoneNumber,
		required this.followerImage,
		required this.followerAddress,
		required this.followerGender,
    this.followerRole,
	});

	factory Follower.fromJson(Map<String, dynamic> json) {
		return Follower(
			id: json['id'] ?? '',
			followerId: json['followerId'] ?? '',
			followerName: json['followerName'] ?? '',
			followerEmail: json['followerEmail'] ?? '',
			followerPhoneNumber: json['followerPhoneNumber'] ?? '',
			followerImage: json['followerImage'] ?? '',
			followerAddress: json['followerAddress'] ?? '',
			followerGender: json['followerGender'] ?? '',
      followerRole: json['followerRole'] as String?,
		);
	}
}
