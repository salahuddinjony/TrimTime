class HiredBarberResponse {
	final bool success;
	final int statusCode;
	final String message;
	final List<HiredBarber> data;
	final Meta meta;

	HiredBarberResponse({
		required this.success,
		required this.statusCode,
		required this.message,
		required this.data,
		required this.meta,
	});

	factory HiredBarberResponse.fromJson(Map<String, dynamic> json) {
		return HiredBarberResponse(
			success: json['success'] ?? false,
			statusCode: json['statusCode'] ?? 0,
			message: json['message'] ?? '',
			data: (json['data'] as List<dynamic>? ?? [])
					.map((e) => HiredBarber.fromJson(e as Map<String, dynamic>))
					.toList(),
			meta: Meta.fromJson(json['meta'] ?? {}),
		);
	}
}

class HiredBarber {
	final double hourlyRate;
	final DateTime startDate;
	final DateTime createdAt;
	final DateTime updatedAt;
	final String barberId;
	final String barberFullName;
	final String barberEmail;
	final String? barberPhoneNumber;
	final String? barberImage;

	HiredBarber({
		required this.hourlyRate,
		required this.startDate,
		required this.createdAt,
		required this.updatedAt,
		required this.barberId,
		required this.barberFullName,
		required this.barberEmail,
		this.barberPhoneNumber,
		this.barberImage,
	});

	factory HiredBarber.fromJson(Map<String, dynamic> json) {
		return HiredBarber(
			hourlyRate: (json['hourlyRate'] as num?)?.toDouble() ?? 0.0,
			startDate: DateTime.parse(json['startDate'] ?? ''),
			createdAt: DateTime.parse(json['createdAt'] ?? ''),
			updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
			barberId: json['barberId'] ?? '',
			barberFullName: json['barberFullName'] ?? '',
			barberEmail: json['barberEmail'] ?? '',
			barberPhoneNumber: json['barberPhoneNumber'],
			barberImage: json['barberImage'],
		);
	}
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
}
