import 'package:flutter/material.dart';
import '../services/api_service.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  StatusScreenState createState() => StatusScreenState();
}

class StatusScreenState extends State<StatusScreen> {
  String internalState = '...';
  String externalState = '...';
  String modeState = '...';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final internal = await ApiService.getInternalState();
    final external = await ApiService.getExternalState();
    final mode = await ApiService.getModeState();

    setState(() {
      internalState = internal;
      externalState = external;
      modeState = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('États')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StatusTile(label: 'Lampes internes', state: internalState),
          StatusTile(label: 'Lampes externes', state: externalState),
          StatusTile(label: 'Mode', state: modeState),
        ],
      ),
    );
  }
}

class StatusTile extends StatelessWidget {
  final String label;
  final String state;

  const StatusTile({super.key, required this.label, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing:
          Text(state, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
