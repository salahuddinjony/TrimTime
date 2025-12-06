class LoyaltyDataModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<VisitedSaloon> data;
  final Meta meta;

  LoyaltyDataModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory LoyaltyDataModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyDataModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => VisitedSaloon.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

class VisitedSaloon {
  final String saloonOwnerId;
  final String shopName;
  final String customerName;
  final String customerImage;
  final int visitCount;
  final String lastVisitedAt;
  final int totalPoints;
  final List<Offer> offers;
  final List<Offer> applicableOffers;

  VisitedSaloon({
    required this.saloonOwnerId,
    required this.shopName,
    required this.customerName,
    required this.customerImage,
    required this.visitCount,
    required this.lastVisitedAt,
    required this.totalPoints,
    required this.offers,
    required this.applicableOffers,
  });

  factory VisitedSaloon.fromJson(Map<String, dynamic> json) {
    return VisitedSaloon(
      saloonOwnerId: json['saloonOwnerId'] ?? '',
      shopName: json['shopName'] ?? '',
      customerName: json['customerName'] ?? '',
      customerImage: json['customerImage'] ?? '',
      visitCount: json['visitCount'] ?? 0,
      lastVisitedAt: json['lastVisitedAt'] ?? '',
      totalPoints: json['totalPoints'] ?? 0,
      offers: (json['offers'] as List<dynamic>?)
              ?.map((e) => Offer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      applicableOffers: (json['applicableOffers'] as List<dynamic>?)
              ?.map((e) => Offer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'saloonOwnerId': saloonOwnerId,
      'shopName': shopName,
      'customerName': customerName,
      'customerImage': customerImage,
      'visitCount': visitCount,
      'lastVisitedAt': lastVisitedAt,
      'totalPoints': totalPoints,
      'offers': offers.map((e) => e.toJson()).toList(),
      'applicableOffers': applicableOffers.map((e) => e.toJson()).toList(),
    };
  }
}

class Offer {
  final String schemeKey;
  final int pointThreshold;
  final int percentage;
  final bool eligible;
  final int pointsNeeded;

  Offer({
    required this.schemeKey,
    required this.pointThreshold,
    required this.percentage,
    required this.eligible,
    required this.pointsNeeded,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      schemeKey: json['schemeKey'] ?? '',
      pointThreshold: json['pointThreshold'] ?? 0,
      percentage: json['percentage'] ?? 0,
      eligible: json['eligible'] ?? false,
      pointsNeeded: json['pointsNeeded'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schemeKey': schemeKey,
      'pointThreshold': pointThreshold,
      'percentage': percentage,
      'eligible': eligible,
      'pointsNeeded': pointsNeeded,
    };
  }
}

class Meta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Meta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }
}
