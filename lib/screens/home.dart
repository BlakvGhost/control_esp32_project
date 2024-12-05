import 'package:control/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentMode = ''; // Mode actif : "auto" ou "manuel"
  String internalLampState = ''; // État des lampes internes : "on" ou "off"
  String externalLampState = ''; // État des lampes externes : "on" ou "off"
  String alarmState = ''; // État de l'alarme : "on" ou "off"
  bool isLoading = false; // Indicateur de chargement

  @override
  void initState() {
    super.initState();
    _fetchStates(); // Charger les états initiaux
  }

  Future<void> _fetchStates() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    // Récupérer les états depuis l'API
    final mode = await ApiService.getModeState();
    final internalLamp = await ApiService.getInternalState();
    final externalLamp = await ApiService.getExternalState();
    final alarm = await ApiService.getAlarmState();

    if (mounted) {
      setState(() {
        currentMode = mode; // "auto" ou "manuel"
        internalLampState = internalLamp; // "on" ou "off"
        externalLampState = externalLamp; // "on" ou "off"
        alarmState = alarm; // "on" ou "off"
        isLoading = false; // Fin du chargement
      });
    }
  }

  void _updateState(Function action, Future<void> Function() fetchState) async {
    if (!mounted) return; // Vérifier si le widget est encore monté

    setState(() {
      isLoading = true; // Afficher le loader lorsque l'on agit
    });

    final res = await action();

    if (!res) {
      const message =
          "Erreur de connexion au serveur, veuillez vérifier ou configurer l'adresse ip et le port de l'ESP32";

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(
                  PhosphorIconsDuotone.info,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(color: AppTheme.whiteColor),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 8,
                  ),
                ),
              ],
            ),
            backgroundColor: Color.fromARGB(255, 114, 29, 22),
          ),
        );
      }
      setState(() {
        isLoading = false; // Masquer le loader lorsque l'on a terminé
      });
    }

    if (mounted && res) {
      await fetchState(); // Appeler fetchState uniquement si le widget est toujours monté
      setState(() {
        isLoading = false; // Masquer le loader lorsque l'on a terminé
      });
    }
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
              "Actions",
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
            onPressed: isLoading ? null : _fetchStates,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bienvenue 👋",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Contrôlez vos appareils rapidement et facilement. Faites un choix ci-dessous !",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Grille des boutons
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              padding: const EdgeInsets.all(16),
              children: [
                ActionButton(
                  label: internalLampState == 'off'
                      ? 'Lampes int. OFF'
                      : 'Lampes int. ON',
                  icon: PhosphorIconsDuotone.lightbulb,
                  isActive: internalLampState == 'on',
                  action: () => _updateState(
                    internalLampState == 'on'
                        ? ApiService.turnOffInternal
                        : ApiService.turnOnInternal,
                    _fetchStates,
                  ),
                ),
                ActionButton(
                  label: externalLampState == 'off'
                      ? 'Lampes ext. OFF'
                      : 'Lampes ext. ON',
                  icon: PhosphorIconsDuotone.lightbulb,
                  isActive: externalLampState == 'on',
                  action: () => _updateState(
                    externalLampState == 'on'
                        ? ApiService.turnOffExternal
                        : ApiService.turnOnExternal,
                    _fetchStates,
                  ),
                ),
                ActionButton(
                  label: alarmState == 'off' ? 'Alarme OFF' : 'Alarme ON',
                  icon: PhosphorIconsDuotone.bell,
                  isActive: alarmState == 'on',
                  action: () => _updateState(
                    alarmState == 'on'
                        ? ApiService.turnOffAlarm
                        : ApiService.turnOnAlarm,
                    _fetchStates,
                  ),
                ),
                ActionButton(
                  label: currentMode == 'manuel' ? 'Mode Manuel' : 'Mode Auto',
                  icon: PhosphorIconsDuotone.gearSix,
                  isActive: currentMode == 'auto',
                  action: () => _updateState(
                    currentMode == 'auto'
                        ? ApiService.setModeManual
                        : ApiService.setModeAuto,
                    _fetchStates,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function action;
  final bool isActive;

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.action,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.green : Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isActive
              ? const BorderSide(color: Colors.green, width: 2)
              : BorderSide.none,
        ),
        padding: const EdgeInsets.all(16),
      ),
      onPressed: () async {
        await action();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: isActive ? Colors.white : Colors.grey[400],
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey[400],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
