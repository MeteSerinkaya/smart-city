import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_city/view/authentication/test/model/adminuser/admin_user_model.dart';
import 'package:smart_city/view/authentication/test/model/adminuser/create_admin_user_model.dart';
import 'package:smart_city/core/init/cache/locale_manager.dart';
import 'package:smart_city/core/constants/enums/locale_keys_enum.dart';

class AdminUserService {
  static const String baseUrl = 'https://localhost:7276/api/UserAccount';
  
  // Get all admin users
  Future<List<AdminUserModel>> getAdminUsers() async {
    try {
      // Get JWT token from LocaleManager
      final token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN);
      
      final response = await http.get(
        Uri.parse('$baseUrl/admin-users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add JWT token
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final result = jsonData.map((json) => AdminUserModel.fromJson(json)).toList();
        return result;
      } else {
        throw Exception('Failed to load admin users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching admin users: $e');
    }
  }

  // Get admin user by ID
  Future<AdminUserModel?> getAdminUserById(int id) async {
    try {
      final token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN);
      
      final response = await http.get(
        Uri.parse('$baseUrl/admin-users/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return AdminUserModel.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load admin user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching admin user: $e');
    }
  }

  // Create new admin user
  Future<bool> createAdminUser(CreateAdminUserModel model) async {
    try {
      final token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN);
      
      final response = await http.post(
        Uri.parse('$baseUrl/admin-users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(model.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error creating admin user: $e');
    }
  }

  // Update admin user
  Future<bool> updateAdminUser(int id, CreateAdminUserModel model) async {
    try {
      final token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN);
      
      final response = await http.put(
        Uri.parse('$baseUrl/admin-users/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(model.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error updating admin user: $e');
    }
  }

  // Delete admin user
  Future<bool> deleteAdminUser(int id) async {
    try {
      final token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN);
      
      final response = await http.delete(
        Uri.parse('$baseUrl/admin-users/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error deleting admin user: $e');
    }
  }
}
