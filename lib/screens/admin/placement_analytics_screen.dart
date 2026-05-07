import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class PlacementAnalyticsScreen extends StatefulWidget {
  const PlacementAnalyticsScreen({super.key});

  @override
  State<PlacementAnalyticsScreen> createState() =>
      _PlacementAnalyticsScreenState();
}

class _PlacementAnalyticsScreenState extends State<PlacementAnalyticsScreen> {
  String selectedYear = "All";
  String selectedBranch = "All";
  int touchedPieIndex = -1;

  // Color palette
  static const Color placedColor = Color(0xFF00C896);
  static const Color internColor = Color(0xFF4B8EF1);
  static const Color notPlacedColor = Color(0xFFFF5C6C);
  static const Color bgColor = Color(0xFFF0F4FA);
  static const Color cardColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "Placement Analytics",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('placement_stats')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allDocs = snapshot.data!.docs;

          // Static filter lists — matches PlacementFormScreen options
          const years = [
            "All",
            "First Year",
            "Second Year",
            "Third Year",
            "Fourth Year",
          ];
          const branches = [
            "All",
            "COMP",
            "IT",
            "ENTC",
            "MECH",
            "INSTRU",
          ];

          // Apply filters
          final data = allDocs.where((d) {
            final matchYear =
                selectedYear == "All" || d['year'] == selectedYear;
            final matchBranch =
                selectedBranch == "All" || d['branch'] == selectedBranch;
            return matchYear && matchBranch;
          }).toList();

          int placed = 0, internship = 0, notPlaced = 0;
          for (var d in data) {
            final s = d['status'];
            if (s == "Placed") placed++;
            else if (s == "Internship") internship++;
            else notPlaced++;
          }

          final total = data.length;

          double pct(int val) =>
              total == 0 ? 0 : (val / total * 100);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── FILTER ROW ──────────────────────────────────────────
                _FilterCard(
                  years: years,
                  branches: branches,
                  selectedYear: selectedYear,
                  selectedBranch: selectedBranch,
                  onYearChanged: (v) => setState(() => selectedYear = v!),
                  onBranchChanged: (v) => setState(() => selectedBranch = v!),
                ),

                const SizedBox(height: 16),

                // ── SUMMARY CARDS ────────────────────────────────────────
                Row(
                  children: [
                    _StatCard(
                      label: "Total",
                      value: total.toString(),
                      color: const Color(0xFF6C63FF),
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      label: "Placed",
                      value: placed.toString(),
                      color: placedColor,
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      label: "Intern",
                      value: internship.toString(),
                      color: internColor,
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      label: "Not Placed",
                      value: notPlaced.toString(),
                      color: notPlacedColor,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── PIE CHART ────────────────────────────────────────────
                _ChartCard(
                  title: "Status Distribution",
                  subtitle: "Tap a slice to see details",
                  child: total == 0
                      ? const _EmptyChart()
                      : Column(
                    children: [
                      SizedBox(
                        height: 240,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback: (event, response) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          response == null ||
                                          response.touchedSection == null) {
                                        touchedPieIndex = -1;
                                      } else {
                                        touchedPieIndex = response
                                            .touchedSection!
                                            .touchedSectionIndex;
                                      }
                                    });
                                  },
                                ),
                                sectionsSpace: 3,
                                centerSpaceRadius: 60,
                                sections: _buildPieSections(
                                  placed,
                                  internship,
                                  notPlaced,
                                  total,
                                  touchedPieIndex,
                                  pct,
                                ),
                              ),
                            ),
                            // Center label
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  total.toString(),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const Text(
                                  "Students",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Legend
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _LegendDot(color: placedColor, label: "Placed"),
                          const SizedBox(width: 16),
                          _LegendDot(color: internColor, label: "Internship"),
                          const SizedBox(width: 16),
                          _LegendDot(
                              color: notPlacedColor, label: "Not Placed"),
                        ],
                      ),
                      // Tooltip detail when touched
                      if (touchedPieIndex >= 0)
                        _PieTooltip(
                          index: touchedPieIndex,
                          placed: placed,
                          internship: internship,
                          notPlaced: notPlaced,
                          total: total,
                          pct: pct,
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── BAR CHART ────────────────────────────────────────────
                _ChartCard(
                  title: "Placement Comparison",
                  subtitle: "Students by status",
                  child: total == 0
                      ? const _EmptyChart()
                      : SizedBox(
                    height: 280,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceEvenly,
                        maxY: ([placed, internship, notPlaced]
                            .reduce((a, b) => a > b ? a : b)
                            .toDouble() +
                            3)
                            .ceilToDouble(),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 1,
                          getDrawingHorizontalLine: (_) => FlLine(
                            color: Colors.grey.shade200,
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              interval: 1,
                              getTitlesWidget: (value, meta) => Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                final labels = [
                                  ("Placed", placedColor),
                                  ("Internship", internColor),
                                  ("Not Placed", notPlacedColor),
                                ];
                                final i = value.toInt();
                                if (i < 0 || i >= labels.length) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding:
                                  const EdgeInsets.only(top: 8),
                                  child: Text(
                                    labels[i].$1,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: labels[i].$2,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: const Color(0xFF1E293B),
                            tooltipPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            tooltipMargin: 8,
                            getTooltipItem:
                                (group, groupIndex, rod, rodIndex) {
                              final labels = [
                                "Placed",
                                "Internship",
                                "Not Placed"
                              ];
                              final count = rod.toY.toInt();
                              final p = total == 0
                                  ? 0
                                  : (count / total * 100)
                                  .toStringAsFixed(1);
                              return BarTooltipItem(
                                "${labels[group.x]}\n",
                                const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  TextSpan(
                                    text: "$count students ($p%)",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        barGroups: [
                          _buildBar(0, placed.toDouble(), placedColor),
                          _buildBar(
                              1, internship.toDouble(), internColor),
                          _buildBar(
                              2, notPlaced.toDouble(), notPlacedColor),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections(
      int placed,
      int internship,
      int notPlaced,
      int total,
      int touchedIndex,
      double Function(int) pct,
      ) {
    final items = [
      (placed, placedColor, "Placed"),
      (internship, internColor, "Intern"),
      (notPlaced, notPlacedColor, "Not Placed"),
    ];

    return List.generate(items.length, (i) {
      final isTouched = i == touchedIndex;
      final val = items[i].$1;
      final color = items[i].$2;
      final p = pct(val).toStringAsFixed(1);
      return PieChartSectionData(
        value: val.toDouble(),
        color: color,
        radius: isTouched ? 80 : 65,
        title: isTouched ? "$p%" : "${pct(val).toStringAsFixed(0)}%",
        titleStyle: TextStyle(
          fontSize: isTouched ? 14 : 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black26, blurRadius: 4)],
        ),
        badgeWidget: isTouched
            ? Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
        )
            : null,
        badgePositionPercentageOffset: 1.2,
      );
    });
  }

  BarChartGroupData _buildBar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 36,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.55),
              color,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: color.withOpacity(0.05),
          ),
        ),
      ],
    );
  }
}

// ── WIDGETS ─────────────────────────────────────────────────────────────────

class _FilterCard extends StatelessWidget {
  final List<String> years;
  final List<String> branches;
  final String selectedYear;
  final String selectedBranch;
  final ValueChanged<String?> onYearChanged;
  final ValueChanged<String?> onBranchChanged;

  const _FilterCard({
    required this.years,
    required this.branches,
    required this.selectedYear,
    required this.selectedBranch,
    required this.onYearChanged,
    required this.onBranchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_list_rounded,
              size: 18, color: Color(0xFF6C63FF)),
          const SizedBox(width: 8),
          const Text(
            "Filters",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _DropFilter(
              value: selectedYear,
              items: years,
              hint: "Year",
              onChanged: onYearChanged,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _DropFilter(
              value: selectedBranch,
              items: branches,
              hint: "Branch",
              onChanged: onBranchChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _DropFilter extends StatelessWidget {
  final String value;
  final List<String> items;
  final String hint;
  final ValueChanged<String?> onChanged;

  const _DropFilter({
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD0CCFF)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          style: const TextStyle(
              fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              size: 18, color: Color(0xFF6C63FF)),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10,
                  color: color.withOpacity(0.8),
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _ChartCard(
      {required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          Text(subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}

class _PieTooltip extends StatelessWidget {
  final int index;
  final int placed;
  final int internship;
  final int notPlaced;
  final int total;
  final double Function(int) pct;

  const _PieTooltip({
    required this.index,
    required this.placed,
    required this.internship,
    required this.notPlaced,
    required this.total,
    required this.pct,
  });

  @override
  Widget build(BuildContext context) {
    final info = [
      (
      "Placed",
      placed,
      _PlacementAnalyticsScreenState.placedColor
      ),
      (
      "Internship",
      internship,
      _PlacementAnalyticsScreenState.internColor
      ),
      (
      "Not Placed",
      notPlaced,
      _PlacementAnalyticsScreenState.notPlacedColor
      ),
    ];

    if (index < 0 || index >= info.length) return const SizedBox.shrink();
    final item = info[index];
    final p = pct(item.$2).toStringAsFixed(1);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: item.$3.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: item.$3.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration:
            BoxDecoration(color: item.$3, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: "${item.$1}: ",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: item.$3,
                      fontSize: 13),
                ),
                TextSpan(
                  text: "${item.$2} students ($p% of total)",
                  style: const TextStyle(
                      color: Colors.black87, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyChart extends StatelessWidget {
  const _EmptyChart();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 120,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart_rounded, size: 40, color: Colors.grey),
            SizedBox(height: 8),
            Text("No data for selected filters",
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}