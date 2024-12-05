import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actions')),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          children: const [
            ActionButton(
                label: 'Lampes int. ON', action: ApiService.turnOnInternal),
            ActionButton(
                label: 'Lampes int. OFF', action: ApiService.turnOffInternal),
            ActionButton(label: 'Mode Auto', action: ApiService.setModeAuto),
            ActionButton(
                label: 'Mode Manuel', action: ApiService.setModeManual),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final Function action;

  const ActionButton({super.key, required this.label, required this.action});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await action();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$label exécuté !')));
      },
      child: Text(label),
    );
  }
}
