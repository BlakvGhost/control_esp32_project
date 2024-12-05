import 'package:control/themes/app_theme.dart';
import 'package:control/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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
    portController.text = prefs.getString('esp32_port') ?? '3333';
  }

  void saveIp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('esp32_ip', ipController.text);
    await prefs.setString('esp32_port', portController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(
              PhosphorIconsDuotone.checkCircle,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'IP et Port sauvegardée !',
                style: TextStyle(color: AppTheme.whiteColor),
                overflow: TextOverflow.ellipsis,
                maxLines: 8,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "EFTP_2024_LTN",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Configuration",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
        elevation: 22,
        toolbarHeight: 80,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          children: [
            TextField(
              controller: ipController,
              decoration: const InputDecoration(labelText: 'Adresse IP ESP32'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: portController,
              decoration: const InputDecoration(labelText: 'Port ESP32'),
            ),
            const SizedBox(height: 40),
            CustomElevatedButton(label: 'Enregistrer', onPressed: saveIp)
          ],
        ),
      ),
    );
  }
}
