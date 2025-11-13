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
  final List<QueBarber> barbers;

  QueModelData({
    required this.isQueueEnabled,
    required this.barbers,
  });

  factory QueModelData.fromJson(Map<String, dynamic> json) {
    return QueModelData(
      isQueueEnabled: json['isQueueEnabled'] ?? false,
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
  final Schedule? schedule;

  QueBarber({
    required this.barberId,
    required this.name,
    required this.image,
    required this.status,
    this.schedule,
  });

  factory QueBarber.fromJson(Map<String, dynamic> json) {
    return QueBarber(
      barberId: json['barberId'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? '',
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
