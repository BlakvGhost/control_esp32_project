import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  /// Récupère l'URL de base de l'ESP32 à partir des préférences
  static Future<String> _getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ip = prefs.getString('esp32_ip') ?? '192.168.1.1';
    final port = prefs.getString('esp32_port') ?? '3333';
    return 'http://$ip:$port';
  }

  /// Passe en mode auto
  static Future<bool> setModeAuto() async {
    try {
      final baseUrl = await _getBaseUrl();
      await http.get(Uri.parse('$baseUrl/mode/auto'));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Passe en mode manuel
  static Future<bool> setModeManual() async {
    try {
      final baseUrl = await _getBaseUrl();
      await http.get(Uri.parse('$baseUrl/mode/manuel'));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Récupère l'état actuel du mode (auto ou manuel)
  static Future<String> getModeState() async {
    try {
      final baseUrl = await _getBaseUrl();
      final response = await http.get(Uri.parse('$baseUrl/mode/etat'));
      final data = jsonDecode(response.body);
      return data['etat'] ?? 'manuel';
    } catch (e) {
      return 'manuel'; // Retourne "off" par défaut
    }
  }

  /// Allume les lampes internes
  static Future<bool> turnOnInternal() async {
    try {
      final baseUrl = await _getBaseUrl();
      await http.get(Uri.parse('$baseUrl/lamp/in/on'));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Éteint les lampes internes
  static Future<bool> turnOffInternal() async {
    try {
      final baseUrl = await _getBaseUrl();
      await http.get(Uri.parse('$baseUrl/lamp/in/off'));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Allume les lampes externes
  static Future<bool> turnOnExternal() async {
    try {
      final baseUrl = await _getBaseUrl();
      await http.get(Uri.parse('$baseUrl/lamp/out/on'));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Éteint les lampes externes
  static Future<bool> turnOffExternal() async {
    try {
      final baseUrl = await _getBaseUrl();
      await http.get(Uri.parse('$baseUrl/lamp/out/off'));
      return true;
    } catch (e) {
      return false;
    }
  }

  // Allume les lampes externes
  static Future<bool> turnOnAlarm() async {
    try {
      final baseUrl = await _getBaseUrl();
      await http.get(Uri.parse('$baseUrl/lamp/alarm/on'));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Éteint les lampes externes
  static Future<bool> turnOffAlarm() async {
    try {
      final baseUrl = await _getBaseUrl();
      await http.get(Uri.parse('$baseUrl/lamp/alarm/off'));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Récupère l'état des lampes internes
  static Future<String> getInternalState() async {
    try {
      final baseUrl = await _getBaseUrl();
      final response = await http.get(Uri.parse('$baseUrl/lamp/in/etat'));
      final data = jsonDecode(response.body);
      return data['etat'] ?? 'off';
    } catch (e) {
      return 'off'; // Retourne "off" par défaut
    }
  }

  /// Récupère l'état des lampes externes
  static Future<String> getExternalState() async {
    try {
      final baseUrl = await _getBaseUrl();
      final response = await http.get(Uri.parse('$baseUrl/lamp/out/etat'));
      final data = jsonDecode(response.body);
      return data['etat'] ?? 'off';
    } catch (e) {
      return 'off'; // Retourne "off" par défaut
    }
  }

  /// Récupère l'état des alarms
  static Future<String> getAlarmState() async {
    try {
      final baseUrl = await _getBaseUrl();
      final response = await http.get(Uri.parse('$baseUrl/alarm/etat'));
      final data = jsonDecode(response.body);
      return data['etat'] ?? 'off';
    } catch (e) {
      return 'off'; // Retourne "off" par défaut
    }
  }
}
