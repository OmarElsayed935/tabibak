import 'package:flutter_riverpod/legacy.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

enum UserRole { doctor, patient }

class AppUser {
  final String id;
  final String name;
  final UserRole role;
  final String? specialty;
  final String? license;
  const AppUser({
    required this.id,
    required this.name,
    required this.role,
    this.specialty,
    this.license,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role.name,
        'specialty': specialty,
        'license': license,
      };

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
        id: j['id'],
        name: j['name'],
        role: UserRole.values.byName(j['role']),
        specialty: j['specialty'],
        license: j['license'],
      );
}

class AuthRepository {
  final SharedPreferences prefs;
  AuthRepository(this.prefs);
  static const _key = 'current_user';

  AppUser? get() {
    final raw = prefs.getString(_key);
    return raw == null ? null : AppUser.fromJson(jsonDecode(raw));
  }

  Future<void> set(AppUser u) => prefs.setString(_key, jsonEncode(u.toJson()));
  Future<void> clear() => prefs.remove(_key);
}

final authRepoProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(prefsProvider)),
);

final currentUserProvider =
    StateProvider<AppUser?>((ref) => ref.watch(authRepoProvider).get());