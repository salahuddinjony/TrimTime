import 'package:barber_time/app/utils/enums/user_role.dart';

enum AuthenticatorType {
  user,
  barber,
  owner,
}

abstract class AuthenticatorNames {

  static const Map<AuthenticatorType, String> names = {
    AuthenticatorType.user: 'Customer',
    AuthenticatorType.barber: 'Barber',
    AuthenticatorType.owner: 'Owner',
  };

  // Map UserRole to AuthenticatorType
  static AuthenticatorType? fromUserRole(UserRole? userRole) {
    switch (userRole) {
      case UserRole.user:
        return AuthenticatorType.user;
      case UserRole.barber:
        return AuthenticatorType.barber;
      case UserRole.owner:
        return AuthenticatorType.owner;
      default:
        return null;
    }
  }

  // Get display name directly from UserRole
  static String displayNameFromUserRole(UserRole? userRole) {
    final type = fromUserRole(userRole);
    return names[type] ?? "No Role";
  }
}
