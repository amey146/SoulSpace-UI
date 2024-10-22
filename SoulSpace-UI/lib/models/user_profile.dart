// File: lib/models/user_profile.dart

import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String phoneNumber;

  @HiveField(3)
  DateTime dateOfBirth;

  @HiveField(4)
  String city;

  UserProfile({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.city,
  });
}
