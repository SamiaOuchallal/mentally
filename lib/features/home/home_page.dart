import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../widgets/app_scaffold.dart';
import 'package:mentally/features/home/mood_service.dart';
import 'package:mentally/theme/app_colors.dart';

const String kNotesProgressionKey = 'notes_progression';

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

  final List<String> activities = [
    "J'ai réalisé mes objectifs",
    "J'ai fait du sport",
    "J'ai mangé sainement",
    "J'ai bien dormi",
    "J'ai passé du temps avec mes proches",
    "J'ai fait quelque chose de nouveau",
    "J'ai pris du temps pour moi",
    "J'ai été productif(ve)",
    "J'ai eu une journée stressante",
    "J'ai procrastiné",
    "J'ai mal mangé",
    "J'ai peu dormi",
    "J'ai trop dormi",
  ];

  List<String> selectedActivities = [];

  final List<Map<String, dynamic>> _listeEmojis = [
    {
      'image': 'super.png',
      'label': 'Super',
      'color': const Color(0xFFF4BC69),
      'note': 5.0,
    },
    {
      'image': 'bien.png',
      'label': 'Bien',
      'color': const Color(0xFFF6D178),
      'note': 4.0,
    },
    {
      'image': 'neutre.png',
      'label': 'Neutre',
      'color': const Color(0xFFF4DEA2),
      'note': 3.0,
    },
    {
      'image': 'pasouf.png',
      'label': 'Pas top',
      'color': const Color(0xFF91CDD6),
      'note': 2.0,
    },
    {
      'image': 'mal.png',
      'label': 'Mal',
      'color': const Color(0xFF6B99A9),
      'note': 1.0,
    },
  ];

  String userName = "";

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("user_name") ?? "";
    });
  }

  Future<void> _pickImages() async {
    if (_photosChoisies.length >= 5) return;

    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isEmpty) return;

    setState(() {
      final int remaining = 5 - _photosChoisies.length;
      _photosChoisies.addAll(images.take(remaining));
    });
  }

  Future<void> _sauvegarderNoteHumeur(double note) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(kNotesProgressionKey);
    final List notes = data != null ? jsonDecode(data) : [];

    notes.add({'valeur': note, 'date': DateTime.now().toIso8601String()});

    await prefs.setString(kNotesProgressionKey, jsonEncode(notes));
  }

  Future<void> _saveMood() async {
    if (_indexHumeur == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Choisissez une humeur")));
      return;
    }

    final photosPaths = _photosChoisies
        .map((p) => p.path)
        .where((p) => p.isNotEmpty)
        .toList();

    final service = MoodService();
    await service.saveMood(
      moodIndex: _indexHumeur!,
      note: _noteController.text,
      photos: photosPaths,
      activities: selectedActivities,
    );

    final double noteHumeur = _listeEmojis[_indexHumeur!]['note'] as double;
    await _sauvegarderNoteHumeur(noteHumeur);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Humeur enregistrée !")));

      setState(() {
        _indexHumeur = null;
        _noteController.clear();
        _photosChoisies.clear();
        selectedActivities.clear();
      });
    }
  }

  void _supprimerPhoto(int index) {
    setState(() {
      _photosChoisies.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Mentally",
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
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              Text(
                "Salut $userName, comment tu te sens aujourd’hui ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.primary,
                  height: 1.15,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 30),

              Wrap(
                alignment: WrapAlignment.center,
                spacing: 25,
                runSpacing: 20,
                children: List.generate(_listeEmojis.length, (index) {
                  final emoji = _listeEmojis[index];
                  final isSelected = _indexHumeur == index;

                  return GestureDetector(
                    onTap: () => setState(() => _indexHumeur = index),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? (emoji['color'] as Color)
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: (emoji['color'] as Color)
                                          .withOpacity(0.4),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Image.asset(
                            "assets/emojis/${emoji['image']}",
                            width: 55,
                            height: 55,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          emoji['label'],
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30),

              // CHAMP TEXTE
              TextField(
                controller: _noteController,
                maxLines: 4,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                decoration: InputDecoration(
                  hintText: "Écrivez quelque chose...",
                  hintStyle: TextStyle(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ACTIVITÉS
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  ),
                ),
                child: ExpansionTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Text(
                    selectedActivities.isEmpty
                        ? "Aujourd'hui j'ai..."
                        : "Aujourd'hui j'ai... (${selectedActivities.length})",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  children: activities.map((activity) {
                    return CheckboxListTile(
                      title: Text(activity),
                      value: selectedActivities.contains(activity),
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            selectedActivities.add(activity);
                          } else {
                            selectedActivities.remove(activity);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              // BOUTON PHOTOS
              ElevatedButton(
                onPressed: _pickImages,
                child: const Text("Ajouter des photos"),
              ),

              const SizedBox(height: 20),

              // PHOTOS
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

              // BOUTON ENREGISTRER
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
