class BarbersCustomerQueResponse {
  final bool success;
  final int statusCode;
  final String message;
  final BarbersQueData? data;

  BarbersCustomerQueResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory BarbersCustomerQueResponse.fromJson(Map<String, dynamic> json) {
    return BarbersCustomerQueResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? "",
      data: json['data'] != null ? BarbersQueData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "statusCode": statusCode,
      "message": message,
      "data": data?.toJson(),
    };
  }
}

class BarbersQueData {
  final String? shopLogo;
  final String? barberId;
  final String? image;
  final String? name;
  final String? status;
  final Schedule? schedule;
  final List<Booking> bookings;
  final List<Slot> freeSlots;
  final QueueInfo? queue;

  BarbersQueData({
    this.shopLogo,
    this.barberId,
    this.image,
    this.name,
    this.status,
    this.schedule,
    required this.bookings,
    required this.freeSlots,
    this.queue,
  });

  factory BarbersQueData.fromJson(Map<String, dynamic> json) {
    return BarbersQueData(
      shopLogo: json['shopLogo'],
      barberId: json['barberId'],
      image: json['image'],
      name: json['name'],
      status: json['status'],
      schedule: json['schedule'] != null
          ? Schedule.fromJson(json['schedule'])
          : null,
      bookings: (json['bookings'] as List? ?? [])
          .map((e) => Booking.fromJson(e))
          .toList(),
      freeSlots: (json['freeSlots'] as List? ?? [])
          .map((e) => Slot.fromJson(e))
          .toList(),
      queue: json['queue'] != null ? QueueInfo.fromJson(json['queue']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "shopLogo": shopLogo,
      "barberId": barberId,
      "image": image,
      "name": name,
      "status": status,
      "schedule": schedule?.toJson(),
      "bookings": bookings.map((e) => e.toJson()).toList(),
      "freeSlots": freeSlots.map((e) => e.toJson()).toList(),
      "queue": queue?.toJson(),
    };
  }
}

class Schedule {
  final String? start;
  final String? end;

  Schedule({this.start, this.end});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      start: json['start'],
      end: json['end'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "start": start,
      "end": end,
    };
  }
}

class Slot {
  final String? start;
  final String? end;

  Slot({this.start, this.end});

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      start: json['start'],
      end: json['end'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "start": start,
      "end": end,
    };
  }
}

class Booking {
  final String? startTime;
  final String? endTime;
  final List<String> services;
  final int? totalTime;

  Booking({
    this.startTime,
    this.endTime,
    this.services = const [],
    this.totalTime,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      startTime: json['startTime'],
      endTime: json['endTime'],
      services: (json['services'] as List?)?.map((e) => e.toString()).toList() ?? [],
      totalTime: json['totalTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'services': services,
      'totalTime': totalTime,
    };
  }
}

class QueueInfo {
  final String? queueId;
  final int? currentPosition;
  final int? totalInQueue;
  final int? estimatedWaitTime;
  final int? queueOrder;

  QueueInfo({
    this.queueId,
    this.currentPosition,
    this.totalInQueue,
    this.estimatedWaitTime,
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

  Map<String, dynamic> toJson() {
    return {
      "queueId": queueId,
      "currentPosition": currentPosition,
      "totalInQueue": totalInQueue,
      "estimatedWaitTime": estimatedWaitTime,
      "queueOrder": queueOrder,
    };
  }
}
