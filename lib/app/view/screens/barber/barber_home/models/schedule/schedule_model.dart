class BarberScheduleResponse {
  final bool success;
  final int statusCode;
  final String message;
  final List<BarberSchedule> data;

  BarberScheduleResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory BarberScheduleResponse.fromJson(Map<String, dynamic> json) {
    return BarberScheduleResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => BarberSchedule.fromJson(e as Map<String, dynamic>))
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

class BarberSchedule {
  final String id;
  final String saloonOwnerId;
  final String barberId;
  final String dayName;
  final String time;
  final bool isActive;
  final String type;
  final bool weekend;

  BarberSchedule({
    required this.id,
    required this.saloonOwnerId,
    required this.barberId,
    required this.dayName,
    required this.time,
    required this.isActive,
    required this.type,
    required this.weekend,
  });

  factory BarberSchedule.fromJson(Map<String, dynamic> json) {
    return BarberSchedule(
      id: json['id'] ?? '',
      saloonOwnerId: json['saloonOwnerId'] ?? '',
      barberId: json['barberId'] ?? '',
      dayName: json['dayName'] ?? '',
      time: json['time'] ?? '',
      isActive: json['isActive'] ?? false,
      type: json['type'] ?? '',
      weekend: json['weekend'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'saloonOwnerId': saloonOwnerId,
      'barberId': barberId,
      'dayName': dayName,
      'time': time,
      'isActive': isActive,
      'type': type,
      'weekend': weekend,
    };
  }

  BarberSchedule copyWith({
    String? id,
    String? saloonOwnerId,
    String? barberId,
    String? dayName,
    String? time,
    bool? isActive,
    String? type,
    bool? weekend,
  }) {
    return BarberSchedule(
      id: id ?? this.id,
      saloonOwnerId: saloonOwnerId ?? this.saloonOwnerId,
      barberId: barberId ?? this.barberId,
      dayName: dayName ?? this.dayName,
      time: time ?? this.time,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type,
      weekend: weekend ?? this.weekend,
    );
  }
}
