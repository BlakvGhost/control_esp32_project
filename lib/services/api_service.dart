import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static Future<String> _getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('esp32_ip') ?? '192.168.1.1:3333';
  }

  static Future<void> setModeAuto() async {
    final baseUrl = await _getBaseUrl();
    await http.get(Uri.parse('$baseUrl/mode/auto'));
  }

  static Future<void> setModeManual() async {
    final baseUrl = await _getBaseUrl();
    await http.get(Uri.parse('$baseUrl/mode/manuel'));
  }

  static Future<String> getModeState() async {
    final baseUrl = await _getBaseUrl();
    final response = await http.get(Uri.parse('$baseUrl/mode/etat'));
    return response.body;
  }

  static Future<void> turnOnInternal() async {
    final baseUrl = await _getBaseUrl();
    await http.get(Uri.parse('$baseUrl/lamp/in/on'));
  }

  static Future<void> turnOffInternal() async {
    final baseUrl = await _getBaseUrl();
    await http.get(Uri.parse('$baseUrl/lamp/in/off'));
  }

  static Future<String> getInternalState() async {
    final baseUrl = await _getBaseUrl();
    final response = await http.get(Uri.parse('$baseUrl/lamp/in/etat'));
    return response.body;
  }

  static Future<String> getExternalState() async {
    final baseUrl = await _getBaseUrl();
    final response = await http.get(Uri.parse('$baseUrl/lamp/out/etat'));
    return response.body;
  }
}
