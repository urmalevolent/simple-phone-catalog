import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/hp_api.dart';

class ApiService {
  static const String _baseUrl = 'https://dummyjson.com/products/category/smartphones';

  static Future<List<HpApi>> fetchHp() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> products = jsonData['products'];
      return products.map((item) => HpApi.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data dari API');
    }
  }
}
