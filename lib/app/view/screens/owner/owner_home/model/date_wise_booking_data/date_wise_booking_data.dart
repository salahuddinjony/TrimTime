
class DateWiseBookingDataResponse {
	final bool success;
	final int statusCode;
	final String message;
	final List<BookingData> data;
	final Meta meta;

	DateWiseBookingDataResponse({
		required this.success,
		required this.statusCode,
		required this.message,
		required this.data,
		required this.meta,
	});

	factory DateWiseBookingDataResponse.fromJson(Map<String, dynamic> json) {
		try {
			return DateWiseBookingDataResponse(
				success: json['success'] ?? false,
				statusCode: json['statusCode'] ?? 0,
				message: json['message'] ?? '',
				data: (json['data'] as List<dynamic>?)?.map((e) => BookingData.fromJson(e as Map<String, dynamic>)).toList() ?? [],
				meta: json['meta'] != null ? Meta.fromJson(json['meta'] as Map<String, dynamic>) : Meta(total: 0, page: 0, limit: 0, pageCount: 0),
			);
		} catch (e) {
			print('Error parsing DateWiseBookingDataResponse: $e');
			print('JSON: $json');
			rethrow;
		}
	}
}

class BookingData {
	final String bookingId;
	final String customerId;
	final String barberId;
	final String saloonOwnerId;
	final double totalPrice;
	final String notes;
	final String? customerImage;
	final String customerName;
	final String customerEmail;
	final String? customerPhone;
	final String bookingDate;
	final String startTime;
	final String endTime;
	final List<ServiceData> services;
	final String barberName;
	final String barberImage;
	final String status;
	final int? position;

	BookingData({
		required this.bookingId,
		required this.customerId,
		required this.barberId,
		required this.saloonOwnerId,
		required this.totalPrice,
		required this.notes,
		required this.customerImage,
		required this.customerName,
		required this.customerEmail,
		required this.customerPhone,
		required this.bookingDate,
		required this.startTime,
		required this.endTime,
		required this.services,
		required this.barberName,
		required this.barberImage,
		required this.status,
		required this.position,
	});

	factory BookingData.fromJson(Map<String, dynamic> json) {
		try {
			return BookingData(
				bookingId: json['bookingId']?.toString() ?? '',
				customerId: json['customerId']?.toString() ?? '',
				barberId: json['barberId']?.toString() ?? '',
				saloonOwnerId: json['saloonOwnerId']?.toString() ?? '',
				totalPrice: (json['totalPrice'] is int)
						? (json['totalPrice'] as int).toDouble()
						: (json['totalPrice'] ?? 0.0).toDouble(),
				notes: json['notes']?.toString() ?? '',
				customerImage: json['customerImage']?.toString(),
				customerName: json['customerName']?.toString() ?? '',
				customerEmail: json['customerEmail']?.toString() ?? '',
				customerPhone: json['customerPhone']?.toString(),
				bookingDate: json['bookingDate']?.toString() ?? '',
				startTime: json['startTime']?.toString() ?? '',
				endTime: json['endTime']?.toString() ?? '',
				services: (json['services'] as List<dynamic>?)?.map((e) => ServiceData.fromJson(e as Map<String, dynamic>)).toList() ?? [],
				barberName: json['barberName']?.toString() ?? '',
				barberImage: json['barberImage']?.toString() ?? '',
				status: json['status']?.toString() ?? '',
				position: json['position'] as int?,
			);
		} catch (e) {
			print('Error parsing BookingData: $e');
			print('JSON: $json');
			rethrow;
		}
	}
}

class ServiceData {
	final String serviceId;
	final String serviceName;
	final double price;
	final String availableTo;

	ServiceData({
		required this.serviceId,
		required this.serviceName,
		required this.price,
		required this.availableTo,
	});

	factory ServiceData.fromJson(Map<String, dynamic> json) {
		try {
			return ServiceData(
				serviceId: json['serviceId']?.toString() ?? '',
				serviceName: json['serviceName']?.toString() ?? '',
				price: (json['price'] is int)
						? (json['price'] as int).toDouble()
						: (json['price'] ?? 0.0).toDouble(),
				availableTo: json['availableTo']?.toString() ?? '',
			);
		} catch (e) {
			print('Error parsing ServiceData: $e');
			print('JSON: $json');
			rethrow;
		}
	}
}

class Meta {
	final int total;
	final int page;
	final int limit;
	final int pageCount;

	Meta({
		required this.total,
		required this.page,
		required this.limit,
		required this.pageCount,
	});

	factory Meta.fromJson(Map<String, dynamic> json) {
		return Meta(
			total: json['total'] ?? 0,
			page: json['page'] ?? 0,
			limit: json['limit'] ?? 0,
			pageCount: json['pageCount'] ?? 0,
		);
	}
}
