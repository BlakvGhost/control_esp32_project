import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../services/api_service.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  StatusScreenState createState() => StatusScreenState();
}

class StatusScreenState extends State<StatusScreen> {
  String internalState = 'off';
  String externalState = 'off';
  String modeState = 'manuel';
  String alarmState = 'off';
  bool isLoading = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    fetchData();
    startRealTimeUpdates();
  }

  void startRealTimeUpdates() {
    // Simule les mises à jour en temps réel toutes les 5 secondes
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      fetchData(showLoader: false); // Rafraîchit les données
    });
  }

  Future<void> fetchData({bool showLoader = true}) async {
    if (!mounted) return;

    if (showLoader) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final internal = await ApiService.getInternalState();
      final external = await ApiService.getExternalState();
      final mode = await ApiService.getModeState();
      final alarm = await ApiService
          .getAlarmState(); // Nouvelle méthode pour récupérer l'état des alarmes

      if (mounted) {
        setState(() {
          internalState = internal;
          externalState = external;
          modeState = mode;
          alarmState = alarm;
          if (showLoader) isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la récupération des états : $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Arrêter le timer lorsque le widget est démonté
    super.dispose();
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
              "États des systèmes",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
        elevation: 22,
        toolbarHeight: 80,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Icon(
                    PhosphorIconsDuotone.arrowCounterClockwise,
                  ),
            onPressed: isLoading ? null : fetchData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Statut des systèmes connectés',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  StatusTile(
                    label: 'Lampes internes',
                    state: internalState,
                    icon: PhosphorIconsDuotone.lightbulb,
                  ),
                  StatusTile(
                    label: 'Lampes externes',
                    state: externalState,
                    icon: PhosphorIcons.lightbulbFilament(),
                  ),
                  StatusTile(
                    label: 'Mode',
                    state: modeState,
                    icon: PhosphorIconsDuotone.gear,
                  ),
                  StatusTile(
                    label: 'Alarmes',
                    state: alarmState,
                    icon: PhosphorIconsDuotone.bell,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusTile extends StatelessWidget {
  final String label;
  final String state;
  final IconData icon;

  const StatusTile({
    super.key,
    required this.label,
    required this.state,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color stateColor = state == 'on' ? Colors.green : Colors.red;

    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: stateColor),
        title: Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        trailing: Text(
          state.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: stateColor,
          ),
        ),
      ),
    );
  }
}
