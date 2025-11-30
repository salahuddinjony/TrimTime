class CustomerBookingsResponse {
	final bool success;
	final int statusCode;
	final String message;
	final List<CustomerBooking> data;

	CustomerBookingsResponse({
		required this.success,
		required this.statusCode,
		required this.message,
		required this.data,
	});

	factory CustomerBookingsResponse.fromJson(Map<String, dynamic> json) {
		return CustomerBookingsResponse(
			success: json['success'] ?? false,
			statusCode: json['statusCode'] ?? 0,
			message: json['message'] ?? '',
			data: (json['data'] as List<dynamic>?)?.map((e) => CustomerBooking.fromJson(e)).toList() ?? [],
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
	final String time;
	final int estimatedWaitTime;
	final int? position;
	final List<String> serviceNames;
	final List<int> serviceDurations;
	final String barberName;
	final String barberImage;
	final String status;

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
		required this.time,
		required this.estimatedWaitTime,
		required this.position,
		required this.serviceNames,
		required this.serviceDurations,
		required this.barberName,
		required this.barberImage,
		required this.status,
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
			time: json['time'] ?? '',
			estimatedWaitTime: json['estimatedWaitTime'] ?? 0,
			position: json['position'],
			serviceNames: (json['serviceNames'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
			serviceDurations: (json['serviceDurations'] as List<dynamic>?)?.map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0).toList() ?? [],
			barberName: json['barberName'] ?? '',
			barberImage: json['barberImage'] ?? '',
			status: json['status'] ?? '',
		);
	}
}
