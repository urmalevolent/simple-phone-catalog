import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/hp_api.dart';

class ApiHpPage extends StatefulWidget {
  const ApiHpPage({super.key});

  @override
  State<ApiHpPage> createState() => _ApiHpPageState();
}

class _ApiHpPageState extends State<ApiHpPage> {
  late Future<List<HpApi>> _hpList;

  @override
  void initState() {
    super.initState();
    _hpList = fetchHpFromApi();
  }

  Future<List<HpApi>> fetchHpFromApi() async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/products/category/smartphones'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List products = jsonData['products'];
      return products.map((e) => HpApi.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data dari API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HpApi>>(
      future: _hpList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada data ditemukan.'));
        }

        final data = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final hp = data[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(hp.thumbnail),
                ),
                title: Text('${hp.brand} ${hp.title}'),
                subtitle: Text('Rp ${hp.price}\n${hp.description}'),
                isThreeLine: true,
              ),
            );
          },
        );
      },
    );
  }
}
