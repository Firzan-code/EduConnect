import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../main.dart';
import 'study_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<UserModel> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = ApiService.fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UIN Malang'),
        backgroundColor: primaryColor,
        titleTextStyle: const TextStyle(
          color: Color(0xFFF6F7FB),
          fontSize: 22,
          fontWeight: FontWeight.w600
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.file_download_outlined,
              color: Color(0xFFF6F7FB),
            ),
            onPressed: () {
              Navigator.of(context).push(createRoute(const StudyPage()));
            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            FutureBuilder<UserModel>(
              future: _futureUser,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const _ShimmerCard();
                } else if (snap.hasError) {
                  return Text('Error: ${snap.error}');
                } else {
                  final user = snap.data!;
                  return _UserCard(user: user);
                }
              },
            ),
            const SizedBox(height: 18),
            const Expanded(child: _InfoGrid()),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: accentColor,
        onPressed: () {
          setState(() {
            _futureUser = ApiService.fetchUser();
          });
        },
        label: const Text(
          'Refresh',
          style: TextStyle(
            color: Color(0xFFF6F7FB),
          ),
        ),

        icon: const Icon(
          Icons.refresh,
          color: Color(0xFFF6F7FB),  
        ),
      ),
    );
  }
}

// Widget Components
class _UserCard extends StatelessWidget {
  final UserModel user;
  const _UserCard({required this.user});
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'logo-hero',
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))
            ],
          ),
          child: Row(children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: primaryColor,
              child: Text(user.initials,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(user.program,
                        style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 6),
                    Row(children: [
                      Chip(label: Text('${user.sks} SKS')),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(user.gpa.toStringAsFixed(2)),
                    ])
                  ]),
            )
          ]),
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      height: 92,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
            colors: [Colors.grey.shade300, Colors.grey.shade200]),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid();
  @override
  Widget build(BuildContext context) {
    final items = [
      ('Kaldik', Icons.calendar_month),
      ('Rektor', Icons.place),
      ('Nilai', Icons.stacked_bar_chart),
      ('Presensi', Icons.check_circle_outline),
      ('Cat PA', Icons.note_alt),
      ('Buku', Icons.book),
      ('LPBA', Icons.upload_file),
      ('Lainnya', Icons.more_horiz),
    ];
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, i) {
        final (title, icon) = items[i];
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (_) => SizedBox(
                      height: 160,
                      child: Center(
                          child: Text('$title — fitur demo',
                              style: const TextStyle(fontSize: 18))),
                    ));
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CircleAvatar(
                  backgroundColor: primaryColor,
                  child: Icon(icon, color: Colors.white)),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 12))
            ]),
          ),
        );
      },
    );
  }
}
