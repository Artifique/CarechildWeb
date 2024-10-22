import 'package:flutter/material.dart';

class ParametrePage extends StatefulWidget {
  const ParametrePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ParametrePageState createState() => _ParametrePageState();
}

class _ParametrePageState extends State<ParametrePage> {
  final _appNameController = TextEditingController();
  bool _forcePasswordReset = false;
  bool _twoFactorAuth = false;
  bool _emailNotifications = false;
  bool _pushNotifications = false;
  String _fontSize = 'medium';
  bool _highContrast = false;
  final _googleApiKeyController = TextEditingController();
  final _firebaseApiKeyController = TextEditingController();

  @override
  void dispose() {
    _appNameController.dispose();
    _googleApiKeyController.dispose();
    _firebaseApiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildSection(
              title: 'Paramètres de l\'Application',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: _appNameController,
                    label: 'Nom de l\'application',
                    obscureText: false,
                  ),
                  _buildFilePicker(label: 'Logo de l\'application'),
                  _buildButton(label: 'Sauvegarder', onPressed: () {
                    // Save app settings
                  }),
                ],
              ),
            ),
            _buildSection(
              title: 'Sécurité',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCheckbox(
                    value: _forcePasswordReset,
                    onChanged: (value) {
                      setState(() {
                        _forcePasswordReset = value!;
                      });
                    },
                    label: 'Forcer la réinitialisation des mots de passe',
                  ),
                  _buildCheckbox(
                    value: _twoFactorAuth,
                    onChanged: (value) {
                      setState(() {
                        _twoFactorAuth = value!;
                      });
                    },
                    label: 'Activer l\'authentification à deux facteurs',
                  ),
                  _buildButton(label: 'Sauvegarder', onPressed: () {
                    // Save security settings
                  }),
                ],
              ),
            ),
            _buildSection(
              title: 'Notifications',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCheckbox(
                    value: _emailNotifications,
                    onChanged: (value) {
                      setState(() {
                        _emailNotifications = value!;
                      });
                    },
                    label: 'Activer les notifications par email',
                  ),
                  _buildCheckbox(
                    value: _pushNotifications,
                    onChanged: (value) {
                      setState(() {
                        _pushNotifications = value!;
                      });
                    },
                    label: 'Activer les notifications push',
                  ),
                  _buildButton(label: 'Sauvegarder', onPressed: () {
                    // Save notification settings
                  }),
                ],
              ),
            ),
            _buildSection(
              title: 'Accessibilité',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdown(
                    value: _fontSize,
                    onChanged: (value) {
                      setState(() {
                        _fontSize = value!;
                      });
                    },
                    items: [
                      'Petite',
                      'Moyenne',
                      'Grande',
                    ],
                    label: 'Taille de police par défaut',
                  ),
                  _buildCheckbox(
                    value: _highContrast,
                    onChanged: (value) {
                      setState(() {
                        _highContrast = value!;
                      });
                    },
                    label: 'Activer le contraste élevé',
                  ),
                  _buildButton(label: 'Sauvegarder', onPressed: () {
                    // Save accessibility settings
                  }),
                ],
              ),
            ),
            _buildSection(
              title: 'Paramètres API',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: _googleApiKeyController,
                    label: 'Clé API Google Maps',
                    obscureText: false,
                  ),
                  _buildTextField(
                    controller: _firebaseApiKeyController,
                    label: 'Clé API Firebase',
                    obscureText: false,
                  ),
                  _buildButton(label: 'Sauvegarder', onPressed: () {
                    // Save API settings
                  }),
                ],
              ),
            ),
            _buildSection(
              title: 'Comptes et Utilisateurs',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildButton(label: 'Gérer les utilisateurs', onPressed: () {
                    // Manage users
                  }),
                  _buildButton(label: 'Exporter les données utilisateurs', onPressed: () {
                    // Export user data
                  }),
                ],
              ),
            ),
            _buildSection(
              title: 'Sauvegarde et Récupération',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildButton(label: 'Sauvegarder les données', onPressed: () {
                    // Backup data
                  }),
                  _buildButton(label: 'Restaurer les données', onPressed: () {
                    // Restore data
                  }),
                ],
              ),
            ),
            _buildSection(
              title: 'Journal d\'Activités',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Dernières actions administratives :'),
                  // Example logs, replace with actual logs
                  for (var log in ['Action 1', 'Action 2']) Text('• $log'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8.0)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(height: 15.0),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        obscureText: obscureText,
      ),
    );
  }

  Widget _buildFilePicker({required String label}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          ElevatedButton(
            onPressed: () {
              // Implement file picker logic
            },
            child: const Text('Choisir fichier'),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          Checkbox(value: value, onChanged: onChanged),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
    required List<String> items,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: DropdownButtonFormField<String>(
        value: value.isNotEmpty ? value : null, // Ensure value is valid
        onChanged: onChanged,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildButton({required String label, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
          textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        child: Text(label),
      ),
    );
  }
}
