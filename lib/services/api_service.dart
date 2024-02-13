import 'package:appcurso/models/user_credential.dart';
import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl =
      "https://polar-plains-89142-ae7bf2bd796a.herokuapp.com/";
  static const String path = "api/auth/local";

  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await Dio().post(
        "$baseUrl$path",
        data: {
          "identifier": email,
          "password": password,
        },
      );
      // serializar UserCredential
      final userCredential = UserCredential.fromJson(result.data);
      return userCredential;
    } catch (e) {
      return null;
    }
  }
}
