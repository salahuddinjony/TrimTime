// Model for Barber Queue Capacity API response

class BarberQueueCapacityResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<BarberQueueCapacityData> data;

  BarberQueueCapacityResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory BarberQueueCapacityResponse.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    final raw = json['data'];
    List<BarberQueueCapacityData> items = [];
    if (raw is List) {
      items = raw.map((e) => BarberQueueCapacityData.fromJson(e as Map<String, dynamic>?)).toList();
    }

    return BarberQueueCapacityResponse(
      success: json['success'] is bool ? json['success'] as bool : false,
      statusCode: json['statusCode'] is int ? json['statusCode'] as int : int.tryParse('${json['statusCode']}') ?? 0,
      message: json['message']?.toString() ?? '',
      data: items,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'statusCode': statusCode,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class BarberQueueCapacityData {
  final String id;
  final String barberId;
  final int maxCapacity;
  final String barberName;
  final String? image;

  BarberQueueCapacityData({
    required this.id,
    required this.barberId,
    required this.maxCapacity,
    required this.barberName,
    this.image,
  });

  factory BarberQueueCapacityData.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return BarberQueueCapacityData(
      id: json['id']?.toString() ?? '',
      barberId: json['barberId']?.toString() ?? '',
      maxCapacity: json['maxCapacity'] is int ? json['maxCapacity'] as int : int.tryParse('${json['maxCapacity']}') ?? 0,
      barberName: json['barberName']?.toString() ?? '',
      image: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'barberId': barberId,
        'maxCapacity': maxCapacity,
        'barberName': barberName,
        'image': image,
      };
}
