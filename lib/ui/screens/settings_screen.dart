import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/storage_service.dart';
import '../../services/audio_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _soundEnabled;
  late bool _musicEnabled;

  @override
  void initState() {
    super.initState();
    final storage = Provider.of<StorageService>(context, listen: false);
    _soundEnabled = storage.soundEnabled;
    _musicEnabled = storage.musicEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<StorageService>(context, listen: false);
    final audio = AudioService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF1A1A2E),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SettingsTile(
              title: 'Sound Effects',
              subtitle: 'Enable game sound effects',
              value: _soundEnabled,
              onChanged: (value) async {
                setState(() => _soundEnabled = value);
                await storage.setSoundEnabled(value);
                audio.setSoundEnabled(value);
              },
            ),
            _SettingsTile(
              title: 'Music',
              subtitle: 'Enable background music',
              value: _musicEnabled,
              onChanged: (value) async {
                setState(() => _musicEnabled = value);
                await storage.setMusicEnabled(value);
                audio.setMusicEnabled(value);
              },
            ),
            const SizedBox(height: 32),
            const _SectionHeader(title: 'About'),
            ListTile(
              title: const Text('Version', style: TextStyle(color: Colors.white)),
              subtitle: const Text('1.0.0', style: TextStyle(color: Colors.white54)),
            ),
            ListTile(
              title: const Text('Credits', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Made with GameFactory', style: TextStyle(color: Colors.white54)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.deepPurple,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
