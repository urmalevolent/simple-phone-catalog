import 'package:flutter/material.dart';
import '../model/hp_local.dart';
import '../database/db_helper.dart';
import 'detail_hp_page.dart';
import 'add_hp_page.dart';
import 'edit_hp_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DbHelper dbHelper;
  List<HpLocal> hpList = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await dbHelper.getAllHp();
    setState(() {
      hpList = data;
    });
  }

  Future<void> _deleteHp(int id) async {
    await dbHelper.deleteHp(id);
    _loadData();
  }

  void _showDeleteConfirmation(HpLocal hp) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Hapus Data'),
            content: Text('Yakin ingin menghapus ${hp.merk}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  _deleteHp(hp.id!);
                  Navigator.pop(ctx);
                },
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          hpList.isEmpty
              ? const Center(child: Text('Belum ada data HP.'))
              : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: hpList.length,
                itemBuilder: (context, index) {
                  final hp = hpList[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          hp.gambar,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          cacheWidth: 200,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported),
                        ),
                      ),
                      title: Text(
                        hp.merk,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('RAM: ${hp.ram} GB | Rp ${hp.harga}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final updated = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditHpPage(hp: hp),
                                ),
                              );
                              if (updated == true) _loadData(); // refresh
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteConfirmation(hp),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailHpPage(hp: hp),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddHpPage()),
          );
          if (result == true) _loadData(); // refresh setelah tambah
        },
      ),
    );
  }
}
