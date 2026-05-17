import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../widgets/app_scaffold.dart';

const String kNotesProgressionKey = 'notes_progression';

class NoteEntry {
  final double valeur;
  final DateTime date;

  NoteEntry({required this.valeur, required this.date});

  factory NoteEntry.fromJson(Map<String, dynamic> json) => NoteEntry(
    valeur: (json['valeur'] as num).toDouble(),
    date: DateTime.parse(json['date']),
  );
}

enum Periode { semaine, mois, an }

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage>
    with WidgetsBindingObserver {
  List<NoteEntry> _toutesLesNotes = [];
  Periode _periode = Periode.semaine;

  @override
  void initState() {
    super.initState();
    // Observer pour détecter quand on revient sur la page
    WidgetsBinding.instance.addObserver(this);
    _chargerNotes();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Se déclenche quand l'app revient au premier plan
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _chargerNotes();
    }
  }

  // Se déclenche quand on navigue vers cette page
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chargerNotes();
  }

  Future<void> _chargerNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(kNotesProgressionKey);
    if (data != null) {
      final List decoded = jsonDecode(data);
      if (mounted) {
        setState(() {
          _toutesLesNotes = decoded.map((e) => NoteEntry.fromJson(e)).toList();
        });
      }
    } else {
      if (mounted) setState(() => _toutesLesNotes = []);
    }
  }

  List<NoteEntry> get _notesFiltrees {
    final now = DateTime.now();
    final debut = switch (_periode) {
      Periode.semaine => now.subtract(const Duration(days: 7)),
      Periode.mois => DateTime(now.year, now.month - 1, now.day),
      Periode.an => DateTime(now.year - 1, now.month, now.day),
    };
    return _toutesLesNotes.where((n) => n.date.isAfter(debut)).toList();
  }

  double get _moyenne {
    final n = _notesFiltrees;
    if (n.isEmpty) return 0;
    return n.map((e) => e.valeur).reduce((a, b) => a + b) / n.length;
  }

  double get _max {
    final n = _notesFiltrees;
    if (n.isEmpty) return 0;
    return n.map((e) => e.valeur).reduce((a, b) => a > b ? a : b);
  }

  double get _min {
    final n = _notesFiltrees;
    if (n.isEmpty) return 0;
    return n.map((e) => e.valeur).reduce((a, b) => a < b ? a : b);
  }

  String _labelDate(DateTime date) => switch (_periode) {
    Periode.semaine => '${date.day}/${date.month}',
    Periode.mois => '${date.day}/${date.month}',
    Periode.an => '${date.month}/${date.year % 100}',
  };

  String _humeurLabel(double val) {
    return switch (val.toInt()) {
      5 => 'Super',
      4 => 'Bien',
      3 => 'Neutre',
      2 => 'Pas top',
      _ => 'Mal',
    };
  }

  Color _humeurColor(double val) {
    return switch (val.toInt()) {
      5 => const Color(0xFFF4BB69),
      4 => const Color(0xFFF3D37C),
      3 => const Color(0xFFF4DEA2),
      2 => const Color(0xFF90CDD6),
      _ => const Color(0xFF6C9AAA),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notes = _notesFiltrees;
    final moy = _moyenne;

    return AppScaffold(
      title: "Progression",
      currentIndex: 1,
      onTabSelected: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/');
            break;
          case 1:
            _chargerNotes();
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
      body: RefreshIndicator(
        onRefresh: _chargerNotes,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Sélecteur de période ─────────
              Row(
                children: [
                  _PeriodeBtn(
                    label: "1 sem.",
                    selected: _periode == Periode.semaine,
                    onTap: () => setState(() => _periode = Periode.semaine),
                  ),
                  const SizedBox(width: 8),
                  _PeriodeBtn(
                    label: "1 mois",
                    selected: _periode == Periode.mois,
                    onTap: () => setState(() => _periode = Periode.mois),
                  ),
                  const SizedBox(width: 8),
                  _PeriodeBtn(
                    label: "1 an",
                    selected: _periode == Periode.an,
                    onTap: () => setState(() => _periode = Periode.an),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Cartes stats ─────────────────
              Row(
                children: [
                  _StatCard(
                    label: "Humeur moy.",
                    value: moy > 0 ? moy.toStringAsFixed(1) : "—",
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  _StatCard(
                    label: "Meilleure",
                    value: _max > 0 ? _max.toStringAsFixed(0) : "—",
                    color: const Color.fromARGB(255, 249, 185, 95),
                  ),
                  const SizedBox(width: 8),
                  _StatCard(
                    label: "Plus basse",
                    value: _min > 0 ? _min.toStringAsFixed(0) : "—",
                    color: const Color.fromARGB(255, 62, 88, 97),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Titre ────────────────────────
              Row(
                children: [
                  Text(
                    "Évolution de l'humeur",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: _chargerNotes,
                    tooltip: "Actualiser",
                  ),
                ],
              ),
              Text(
                "Enregistre ton humeur régulièrement depuis l'accueil pour alimenter ce graphique.",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 12),

              // ── Graphique ────────────────────
              notes.isEmpty
                  ? Container(
                      height: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(" ", style: TextStyle(fontSize: 40)),
                          const SizedBox(height: 8),
                          Text(
                            "Aucune humeur enregistrée\nsur cette période",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: _chargerNotes,
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text("Actualiser"),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 280,
                      child: BarChart(
                        BarChartData(
                          maxY: 5.5,
                          minY: 0,
                          gridData: FlGridData(
                            show: true,
                            horizontalInterval: 1,
                            getDrawingHorizontalLine: (_) => FlLine(
                              color: Colors.grey.withOpacity(0.15),
                              strokeWidth: 1,
                            ),
                            drawVerticalLine: false,
                          ),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                reservedSize: 36,
                                getTitlesWidget: (val, _) {
                                  const images = {
                                    1: 'mal.png',
                                    2: 'pasouf.png',
                                    3: 'neutre.png',
                                    4: 'bien.png',
                                    5: 'super.png',
                                  };
                                  final img = images[val.toInt()];
                                  if (img == null) return const SizedBox();
                                  return Image.asset(
                                    'assets/emojis/$img',
                                    width: 68,
                                    height: 68,
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                getTitlesWidget: (val, _) {
                                  final i = val.toInt();
                                  if (i < 0 || i >= notes.length)
                                    return const SizedBox();
                                  return Text(
                                    _labelDate(notes[i].date),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          extraLinesData: ExtraLinesData(
                            horizontalLines: moy > 0
                                ? [
                                    HorizontalLine(
                                      y: moy,
                                      color: Colors.blue,
                                      strokeWidth: 2,
                                      dashArray: [6, 4],
                                      label: HorizontalLineLabel(
                                        show: true,
                                        alignment: Alignment.topRight,
                                        labelResolver: (_) =>
                                            "Moy. ${moy.toStringAsFixed(1)}",
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ]
                                : [],
                          ),
                          barGroups: notes
                              .asMap()
                              .entries
                              .map(
                                (e) => BarChartGroupData(
                                  x: e.key,
                                  barRods: [
                                    BarChartRodData(
                                      toY: e.value.valeur,
                                      color: _humeurColor(e.value.valeur),
                                      width: 18,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                                "${_labelDate(notes[group.x].date)}\n${_humeurLabel(rod.toY)}",
                                const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

              const SizedBox(height: 16),

              // ── Légende ──────────────────────
              Wrap(
                spacing: 10,
                runSpacing: 6,
                children: [
                  _LegendDot(color: const Color(0xFFF4BB69), label: "Super    ",   image: 'super.png'),
                  _LegendDot(color: const Color(0xFFF3D37C), label: "Bien    ",    image: 'bien.png'),
                  _LegendDot(color: const Color(0xFFF4DEA2), label: "Neutre    ",  image: 'neutre.png'),
                  _LegendDot(color: const Color(0xFF90CDD6), label: "Pas top    ", image: 'pasouf.png'),
                  _LegendDot(color: const Color(0xFF6C9AAA), label: "Mal    ",     image: 'mal.png'),
                                  ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _PeriodeBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _PeriodeBtn({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: color)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final String image;
  const _LegendDot({required this.color, required this.label, required this.image});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Image.asset(
          'assets/emojis/$image',
          width: 32,
          height: 32,
        ),
        const SizedBox(width: 3),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
