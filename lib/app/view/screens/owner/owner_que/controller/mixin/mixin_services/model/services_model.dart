class ServicesResponse {
	final bool success;
	final int statusCode;
	final String message;
	final List<ServiceItem> data;
	final Meta meta;

	ServicesResponse({
		required this.success,
		required this.statusCode,
		required this.message,
		required this.data,
		required this.meta,
	});

	factory ServicesResponse.fromJson(Map<String, dynamic> json) {
		return ServicesResponse(
			success: json['success'] ?? false,
			statusCode: json['statusCode'] ?? 0,
			message: json['message'] ?? '',
			data: (json['data'] as List<dynamic>? ?? [])
					.map((e) => ServiceItem.fromJson(e as Map<String, dynamic>))
					.toList(),
			meta: Meta.fromJson(json['meta'] ?? {}),
		);
	}

	Map<String, dynamic> toJson() => {
				'success': success,
				'statusCode': statusCode,
				'message': message,
				'data': data.map((e) => e.toJson()).toList(),
				'meta': meta.toJson(),
			};
}

class ServiceItem {
	final String id;
	final String name;
	final String availableTo;
	final double price;
	final int duration;
	final bool isActive;
	final String saloonOwnerId;
	final DateTime createdAt;
	final DateTime updatedAt;

	ServiceItem({
		required this.id,
		required this.name,
		required this.availableTo,
		required this.price,
		required this.duration,
		required this.isActive,
		required this.saloonOwnerId,
		required this.createdAt,
		required this.updatedAt,
	});

	factory ServiceItem.fromJson(Map<String, dynamic> json) {
		return ServiceItem(
			id: json['id'] ?? '',
			name: json['name'] ?? '',
			availableTo: json['availableTo'] ?? '',
			price: (json['price'] is int)
					? (json['price'] as int).toDouble()
					: (json['price'] ?? 0.0).toDouble(),
			duration: json['duration'] ?? 0,
			isActive: json['isActive'] ?? false,
			saloonOwnerId: json['saloonOwnerId'] ?? '',
			createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime(1970),
			updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime(1970),
		);
	}

	Map<String, dynamic> toJson() => {
				'id': id,
				'name': name,
				'availableTo': availableTo,
				'price': price,
				'duration': duration,
				'isActive': isActive,
				'saloonOwnerId': saloonOwnerId,
				'createdAt': createdAt.toIso8601String(),
				'updatedAt': updatedAt.toIso8601String(),
			};
}

class Meta {
	final int page;
	final int limit;
	final int total;
	final int totalPages;
	final bool hasNextPage;
	final bool hasPrevPage;

	Meta({
		required this.page,
		required this.limit,
		required this.total,
		required this.totalPages,
		required this.hasNextPage,
		required this.hasPrevPage,
	});

	factory Meta.fromJson(Map<String, dynamic> json) {
		return Meta(
			page: json['page'] ?? 1,
			limit: json['limit'] ?? 10,
			total: json['total'] ?? 0,
			totalPages: json['totalPages'] ?? 1,
			hasNextPage: json['hasNextPage'] ?? false,
			hasPrevPage: json['hasPrevPage'] ?? false,
		);
	}

	Map<String, dynamic> toJson() => {
				'page': page,
				'limit': limit,
				'total': total,
				'totalPages': totalPages,
				'hasNextPage': hasNextPage,
				'hasPrevPage': hasPrevPage,
			};
}
