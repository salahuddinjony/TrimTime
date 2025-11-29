// Model for the barber's schedule
class BarberSchedule {
	final String start;
	final String end;

	BarberSchedule({required this.start, required this.end});

	factory BarberSchedule.fromJson(Map<String, dynamic> json) {
		return BarberSchedule(
			start: json['start'] ?? '',
			end: json['end'] ?? '',
		);
	}

	Map<String, dynamic> toJson() => {
				'start': start,
				'end': end,
			};
}

// Model for a barber
class Barber {
	final String barberId;
	final String name;
	final String image;
	final String status;
	final int totalQueueLength;
	final BarberSchedule schedule;
	// Add more fields if the API returns more (e.g., phone, email, etc.)

	Barber({
		required this.barberId,
		required this.name,
		required this.image,
		required this.status,
		required this.totalQueueLength,
		required this.schedule,
	});

	factory Barber.fromJson(Map<String, dynamic> json) {
		return Barber(
			barberId: json['barberId'] ?? '',
			name: json['name'] ?? '',
			image: json['image'] ?? '',
			status: json['status'] ?? '',
			totalQueueLength: json['totalQueueLength'] ?? 0,
			schedule: BarberSchedule.fromJson(json['schedule'] ?? {}),
		);
	}

	Map<String, dynamic> toJson() => {
				'barberId': barberId,
				'name': name,
				'image': image,
				'status': status,
				'totalQueueLength': totalQueueLength,
				'schedule': schedule.toJson(),
			};
}

// Model for the data object
class BarbersData {
	final bool isQueueEnabled;
	final String shopLogo;
	final List<Barber> barbers;
	final String? status; // Optional: add status if present in API
	final String? message; // Message when no barbers are available
	// Add more fields if the API returns more

	BarbersData({
		required this.isQueueEnabled,
		required this.shopLogo,
		required this.barbers,
		this.status,
		this.message,
	});

	factory BarbersData.fromJson(Map<String, dynamic> json) {
		// Check if the data object contains only a message (no barbers case)
		if (json.containsKey('message') && !json.containsKey('barbers')) {
			return BarbersData(
				isQueueEnabled: false,
				shopLogo: '',
				barbers: [],
				message: json['message']?.toString(),
			);
		}
		
		return BarbersData(
			isQueueEnabled: json['isQueueEnabled'] ?? false,
			shopLogo: json['shopLogo'] ?? '',
			barbers: (json['barbers'] as List<dynamic>? ?? [])
					.map((e) => Barber.fromJson(e as Map<String, dynamic>))
					.toList(),
			status: json['status'],
			message: json['message'],
		);
	}

	Map<String, dynamic> toJson() => {
				'isQueueEnabled': isQueueEnabled,
				'shopLogo': shopLogo,
				'barbers': barbers.map((e) => e.toJson()).toList(),
				if (status != null) 'status': status,
				if (message != null) 'message': message,
			};
}

// Top-level response model
class GetBarberWithDateWiseResponse {
	final bool success;
	final int statusCode;
	final String message;
	final BarbersData data;
	final String? status; // Optional: add status if present in API
	// Add more fields if the API returns more

	GetBarberWithDateWiseResponse({
		required this.success,
		required this.statusCode,
		required this.message,
		required this.data,
		this.status,
	});

	factory GetBarberWithDateWiseResponse.fromJson(Map<String, dynamic> json) {
		return GetBarberWithDateWiseResponse(
			success: json['success'] ?? false,
			statusCode: json['statusCode'] ?? 0,
			message: json['message'] ?? '',
			data: BarbersData.fromJson(json['data'] ?? {}),
			status: json['status'],
		);
	}

	Map<String, dynamic> toJson() => {
				'success': success,
				'statusCode': statusCode,
				'message': message,
				'data': data.toJson(),
				if (status != null) 'status': status,
			};
}
