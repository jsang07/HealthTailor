import 'package:http/http.dart' as http;
import 'dart:convert';

class FirebaseAuthRemoteDataSource {
  final String url = 'https://asia-northeast3-health10293.cloudfunctions.net/createCustomToken';

  Future<String> createCustomToken(Map<String, dynamic> user) async {
    final customTokenResponse = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user),
    );

    return customTokenResponse.body;
  }

}