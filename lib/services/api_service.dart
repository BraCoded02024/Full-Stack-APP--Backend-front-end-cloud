import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/personnel.dart';

class ApiService {
  // Try both HTTP and HTTPS
  static const String baseUrl = 'http://54.87.45.87:3000/api';
  // static const String baseUrl = 'https://54.87.45.87:3000/api'; // Try this if HTTP fails
  
  // Create new personnel
  Future<bool> createPersonnel(Personnel personnel) async {
    try {
      final payload = {
        'name': personnel.name,
        'number': personnel.number,
        'department': personnel.department,
      };
      
      print('Creating personnel with payload: $payload');
      
      final response = await http.post(
        Uri.parse('$baseUrl/nss'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error creating personnel: $e');
      return false;
    }
  }

  // Get all personnel
  Future<List<Personnel>> getAllPersonnel() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/nss'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Get all response status: ${response.statusCode}');
      print('Get all response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Personnel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching personnel: $e');
      return [];
    }
  }

  // Get single personnel by ID
  Future<Personnel?> getPersonnelById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/nss/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return Personnel.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Error fetching personnel: $e');
      return null;
    }
  }

  // Update personnel
  Future<bool> updatePersonnel(String id, Personnel personnel) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/nss/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(personnel.toJson()),
      );

      print('Update response status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating personnel: $e');
      return false;
    }
  }

  // Delete personnel
  Future<bool> deletePersonnel(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/nss/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Delete response status: ${response.statusCode}');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error deleting personnel: $e');
      return false;
    }
  }
}
