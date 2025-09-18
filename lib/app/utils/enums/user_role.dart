enum UserRole { user, owner, barber }

UserRole getRoleFromString(String role) {
  final normalized = role.toUpperCase();

  if (normalized=="SALOON_OWNER") {
    return UserRole.owner;
  }
  if (normalized=="BARBER") {
    return UserRole.barber;
  }
  // treat customer/client/user as UserRole.user
  if (normalized=="CUSTOMER") {
    return UserRole.user; 
  }

  return UserRole.user;
}

/// Convert a local [UserRole] into the API expected role string.
String apiRoleFromUserRole(UserRole role) {
  switch (role) {
    case UserRole.owner:
      return 'SALOON_OWNER';
    case UserRole.barber:
      return 'BARBER';
    case UserRole.user:
      return 'CUSTOMER';
  }
}