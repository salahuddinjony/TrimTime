// Model for schedule and free slot
class TimeSlot {
  final String start;
  final String end;

  TimeSlot({required this.start, required this.end});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      start: json['start'] ?? '',
      end: json['end'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'start': start,
        'end': end,
      };
}

// Model for queue
class QueueInfo {
  final String? queueId;
  final int? currentPosition;
  final int totalInQueue;
  final int estimatedWaitTime;
  final int? queueOrder;

  QueueInfo({
    this.queueId,
    this.currentPosition,
    required this.totalInQueue,
    required this.estimatedWaitTime,
    this.queueOrder,
  });

  factory QueueInfo.fromJson(Map<String, dynamic> json) {
    return QueueInfo(
      queueId: json['queueId'],
      currentPosition: json['currentPosition'],
      totalInQueue: json['totalInQueue'] ?? 0,
      estimatedWaitTime: json['estimatedWaitTime'] ?? 0,
      queueOrder: json['queueOrder'],
    );
  }

  Map<String, dynamic> toJson() => {
        'queueId': queueId,
        'currentPosition': currentPosition,
        'totalInQueue': totalInQueue,
        'estimatedWaitTime': estimatedWaitTime,
        'queueOrder': queueOrder,
      };
}

// Model for the main data object
class SelectedBarberData {
  final String shopLogo;
  final String barberId;
  final String barberBookingType;
  final String image;
  final String name;
  final String status;
  final TimeSlot schedule;
  final List<dynamic> bookings;
  final List<TimeSlot> freeSlots;
  final QueueInfo queue;

  SelectedBarberData({
    required this.shopLogo,
    required this.barberId,
    required this.barberBookingType,
    required this.image,
    required this.name,
    required this.status,
    required this.schedule,
    required this.bookings,
    required this.freeSlots,
    required this.queue,
  });

  factory SelectedBarberData.fromJson(Map<String, dynamic> json) {
    return SelectedBarberData(
      shopLogo: json['shopLogo'] ?? '',
      barberId: json['barberId'] ?? '',
      barberBookingType: json['barberBookingType'] ?? '',
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      schedule: TimeSlot.fromJson(json['schedule'] ?? {}),
      bookings: json['bookings'] ?? [],
      freeSlots: (json['freeSlots'] as List<dynamic>? ?? [])
          .map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
          .toList(),
      queue: QueueInfo.fromJson(json['queue'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'shopLogo': shopLogo,
        'barberId': barberId,
        'barberBookingType': barberBookingType,
        'image': image,
        'name': name,
        'status': status,
        'schedule': schedule.toJson(),
        'bookings': bookings,
        'freeSlots': freeSlots.map((e) => e.toJson()).toList(),
        'queue': queue.toJson(),
      };
}

// Top-level response model
class SelectedBarberFreeSlotsResponse {
  final bool success;
  final int statusCode;
  final String message;
  final SelectedBarberData data;

  SelectedBarberFreeSlotsResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SelectedBarberFreeSlotsResponse.fromJson(Map<String, dynamic> json) {
    return SelectedBarberFreeSlotsResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: SelectedBarberData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'statusCode': statusCode,
        'message': message,
        'data': data.toJson(),
      };
}
