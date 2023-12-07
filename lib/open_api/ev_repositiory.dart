import 'dart:convert';
import 'package:health_taylor/key.dart';
import 'package:health_taylor/open_api/ev.dart';
import 'package:http/http.dart' as http;

class EvRepository {
  Future<List<Ev>> loadEvs() async {
    String baseUrl =
        'https://api.odcloud.kr/api/15007122/v1/uddi:95d6cbf2-f800-4ce3-a4f7-f57823274732?page=1&perPage=10&serviceKey=$serviceKey';
    final http.Response response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> itemsList = body['data'];
      List<Ev> evs = itemsList.map((item) => Ev.fromJson(item)).toList();

      return evs;
    } else {
      throw Exception('Failed to load evs');
    }
  }
}
