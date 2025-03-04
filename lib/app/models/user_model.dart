import 'package:barber_time/app/utils/enums/user_role.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role; // Enum

  UserModel({required this.id, required this.name, required this.email, required this.role});
}
