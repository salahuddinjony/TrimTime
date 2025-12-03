class QueResponse {
  final bool success;
  final int statusCode;
  final String message;
  final QueModelData data;

  QueResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory QueResponse.fromJson(Map<String, dynamic> json) {
    return QueResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: QueModelData.fromJson(json['data'] ?? {}),
    );
  }
}

class QueModelData {
  final bool isQueueEnabled;
   final String saloonOwnerId;
  final String shopLogo;
  final String shopName;
  final String shopAddress;
  final double latitude;
  final double longitude;
  final int ratingCount;
  final double avgRating;
  final List<QueBarber> barbers;

  QueModelData({
    required this.isQueueEnabled,
    required this.saloonOwnerId,
    required this.shopLogo,
    required this.shopName,
    required this.shopAddress,
    required this.latitude,
    required this.longitude,
    required this.ratingCount,
    required this.avgRating,
    required this.barbers,
  });

  factory QueModelData.fromJson(Map<String, dynamic> json) {
    return QueModelData(
      isQueueEnabled: json['isQueueEnabled'] ?? false,
      saloonOwnerId: json['saloonOwnerId'] ?? '',
      shopLogo: json['shopLogo'] ?? '',
      shopName: json['shopName'] ?? '',
      shopAddress: json['shopAddress'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      ratingCount: json['ratingCount'] ?? 0,
      avgRating: (json['avgRating'] ?? 0.0).toDouble(),
      barbers: (json['barbers'] as List<dynamic>?)
              ?.map((e) => QueBarber.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class QueBarber {
  final String barberId;
  final String name;
  final String image;
  final String status;
  final num? totalQueueLength;
  final Schedule? schedule;

  QueBarber({
    required this.barberId,
    required this.name,
    required this.image,
    required this.status,
    this.totalQueueLength,
    this.schedule,
  });

  factory QueBarber.fromJson(Map<String, dynamic> json) {
    return QueBarber(
      barberId: json['barberId'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? '',
      totalQueueLength: json['totalQueueLength'],
      schedule: json['schedule'] != null
          ? Schedule.fromJson(json['schedule'])
          : null,
    );
  }
}

class Schedule {
  final String start;
  final String end;

  Schedule({
    required this.start,
    required this.end,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      start: json['start'] ?? '',
      end: json['end'] ?? '',
    );
  }
}
