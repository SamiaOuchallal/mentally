import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextSizePage extends StatefulWidget {
  const TextSizePage({super.key});

  @override
  State<TextSizePage> createState() => _TextSizePageState();
}

class _TextSizePageState extends State<TextSizePage> {
  String selectedSize = "normal";

  @override
  void initState() {
    super.initState();
    _loadTextSize();
  }

  Future<void> _loadTextSize() async {
    final prefs = await SharedPreferences.getInstance();
    selectedSize = prefs.getString("text_size") ?? "normal";
    setState(() {});
  }

  Future<void> _saveTextSize(String size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("text_size", size);
    setState(() => selectedSize = size);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Taille du texte")),
      body: ListView(
        children: [
          RadioListTile(
            title: const Text("Petit"),
            value: "small",
            groupValue: selectedSize,
            onChanged: (value) => _saveTextSize(value!),
          ),
          RadioListTile(
            title: const Text("Normal"),
            value: "normal",
            groupValue: selectedSize,
            onChanged: (value) => _saveTextSize(value!),
          ),
          RadioListTile(
            title: const Text("Grand"),
            value: "large",
            groupValue: selectedSize,
            onChanged: (value) => _saveTextSize(value!),
          ),
          RadioListTile(
            title: const Text("Très grand"),
            value: "xlarge",
            groupValue: selectedSize,
            onChanged: (value) => _saveTextSize(value!),
          ),
        ],
      ),
    );
  }
}
