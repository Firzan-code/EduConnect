class UserModel {
  final String id;
  final String name;
  final String program;
  final int sks;
  final double gpa;

  UserModel({
    required this.id,
    required this.name,
    required this.program,
    required this.sks,
    required this.gpa,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] ?? 'Mahasiswa',
      program: 'Sistem Informasi',
      sks: 63,
      gpa: 3.8,
    );
  }

  String get initials {
    final parts = name.split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
