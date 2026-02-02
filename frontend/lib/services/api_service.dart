import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/motor_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.92.151.113:8000/api';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Map<String, String> _headers(String? token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: _headers(null),
        body: jsonEncode({'email': email, 'password': password}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': false, 'data': 'Koneksi Error: $e'};
    }
  }

  Future<Map<String, dynamic>> register(String nama, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: _headers(null),
        body: jsonEncode({'nama': nama, 'email': email, 'password': password}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'status': false, 'data': 'Koneksi Error: $e'};
    }
  }

  Future<List<Motor>> getMotors() async {
    final token = await getToken();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/motor'),
        headers: _headers(token),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == true) {
          List<dynamic> data = json['data'];
          return data.map((e) => Motor.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> addMotor(String id, String nama, String stok, String harga) async {
    final token = await getToken();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/motor'),
        headers: _headers(token),
        body: jsonEncode({
          'idmotor': id,
          'nama': nama,
          'stok': int.tryParse(stok) ?? 0,
          'harga': double.tryParse(harga) ?? 0,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateMotor(String id, String nama, String stok, String harga) async {
    final token = await getToken();
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/motor/$id'),
        headers: _headers(token),
        body: jsonEncode({
          'nama': nama,
          'stok': int.tryParse(stok) ?? 0,
          'harga': double.tryParse(harga) ?? 0,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteMotor(String id) async {
    final token = await getToken();
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/motor/$id'),
        headers: _headers(token),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}