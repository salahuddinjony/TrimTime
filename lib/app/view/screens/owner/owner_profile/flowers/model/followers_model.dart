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
		// Handle case where data is a Map with message instead of a List
		List<Follower> followers = [];
		final dataField = json['data'];
		
		if (dataField is List) {
			followers = dataField
					.map((e) => Follower.fromJson(e as Map<String, dynamic>))
					.toList();
		} else if (dataField is Map && dataField.containsKey('message')) {
			// API returns {"message": "No follower found"} when empty
			followers = [];
		}
		
		return FollowersResponse(
			success: json['success'] ?? false,
			statusCode: json['statusCode'] ?? 0,
			message: json['message'] ?? '',
			data: followers,
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
