import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/study_model.dart';

class ApiService {
  static const String userUrl = 'https://jsonplaceholder.typicode.com/users/1';
  static const String studyUrl = 'https://jsonplaceholder.typicode.com/posts/1';

  static Future<UserModel> fetchUser() async {
    final resp = await http.get(Uri.parse(userUrl));
    if (resp.statusCode == 200) {
      return UserModel.fromJson(json.decode(resp.body));
    } else {
      throw Exception('Failed to load user (${resp.statusCode})');
    }
  }

  static Future<StudyModel> fetchStudy() async {
    final resp = await http.get(Uri.parse(studyUrl));
    if (resp.statusCode == 200) {
      return StudyModel(
        ipSemester: 3.80,
        ipKumulatif: 3.83,
        totalSks: 63,
        totalNilai: 92.5,
      );
    } else {
      throw Exception('Failed to load study (${resp.statusCode})');
    }
  }
}