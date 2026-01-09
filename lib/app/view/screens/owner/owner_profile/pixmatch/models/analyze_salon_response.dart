import '../../../../user/home/models/selons_models/get_selons_data.dart';

class AnalyzeSalonResponse {
  final bool success;
  final int statusCode;
  final String message;
  final AnalyzeSalonData data;

  AnalyzeSalonResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AnalyzeSalonResponse.fromJson(Map<String, dynamic> json) {
    return AnalyzeSalonResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: AnalyzeSalonData.fromJson(json['data'] ?? {}),
    );
  }
}

class AnalyzeSalonData {
  final bool success;
  final String message;
  final List<Saloon> nearestSaloons;
  final List<dynamic> matchedBarbers;
  final List<dynamic> recommendations;

  AnalyzeSalonData({
    required this.success,
    required this.message,
    required this.nearestSaloons,
    required this.matchedBarbers,
    required this.recommendations,
  });

  factory AnalyzeSalonData.fromJson(Map<String, dynamic> json) {
    return AnalyzeSalonData(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      nearestSaloons: (json['nearestSaloons'] as List<dynamic>? ?? [])
          .map((e) => Saloon.fromJson(e as Map<String, dynamic>))
          .toList(),
      matchedBarbers: json['matchedBarbers'] ?? [],
      recommendations: json['recommendations'] ?? [],
    );
  }
}

