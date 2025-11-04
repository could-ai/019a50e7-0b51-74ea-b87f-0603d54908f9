import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALHJAMI OpenWrt Config',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WifiConfigScreen(),
    );
  }
}

class WifiConfigScreen extends StatefulWidget {
  const WifiConfigScreen({super.key});

  @override
  State<WifiConfigScreen> createState() => _WifiConfigScreenState();
}

class _WifiConfigScreenState extends State<WifiConfigScreen> {
  final _ssidController = TextEditingController(text: 'ALHJAMI-NET');
  final _passwordController = TextEditingController(text: '12345678');
  bool _obscureText = true;
  String _selectedEncryption = 'psk2'; // Default based on user config

  final List<Map<String, String>> _encryptionOptions = [
    {'value': 'none', 'label': 'None (Open)'},
    {'value': 'psk2', 'label': 'WPA2-PSK'},
    {'value': 'sae', 'label': 'WPA3-SAE'},
    {'value': 'sae-mixed', 'label': 'WPA2-PSK/WPA3-SAE Mixed'},
  ];

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _saveSettings() {
    final ssid = _ssidController.text;
    final password = _passwordController.text;
    final encryption = _encryptionOptions.firstWhere((e) => e['value'] == _selectedEncryption)['label'];
    
    // In a real app, you would send this to the router.
    // For this demo, we'll just show a snackbar.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings Saved: SSID=$ssid, Encryption=$encryption, Password=$password'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ALHJAMI OpenWrt'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'ALHJAMI',
                style: TextStyle(
                  fontSize: 32, 
                  fontWeight: FontWeight.bold, 
                  color: Theme.of(context).colorScheme.primary
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                'نسخة مخصصة من OpenWrt', // "A custom version of OpenWrt"
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text(
                'WiFi Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const Divider(),
              const SizedBox(height: 16),
              TextField(
                controller: _ssidController,
                decoration: const InputDecoration(
                  labelText: 'SSID (Network Name)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.wifi),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedEncryption,
                decoration: const InputDecoration(
                  labelText: 'Encryption',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shield_outlined),
                ),
                items: _encryptionOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option['value']!,
                    child: Text(option['label']!),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedEncryption = newValue!;
                    if (_selectedEncryption == 'none') {
                      _passwordController.clear();
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                enabled: _selectedEncryption != 'none',
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _saveSettings,
                icon: const Icon(Icons.save),
                label: const Text('Save Settings'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
