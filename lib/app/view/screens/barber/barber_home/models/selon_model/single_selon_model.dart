class SingleSaloonModel {
  final String id;
  final String userId;
  final String shopOwnerName;
  final String shopOwnerEmail;
  final String shopOwnerPhone;
  final String shopName;
  final String? shopBio;
  final String shopAddress;
  final List<String> shopImages;
  final bool isVerified;
  final int ratingCount;
  final double avgRating;
  final int followerCount;
  final int followingCount;
  final String? registrationNumber;
  final String shopLogo;
  final List<String> shopVideo;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ServiceModel> services;
  final List<BarberModel> barbers;
  final bool isFollowing;

  SingleSaloonModel({
    required this.id,
    required this.userId,
    required this.shopOwnerName,
    required this.shopOwnerEmail,
    required this.shopOwnerPhone,
    required this.shopName,
    this.shopBio,
    required this.shopAddress,
    required this.shopImages,
    required this.isVerified,
    required this.ratingCount,
    required this.avgRating,
    required this.followerCount,
    required this.followingCount,
    this.registrationNumber,
    required this.shopLogo,
    required this.shopVideo,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.services,
    required this.barbers,
    required this.isFollowing,
  });

  factory SingleSaloonModel.fromJson(Map<String, dynamic> json) {
    // If the API response contains a 'data' key, use it
    final data =
        json.containsKey('data') ? json['data'] as Map<String, dynamic> : json;
    return SingleSaloonModel(
      id: data['id']?.toString() ?? '',
      userId: data['userId']?.toString() ?? '',
      shopOwnerName: data['shopOwnerName']?.toString() ?? '',
      shopOwnerEmail: data['shopOwnerEmail']?.toString() ?? '',
      shopOwnerPhone: data['shopOwnerPhone']?.toString() ?? '',
      shopName: data['shopName']?.toString() ?? '',
      shopBio: data['shopBio']?.toString(),
      shopAddress: data['shopAddress']?.toString() ?? '',
      shopImages: (data['shopImages'] as List?)
              ?.map((e) => e?.toString() ?? '')
              .toList() ??
          [],
      isVerified: data['isVerified'] ?? false,
      ratingCount: data['ratingCount'] ?? 0,
      avgRating: (data['avgRating'] ?? 0).toDouble(),
      followerCount: data['followerCount'] ?? 0,
      followingCount: data['followingCount'] ?? 0,
      registrationNumber: data['registrationNumber']?.toString(),
      shopLogo: data['shopLogo']?.toString() ?? '',
      shopVideo: (data['shopVideo'] as List?)
              ?.map((e) => e?.toString() ?? '')
              .toList() ??
          [],
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'].toString())
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'].toString())
          : DateTime.now(),
      services: (data['services'] as List?)
              ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      barbers: (data['barbers'] as List?)
              ?.map((e) => BarberModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isFollowing: data['isFollowing'] ?? false,
    );
  }
}

class ServiceModel {
  final String id;
  final String serviceName;
  final double price;
  final int duration;
  final bool isActive;

  ServiceModel({
    required this.id,
    required this.serviceName,
    required this.price,
    required this.duration,
    required this.isActive,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id']?.toString() ?? '',
      serviceName: json['serviceName']?.toString() ?? '',
      price: (json['price'] ?? 0).toDouble(),
      duration: json['duration'] ?? 0,
      isActive: json['isActive'] ?? false,
    );
  }
}

class BarberModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String image;
  final String experienceYears;
  final String bio;
  final List<String> portfolio;
  final String? userId; // Added userId field

  BarberModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.image,
    required this.experienceYears,
    required this.bio,
    required this.portfolio,
    this.userId,
  });

  factory BarberModel.fromJson(Map<String, dynamic> json) {
    return BarberModel(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      experienceYears: json['experienceYears']?.toString() ?? '',
      bio: json['bio']?.toString() ?? '',
      portfolio: (json['portfolio'] as List?)
              ?.map((e) => e?.toString() ?? '')
              .toList() ??
          [],
      userId: json['userId']?.toString(),
    );
  }
}
