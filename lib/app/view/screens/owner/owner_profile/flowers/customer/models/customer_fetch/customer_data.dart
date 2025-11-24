class CustomerFetchResponse {
	final bool success;
	final int statusCode;
	final String message;
	final CustomerData data;

	CustomerFetchResponse({
		required this.success,
		required this.statusCode,
		required this.message,
		required this.data,
	});

	factory CustomerFetchResponse.fromJson(Map<String, dynamic> json) {
		return CustomerFetchResponse(
			success: json['success'] as bool? ?? false,
			statusCode: json['statusCode'] as int? ?? 0,
			message: json['message'] as String? ?? '',
			data: CustomerData.fromJson(json['data'] as Map<String, dynamic>),
		);
	}

	Map<String, dynamic> toJson() => {
				'success': success,
				'statusCode': statusCode,
				'message': message,
				'data': data.toJson(),
			};
}

class CustomerData {
	final bool isMe;
	final String id;
	final String fullName;
	final String email;
	final String phoneNumber;
	final String? image;

	CustomerData({
		required this.isMe,
		required this.id,
		required this.fullName,
		required this.email,
		required this.phoneNumber,
		this.image,
	});

	factory CustomerData.fromJson(Map<String, dynamic> json) {
		return CustomerData(
			isMe: json['isMe'] as bool? ?? false,
			id: json['id'] as String? ?? '',
			fullName: json['fullName'] as String? ?? '',
			email: json['email'] as String? ?? '',
			phoneNumber: json['phoneNumber'] as String? ?? '',
			image: json['image'] as String?,
		);
	}

	Map<String, dynamic> toJson() => {
				'isMe': isMe,
				'id': id,
				'fullName': fullName,
				'email': email,
				'phoneNumber': phoneNumber,
				'image': image,
			};
}
