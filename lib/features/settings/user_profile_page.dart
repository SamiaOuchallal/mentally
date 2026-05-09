import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilPage extends StatefulWidget {
  const UserProfilPage({super.key});

  @override
  State<UserProfilPage> createState() => _UserProfilPageState();
}

class _UserProfilPageState extends State<UserProfilPage> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  String selectedGender = "none";

  @override
  void initState() {
    super.initState();
    _loadProfil();
  }

  Future<void> _loadProfil() async {
    final prefs = await SharedPreferences.getInstance();

    nameController.text = prefs.getString("user_name") ?? "";
    ageController.text = prefs.getInt("user_age")?.toString() ?? "";
    selectedGender = prefs.getString("user_gender") ?? "none";

    setState(() {});
  }

  Future<void> _saveProfil() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("user_name", nameController.text.trim());
    await prefs.setInt("user_age", int.tryParse(ageController.text) ?? 0);
    await prefs.setString("user_gender", selectedGender);

    Navigator.pop(context); // Retour à la SettingsPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil utilisateur")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // NOM
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nom / Pseudo",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // AGE
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Âge",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // GENRE
            const Text(
              "Genre",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            RadioListTile(
              title: const Text("Femme"),
              value: "femme",
              groupValue: selectedGender,
              onChanged: (value) {
                setState(() => selectedGender = value!);
              },
            ),
            RadioListTile(
              title: const Text("Homme"),
              value: "homme",
              groupValue: selectedGender,
              onChanged: (value) {
                setState(() => selectedGender = value!);
              },
            ),
            RadioListTile(
              title: const Text("Autre"),
              value: "autre",
              groupValue: selectedGender,
              onChanged: (value) {
                setState(() => selectedGender = value!);
              },
            ),
            RadioListTile(
              title: const Text("Préfère ne pas dire"),
              value: "none",
              groupValue: selectedGender,
              onChanged: (value) {
                setState(() => selectedGender = value!);
              },
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _saveProfil,
              child: const Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}
