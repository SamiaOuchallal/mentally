import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mentally/services/user_preferences.dart';

class ExportDataPage extends StatefulWidget {
  const ExportDataPage({super.key});

  @override
  State<ExportDataPage> createState() => _ExportDataPageState();
}

class _ExportDataPageState extends State<ExportDataPage> {
  String status = "Prêt à exporter";

  Future<void> exportData() async {
    setState(() => status = "Récupération des données...");

    final name = await UserPreferences.getUserName();
    final age = await UserPreferences.getUserAge();
    final gender = await UserPreferences.getUserGender();
    final stress = await UserPreferences.getStressLevel();

    final data = {
      "user": {"name": name, "age": age, "gender": gender},
      "stress_level": stress,
      "exported_at": DateTime.now().toIso8601String(),
    };

    final jsonString = const JsonEncoder.withIndent("  ").convert(data);

    setState(() => status = "Création du fichier...");

    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/mentally_export.json");

    await file.writeAsString(jsonString);

    setState(() => status = "Fichier prêt !");

    await Share.shareXFiles([XFile(file.path)], text: "Export Mentally");
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      appBar: AppBar(title: const Text("Export des données")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(status, style: TextStyle(fontSize: 16, color: textColor)),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: exportData,
                child: const Text("Exporter mes données"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
