import 'package:flutter/material.dart';
import '../main.dart';
import '../models/study_model.dart';
import '../services/api_service.dart';

class StudyPage extends StatefulWidget {
  const StudyPage({super.key});
  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  late Future<StudyModel> _futureStudy;

  @override
  void initState() {
    super.initState();
    _futureStudy = ApiService.fetchStudy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Studi'), 
        backgroundColor: primaryColor,
         iconTheme: const IconThemeData(color: Color(0xFFF6F7FB)),
        titleTextStyle: const TextStyle(
          color: Color(0xFFF6F7FB),
          fontSize: 22,
          fontWeight: FontWeight.w600
        ),
      
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<StudyModel>(
            future: _futureStudy,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              } else if (snap.hasError) {
                return Center(child: Text('Error: ${snap.error}'));
              } else {
                final m = snap.data!;
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Semester 3 — 2025/2025 Ganjil',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  Row(children: [
                    _StatCard(title: 'IP Semester', value: m.ipSemester.toStringAsFixed(2)),
                    const SizedBox(width: 12),
                    _StatCard(title: 'IP Kumulatif', value: m.ipKumulatif.toStringAsFixed(2)),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    _StatCard(title: 'Total SKS', value: m.totalSks.toString()),
                    const SizedBox(width: 12),
                    _StatCard(title: 'Nilai Akhir', value: m.totalNilai.toStringAsFixed(1)),
                  ]),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Memulai download... (demo)')));
                    },
                    icon: const Icon(
                      Icons.download,
                      color: Color(0xFFF6F7FB),
                    ),
                    label: const Text(
                      'Download File',
                      style: TextStyle(
                        color: Color(0xFFF6F7FB)
                      ),
                    ),
                  
                  ),
                ]);
              }
            },
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  const _StatCard({required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}
