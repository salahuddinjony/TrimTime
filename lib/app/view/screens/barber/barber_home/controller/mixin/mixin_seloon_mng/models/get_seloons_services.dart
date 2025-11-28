// Top-level response model for saloon services
class GetSeloonsServicesResponse {
	final bool success;
	final int statusCode;
	final String message;
	final List<SaloonService> data;

	GetSeloonsServicesResponse({
		required this.success,
		required this.statusCode,
		required this.message,
		required this.data,
	});

	factory GetSeloonsServicesResponse.fromJson(Map<String, dynamic> json) {
		return GetSeloonsServicesResponse(
			success: json['success'] ?? false,
			statusCode: json['statusCode'] ?? 0,
			message: json['message'] ?? '',
			data: (json['data'] as List<dynamic>? ?? [])
					.map((e) => SaloonService.fromJson(e as Map<String, dynamic>))
					.toList(),
		);
	}

	Map<String, dynamic> toJson() => {
				'success': success,
				'statusCode': statusCode,
				'message': message,
				'data': data.map((e) => e.toJson()).toList(),
			};
}
// Model for the nested Saloon object
class Saloon {
	final String saloonId;
	final String shopName;
	final String shopLogo;
	final String shopAddress;

	Saloon({
		required this.saloonId,
		required this.shopName,
		required this.shopLogo,
		required this.shopAddress,
	});

	factory Saloon.fromJson(Map<String, dynamic> json) {
		return Saloon(
			saloonId: json['saloonId'] ?? '',
			shopName: json['shopName'] ?? '',
			shopLogo: json['shopLogo'] ?? '',
			shopAddress: json['shopAddress'] ?? '',
		);
	}

	Map<String, dynamic> toJson() => {
				'saloonId': saloonId,
				'shopName': shopName,
				'shopLogo': shopLogo,
				'shopAddress': shopAddress,
			};
}

// Model for the main Service object
class SaloonService {
	final String id;
	final String name;
	final num price;
	final int duration;
	final String saloonOwnerId;
	final Saloon saloon;

	SaloonService({
		required this.id,
		required this.name,
		required this.price,
		required this.duration,
		required this.saloonOwnerId,
		required this.saloon,
	});

	factory SaloonService.fromJson(Map<String, dynamic> json) {
		return SaloonService(
			id: json['id'] ?? '',
			name: json['name'] ?? '',
			price: json['price'] ?? 0,
			duration: json['duration'] ?? 0,
			saloonOwnerId: json['saloonOwnerId'] ?? '',
			saloon: Saloon.fromJson(json['saloon'] ?? {}),
		);
	}

	Map<String, dynamic> toJson() => {
				'id': id,
				'name': name,
				'price': price,
				'duration': duration,
				'saloonOwnerId': saloonOwnerId,
				'saloon': saloon.toJson(),
			};
}
