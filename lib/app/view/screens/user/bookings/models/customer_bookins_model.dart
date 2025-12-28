class CustomerBookingsResponse {
	final bool success;
	final int statusCode;
	final String message;
	final List<CustomerBooking> data;
	final Meta? meta;

	CustomerBookingsResponse({
		required this.success,
		required this.statusCode,
		required this.message,
		required this.data,
		this.meta,
	});

	factory CustomerBookingsResponse.fromJson(Map<String, dynamic> json) {
		return CustomerBookingsResponse(
			success: json['success'] ?? false,
			statusCode: json['statusCode'] ?? 0,
			message: json['message'] ?? '',
			data: (json['data'] as List<dynamic>?)?.map((e) => CustomerBooking.fromJson(e)).toList() ?? [],
			meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
		);
	}
}

class Meta {
	final int total;
	final int page;
	final int limit;
	final int totalPages;
	final bool hasNextPage;
	final bool hasPrevPage;

	Meta({
		required this.total,
		required this.page,
		required this.limit,
		required this.totalPages,
		required this.hasNextPage,
		required this.hasPrevPage,
	});

	factory Meta.fromJson(Map<String, dynamic> json) {
		return Meta(
			total: json['total'] ?? 0,
			page: json['page'] ?? 1,
			limit: json['limit'] ?? 10,
			totalPages: json['totalPages'] ?? 0,
			hasNextPage: json['hasNextPage'] ?? false,
			hasPrevPage: json['hasPrevPage'] ?? false,
		);
	}
}

class CustomerBooking {
	final String bookingId;
	final String customerId;
	final String barberId;
	final String bookingType;
	final String saloonOwnerId;
	final String saloonName;
	final String saloonAddress;
	final String saloonLogo;
	final double totalPrice;
	final String notes;
	final String customerImage;
	final String customerName;
	final String customerEmail;
	final String customerContact;
	final DateTime date;
	final DateTime appointmentAt;
	final String startTime;
	final String endTime;
	final DateTime createdAt;
	final int? position;
	final String? currentPosition;
	final List<String> serviceNames;
	final List<int> serviceDurations;
	final String barberName;
	final String barberImage;
	final String status;
	final Map<String, dynamic>? payment;
	final LoyaltyScheme? loyaltyScheme;

	CustomerBooking({
		required this.bookingId,
		required this.customerId,
		required this.barberId,
		required this.bookingType,
		required this.saloonOwnerId,
		required this.saloonName,
		required this.saloonAddress,
		required this.saloonLogo,
		required this.totalPrice,
		required this.notes,
		required this.customerImage,
		required this.customerName,
		required this.customerEmail,
		required this.customerContact,
		required this.date,
		required this.appointmentAt,
		required this.startTime,
		required this.endTime,
		required this.createdAt,
		this.position,
		this.currentPosition,
		required this.serviceNames,
		required this.serviceDurations,
		required this.barberName,
		required this.barberImage,
		required this.status,
		this.payment,
		this.loyaltyScheme,
	});

	factory CustomerBooking.fromJson(Map<String, dynamic> json) {
		return CustomerBooking(
			bookingId: json['bookingId'] ?? '',
			customerId: json['customerId'] ?? '',
			barberId: json['barberId'] ?? '',
			bookingType: json['bookingType'] ?? '',
			saloonOwnerId: json['saloonOwnerId'] ?? '',
			saloonName: json['saloonName'] ?? '',
			saloonAddress: json['saloonAddress'] ?? '',
			saloonLogo: json['saloonLogo'] ?? '',
			totalPrice: (json['totalPrice'] is int)
					? (json['totalPrice'] as int).toDouble()
					: (json['totalPrice'] ?? 0.0).toDouble(),
			notes: json['notes'] ?? '',
			customerImage: json['customerImage'] ?? '',
			customerName: json['customerName'] ?? '',
			customerEmail: json['customerEmail'] ?? '',
			customerContact: json['customerContact'] ?? '',
			date: DateTime.tryParse(json['date'] ?? '') ?? DateTime(1970),
			appointmentAt: DateTime.tryParse(json['appointmentAt'] ?? '') ?? DateTime(1970),
			startTime: json['startTime'] ?? '',
			endTime: json['endTime'] ?? '',
			createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime(1970),
			position: json['position'],
			currentPosition: json['currentPosition'],
			serviceNames: (json['serviceNames'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
			serviceDurations: (json['serviceDurations'] as List<dynamic>?)?.map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0).toList() ?? [],
			barberName: json['barberName'] ?? '',
			barberImage: json['barberImage'] ?? '',
			status: json['status'] ?? '',
			payment: json['payment'] != null ? Map<String, dynamic>.from(json['payment']) : null,
			loyaltyScheme: json['loyaltyScheme'] != null ? LoyaltyScheme.fromJson(json['loyaltyScheme']) : null,
		);
	}
}

class LoyaltyScheme {
	final String id;
	final int percentage;
	final int pointThreshold;

	LoyaltyScheme({
		required this.id,
		required this.percentage,
		required this.pointThreshold,
	});

	factory LoyaltyScheme.fromJson(Map<String, dynamic> json) {
		return LoyaltyScheme(
			id: json['id'] ?? '',
			percentage: json['percentage'] ?? 0,
			pointThreshold: json['pointThreshold'] ?? 0,
		);
	}
}
