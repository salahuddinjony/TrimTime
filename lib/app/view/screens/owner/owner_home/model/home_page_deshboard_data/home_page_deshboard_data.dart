
class HomePageDashboardResponse {
	final bool success;
	final int statusCode;
	final String message;
	final HomePageDashboardData data;

	HomePageDashboardResponse({
		required this.success,
		required this.statusCode,
		required this.message,
		required this.data,
	});

	factory HomePageDashboardResponse.fromJson(Map<String, dynamic> json) {
		return HomePageDashboardResponse(
			success: json['success'] ?? false,
			statusCode: json['statusCode'] ?? 0,
			message: json['message'] ?? '',
			data: HomePageDashboardData.fromJson(json['data'] ?? {}),
		);
	}
}

class HomePageDashboardData {
	final int totalCustomers;
	final int totalEarnings;
	final int totalBarbers;
	final int totalBookings;
	final int totalJobPosts;
	final int totalJobApplicants;
  final int totalQueuedBookings;
	final List<EarningGrowth> earningGrowth;
	final List<CustomerGrowth> customerGrowth;

	HomePageDashboardData({
		required this.totalCustomers,
		required this.totalEarnings,
		required this.totalBarbers,
		required this.totalBookings,
		required this.totalJobPosts,
		required this.totalJobApplicants,
		required this.earningGrowth,
		required this.customerGrowth,
    required this.totalQueuedBookings,
	});

	factory HomePageDashboardData.fromJson(Map<String, dynamic> json) {
		return HomePageDashboardData(
			totalCustomers: json['totalCustomers'] ?? 0,
			totalEarnings: json['totalEarnings'] ?? 0,
			totalBarbers: json['totalBarbers'] ?? 0,
			totalBookings: json['totalBookings'] ?? 0,
			totalJobPosts: json['totalJobPosts'] ?? 0,
      totalQueuedBookings: json['totalQueuedBookings'] ?? 0,
			totalJobApplicants: json['totalJobApplicants'] ?? 0,
			earningGrowth: (json['earningGrowth'] as List<dynamic>? ?? [])
					.map((e) => EarningGrowth.fromJson(e))
					.toList(),
			customerGrowth: (json['customerGrowth'] as List<dynamic>? ?? [])
					.map((e) => CustomerGrowth.fromJson(e))
					.toList(),
		);
	}
}

class EarningGrowth {
	final String month;
	final int amount;

	EarningGrowth({required this.month, required this.amount});

	factory EarningGrowth.fromJson(Map<String, dynamic> json) {
		return EarningGrowth(
			month: json['month'] ?? '',
			amount: json['amount'] ?? 0,
		);
	}
}

class CustomerGrowth {
	final String month;
	final int count;

	CustomerGrowth({required this.month, required this.count});

	factory CustomerGrowth.fromJson(Map<String, dynamic> json) {
		return CustomerGrowth(
			month: json['month'] ?? '',
			count: json['count'] ?? 0,
		);
	}
}
