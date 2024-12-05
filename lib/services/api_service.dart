import 'dart:convert';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
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

  /// Affiche un toast en cas d'erreur
  static void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF444444),
      textColor: const Color(0xFFFFFFFF),
    );
  }

  /// Passe en mode auto
  static Future<void> setModeAuto() async {
    try {
      final baseUrl = await _getBaseUrl();
      await http.get(Uri.parse('$baseUrl/mode/auto'));
    } catch (e) {
      _showErrorToast("Erreur : Impossible de passer en mode auto.");
    }
  }

  /// Passe en mode manuel
  static Future<void> setModeManual() async {
    try {
      final baseUrl = await _getBaseUrl();
      await http.get(Uri.parse('$baseUrl/mode/manuel'));
    } catch (e) {
      _showErrorToast("Erreur : Impossible de passer en mode manuel.");
    }
  }

  /// Récupère l'état actuel du mode (auto ou manuel)
  static Future<String> getModeState() async {
    try {
      final baseUrl = await _getBaseUrl();
      final response = await http.get(Uri.parse('$baseUrl/mode/etat'));
      final data = jsonDecode(response.body);
      return data['etat'] ?? 'off';
    } catch (e) {
      _showErrorToast("Erreur : Impossible de récupérer l'état du mode.");
      return 'off'; // Retourne "off" par défaut
    }
  }

  /// Allume les lampes internes
  static Future<void> turnOnInternal() async {
    try {
      final baseUrl = await _getBaseUrl();
      await http.get(Uri.parse('$baseUrl/lamp/in/on'));
    } catch (e) {
      _showErrorToast("Erreur : Impossible d'allumer les lampes internes.");
    }
  }

  /// Éteint les lampes internes
  static Future<void> turnOffInternal() async {
    try {
      final baseUrl = await _getBaseUrl();
      await http.get(Uri.parse('$baseUrl/lamp/in/off'));
    } catch (e) {
      _showErrorToast("Erreur : Impossible d'éteindre les lampes internes.");
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
      _showErrorToast(
          "Erreur : Impossible de récupérer l'état des lampes internes.");
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
      _showErrorToast(
          "Erreur : Impossible de récupérer l'état des lampes externes.");
      return 'off'; // Retourne "off" par défaut
    }
  }
}
