import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataManagementPage extends StatelessWidget {
  const DataManagementPage({super.key});

  Future<void> _clearAllData(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Toutes les données ont été supprimées")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      appBar: AppBar(title: const Text("Données personnelles")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Gestion des données",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              title: Text(
                "Réinitialiser l’application",
                style: TextStyle(color: textColor),
              ),
              subtitle: Text(
                "Supprime toutes les données enregistrées localement",
                style: TextStyle(color: textColor?.withOpacity(0.7)),
              ),
              trailing: const Icon(Icons.delete_forever, color: Colors.red),
              onTap: () => _clearAllData(context),
            ),
          ],
        ),
      ),
    );
  }
}
