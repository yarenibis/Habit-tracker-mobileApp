import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';

class WeeklyMoodChart extends StatefulWidget {
  const WeeklyMoodChart({super.key});

  @override
  State<WeeklyMoodChart> createState() => _WeeklyMoodChartState();
}

class _WeeklyMoodChartState extends State<WeeklyMoodChart> {
  List<Map<String, dynamic>> _moods = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMoodData();
  }

  Future<void> _loadMoodData() async {
    try {
      final data = await DatabaseHelper.instance.getLast7DaysMood();
      setState(() {
        _moods = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  String _dayName(String date) {
    final d = DateTime.parse(date);
    const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cts', 'Paz'];
    return days[d.weekday - 1];
  }

  String _formatDate(String date) {
    final d = DateTime.parse(date);
    return DateFormat('dd/MM').format(d);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.purple.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade400,
                            Colors.purple.shade400
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade200.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.insights_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      "Haftalık Duygu Durumu",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (_isLoading)
                  Container(
                    height: 120,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blue.shade400),
                    ),
                  )
                else
                  Column(
                    children: [
                      // Yatay kaydırılabilir liste ile değiştirildi
                      SizedBox(
                        height: 120, // Uygun bir yükseklik
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(7, (index) {
                            if (index >= _moods.length) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: index == 6
                                      ? 0
                                      : 16, // Son öğede boşluk yok
                                ),
                                child: _buildEmptyDay(index),
                              );
                            }
                            final mood = _moods[index]['mood'] as int;
                            final date = _moods[index]['date'];
                            return Padding(
                              padding: EdgeInsets.only(
                                right:
                                    index == 6 ? 0 : 16, // Son öğede boşluk yok
                              ),
                              child: _buildMoodDay(
                                mood: mood,
                                dayLabel: _dayName(date),
                                dateLabel: _formatDate(date),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildMoodLegend(),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodDay({
    required int mood,
    required String dayLabel,
    required String dateLabel,
  }) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _moodColor(mood),
                _moodColor(mood).withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _moodColor(mood).withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            _moodEmoji(mood),
            style: const TextStyle(fontSize: 26),
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            Text(
              dayLabel,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              dateLabel,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyDay(int index) {
    final now = DateTime.now();
    final day = now.subtract(Duration(days: 6 - index));
    const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cts', 'Paz'];

    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.shade300,
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            "—",
            style: TextStyle(
              fontSize: 22,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            Text(
              days[day.weekday - 1],
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              DateFormat('dd/MM').format(day),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMoodLegend() {
    // Legend için de kaydırılabilir yapı
    return SizedBox(
      height: 80, // Legend için sabit yükseklik
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: 8),
          _buildLegendItem("😞", "Kötü", Colors.red.shade400),
          const SizedBox(width: 16),
          _buildLegendItem("😕", "Orta", Colors.orange.shade400),
          const SizedBox(width: 16),
          _buildLegendItem("😐", "Normal", Colors.grey.shade500),
          const SizedBox(width: 16),
          _buildLegendItem("🙂", "İyi", Colors.lightGreen.shade500),
          const SizedBox(width: 16),
          _buildLegendItem("😄", "Harika", Colors.green.shade600),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String emoji, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _moodEmoji(int mood) {
    switch (mood) {
      case 1:
        return "😞";
      case 2:
        return "😕";
      case 3:
        return "😐";
      case 4:
        return "🙂";
      case 5:
        return "😄";
      default:
        return "❓";
    }
  }

  Color _moodColor(int mood) {
    switch (mood) {
      case 1:
        return Colors.red.shade400;
      case 2:
        return Colors.orange.shade400;
      case 3:
        return Colors.grey.shade500;
      case 4:
        return Colors.lightGreen.shade500;
      case 5:
        return Colors.green.shade600;
      default:
        return Colors.grey.shade300;
    }
  }
}
