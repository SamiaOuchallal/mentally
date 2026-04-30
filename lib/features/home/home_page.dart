import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/app_scaffold.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentally/features/home/mood_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? _indexHumeur;
  final TextEditingController _noteController = TextEditingController();
  final List<XFile> _photosChoisies = [];
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> _listeEmojis = [
    {'image': 'super.png', 'label': 'Super', 'color': const Color(0xFFF4BC69)},
    {'image': 'bien.png', 'label': 'Bien', 'color': const Color(0xFFF6D178)},
    {
      'image': 'neutre.png',
      'label': 'Neutre',
      'color': const Color(0xFFF4DEA2),
    },
    {
      'image': 'pasouf.png',
      'label': 'Pas top',
      'color': const Color(0xFF91CDD6),
    },
    {'image': 'mal.png', 'label': 'Mal', 'color': const Color(0xFF6B99A9)},
  ];

  Future<void> _pickImages() async {
    if (_photosChoisies.length >= 5) return;

    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isEmpty) return;

    setState(() {
      final int remaining = 5 - _photosChoisies.length;
      _photosChoisies.addAll(images.take(remaining));
    });
  }

  Future<void> _saveMood() async {
    if (_indexHumeur == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Choisissez une humeur")));
      return;
    }

    // Nettoyage des chemins photos
    final photosPaths = _photosChoisies
        .map((p) => p.path)
        .where((p) => p != null && p.isNotEmpty)
        .toList();

    final service = MoodService();

    await service.saveMood(
      moodIndex: _indexHumeur!,
      note: _noteController.text,
      photos: photosPaths,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Humeur enregistrée !")));
  }

  void _supprimerPhoto(int index) {
    setState(() {
      _photosChoisies.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color couleurActuelle = _indexHumeur != null
        ? _listeEmojis[_indexHumeur!]['color'] as Color
        : Colors.white;

    return AppScaffold(
      title: "Aujourd’hui",
      currentIndex: 0,
      onTabSelected: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/progress');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/calendar');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/videos');
            break;
          case 4:
            Navigator.pushReplacementNamed(context, '/settings');
            break;
        }
      },
      body: Container(
        color: couleurActuelle,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              const Text(
                "Comment vous sentez-vous\naujourd’hui ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF000010),
                  height: 1.15,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 30),

              // --- Emojis ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_listeEmojis.length, (index) {
                  final emoji = _listeEmojis[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _indexHumeur = index;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _indexHumeur == index
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Image.asset(
                            "assets/emojis/${emoji['image']}",
                            width: 50,
                            height: 50,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(emoji['label']),
                      ],
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30),

              // --- Champ texte ---
              TextField(
                controller: _noteController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Écrivez quelque chose...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- Bouton photos ---
              ElevatedButton(
                onPressed: _pickImages,
                child: const Text("Ajouter des photos"),
              ),

              const SizedBox(height: 20),

              // --- Photos choisies ---
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(_photosChoisies.length, (index) {
                  final photo = _photosChoisies[index];
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: kIsWeb
                            ? Image.network(photo.path, width: 100, height: 100)
                            : Image.file(
                                File(photo.path),
                                width: 100,
                                height: 100,
                              ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () => _supprimerPhoto(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _saveMood,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Enregistrer mon humeur"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
