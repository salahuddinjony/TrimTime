class BarberBookingResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<BarberBookingData> data;

  BarberBookingResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory BarberBookingResponse.fromJson(Map<String, dynamic> json) {
    return BarberBookingResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => BarberBookingData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class BarberBookingData {
  final String bookingId;
  final String userId;
  final String saloonOwnerId;
  final String barberId;
  final DateTime date;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String status;
  final num totalPrice;
  final DateTime createdAt;
  final String userFullName;
  final String userEmail;
  final String userPhoneNumber;
  final String? userImage;
  final List<BookedService> bookedServices;

  BarberBookingData({
    required this.bookingId,
    required this.userId,
    required this.saloonOwnerId,
    required this.barberId,
    required this.date,
    required this.startDateTime,
    required this.endDateTime,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.userFullName,
    required this.userEmail,
    required this.userPhoneNumber,
    this.userImage,
    required this.bookedServices,
  });

  factory BarberBookingData.fromJson(Map<String, dynamic> json) {
    return BarberBookingData(
      bookingId: json['bookingId'] ?? '',
      userId: json['userId'] ?? '',
      saloonOwnerId: json['saloonOwnerId'] ?? '',
      barberId: json['barberId'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      startDateTime: DateTime.parse(
          json['startDateTime'] ?? DateTime.now().toIso8601String()),
      endDateTime: DateTime.parse(
          json['endDateTime'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? '',
      totalPrice: json['totalPrice'] ?? 0,
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      userFullName: json['userFullName'] ?? '',
      userEmail: json['userEmail'] ?? '',
      userPhoneNumber: json['userPhoneNumber'] ?? '',
      userImage: json['userImage'],
      bookedServices: (json['bookedServices'] as List<dynamic>?)
              ?.map((e) => BookedService.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'userId': userId,
      'saloonOwnerId': saloonOwnerId,
      'barberId': barberId,
      'date': date.toIso8601String(),
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'status': status,
      'totalPrice': totalPrice,
      'createdAt': createdAt.toIso8601String(),
      'userFullName': userFullName,
      'userEmail': userEmail,
      'userPhoneNumber': userPhoneNumber,
      'userImage': userImage,
      'bookedServices': bookedServices.map((e) => e.toJson()).toList(),
    };
  }
}

class BookedService {
  final String id;
  final String serviceName;
  final String availableTo;
  final num price;
  final int duration;

  BookedService({
    required this.id,
    required this.serviceName,
    required this.availableTo,
    required this.price,
    required this.duration,
  });

  factory BookedService.fromJson(Map<String, dynamic> json) {
    return BookedService(
      id: json['id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      availableTo: json['availableTo'] ?? '',
      price: json['price'] ?? 0,
      duration: json['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceName': serviceName,
      'availableTo': availableTo,
      'price': price,
      'duration': duration,
    };
  }
}
