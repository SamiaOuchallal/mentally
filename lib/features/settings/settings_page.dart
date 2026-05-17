import 'package:flutter/material.dart';
import 'package:mentally/features/settings/user_profile_page.dart';
import '../../../main.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/app_scaffold.dart';
import '../../services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'text_size_page.dart';
import 'package:mentally/services/user_preferences.dart';
import 'stress_level_page.dart';
import 'gestion_data_page.dart';
import 'export_data_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool notificationsEnabled = false;
  int hour = 9;
  int minute = 0;

  String userName = "";
  final userNameNotifier = ValueNotifier<String>("");

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadDarkMode();
    NotificationService().requestPermission();
  }

  Future<void> _loadDarkMode() async {
    _darkMode = await UserPreferences.getDarkMode();
    setState(() {});
  }

  Future<void> _saveTime(int h, int m) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("notification_hour", h);
    await prefs.setInt("notification_minute", m);

    setState(() {
      hour = h;
      minute = m;
    });
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      notificationsEnabled = prefs.getBool("notifications_enabled") ?? false;
      hour = prefs.getInt("notification_hour") ?? 9;
      minute = prefs.getInt("notification_minute") ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(() async {
      final prefs = await SharedPreferences.getInstance();
      userNameNotifier.value = prefs.getString("user_name") ?? "";
    });

    return AppScaffold(
      title: "Paramètres",
      currentIndex: 4,
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
            break;
        }
      },

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          _SectionTitle("Profil utilisateur >"),

          ValueListenableBuilder<String>(
            valueListenable: userNameNotifier,
            builder: (context, value, _) {
              return _SettingsTile(
                title: "Profil utilisateur",
                subtitle: "Nom, âge, genre",
                onTap: () async {
                  final name = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UserProfilPage()),
                  );

                  if (name != null) {
                    userNameNotifier.value = name;
                  }
                },
              );
            },
          ),

          _SettingsTile(
            title: "Niveau de stress (auto‑évaluation)",
            subtitle: "Évaluez votre état actuel",
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StressLevelPage()),
              );

              if (result != null) {
                await UserPreferences.setStressLevel(result);
                setState(() {});
              }
            },
          ),

          const SizedBox(height: 25),

          _SectionTitle("Notifications & rappels >"),
          _SettingsTile(
            title: "Activer les notifications",
            onTap: () {},

            trailing: Switch(
              value: notificationsEnabled,

              onChanged: (value) async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool("notifications_enabled", value);

                setState(() => notificationsEnabled = value);

                if (value) {
                  NotificationService().scheduleDailyReminder(hour, minute);
                } else {
                  NotificationService().cancelAll();
                }
              },
            ),
          ),

          _SettingsTile(
            title: "Horaire du rappel",
            subtitle: "$hour:$minute",
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: hour, minute: minute),
                initialEntryMode: TimePickerEntryMode.dial,
              );

              if (time != null) {
                _saveTime(time.hour, time.minute);
                NotificationService().scheduleDailyReminder(
                  time.hour,
                  time.minute,
                );
              }
            },
          ),

          const SizedBox(height: 25),

          _SectionTitle("Apparence >"),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Mode sombre"),
            trailing: Switch(
              value: _darkMode,
              onChanged: (value) async {
                await UserPreferences.setDarkMode(value);

                setState(() => _darkMode = value);

                // Mise à jour du thème global
                final appState = context
                    .findAncestorStateOfType<MentallyAppState>();
                appState?.toggleDarkMode(value);
              },
            ),
          ),

          _SettingsTile(
            title: "Taille du texte",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TextSizePage()),
              );
            },
          ),

          const SizedBox(height: 25),

          _SectionTitle("Confidentialité & données >"),
          _SettingsTile(
            title: "Export des données",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExportDataPage()),
              );
            },
          ),
          _SettingsTile(
            title: "Gestion des données personnelles",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DataManagementPage()),
              );
            },
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: textColor,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  const _SettingsTile({
    this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 28, color: textColor),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                fontSize: 13,
                color: textColor?.withOpacity(0.7),
              ),
            )
          : null,
      trailing:
          trailing ??
          Icon(Icons.chevron_right, color: textColor?.withOpacity(0.7)),
      onTap: onTap,
    );
  }
}
