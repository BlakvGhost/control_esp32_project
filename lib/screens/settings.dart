import 'package:control/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  TextEditingController ipController = TextEditingController();
  TextEditingController portController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadIp();
  }

  void loadIp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ipController.text = prefs.getString('esp32_ip') ?? '192.168.1.1';
    ipController.text = prefs.getString('esp32_port') ?? '3333';
  }

  void saveIp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('esp32_ip', ipController.text);
    await prefs.setString('esp32_port', portController.text);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('IP et Port sauvegardée !')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: ipController,
              decoration: const InputDecoration(labelText: 'Adresse IP ESP32'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: ipController,
              decoration: const InputDecoration(labelText: 'Port ESP32'),
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(label: 'Enregistrer', onPressed: saveIp)
          ],
        ),
      ),
    );
  }
}
