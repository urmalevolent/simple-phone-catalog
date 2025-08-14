import 'package:flutter/material.dart';
import '../model/hp_local.dart';
import '../database/db_helper.dart';

class AddHpPage extends StatefulWidget {
  const AddHpPage({super.key});

  @override
  State<AddHpPage> createState() => _AddHpPageState();
}

class _AddHpPageState extends State<AddHpPage> {
  final _formKey = GlobalKey<FormState>();
  final _merkController = TextEditingController();
  final _batteryController = TextEditingController();
  final _ramController = TextEditingController();
  final _hargaController = TextEditingController();
  final _deskripsiController = TextEditingController();

  String? _selectedImage;
  late DbHelper dbHelper;

  final List<String> imageOptions = [
    'ip16.jpg',
    'SGA55.jpg',
    'pcf7pro.jpg',
    'fiky.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  Future<void> _saveHp() async {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      final hp = HpLocal(
        merk: _merkController.text,
        battery: _batteryController.text,
        ram: int.tryParse(_ramController.text) ?? 0,
        harga: int.tryParse(_hargaController.text) ?? 0,
        deskripsi: _deskripsiController.text,
        gambar: 'assets/$_selectedImage',
      );

      await dbHelper.insertHp(hp);
      if (context.mounted) {
        Navigator.pop(
          context,
          true,
        ); // kembali ke HomePage dengan tanda sukses
      }
    } else if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih gambar terlebih dahulu!')),
      );
    }
  }

  @override
  void dispose() {
    _merkController.dispose();
    _batteryController.dispose();
    _ramController.dispose();
    _hargaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah HP'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 8),
              TextFormField(
                controller: _merkController,
                decoration: const InputDecoration(
                  labelText: 'Merk',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Merk tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _batteryController,
                decoration: const InputDecoration(
                  labelText: 'Battery (mAh)',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Battery tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _ramController,
                decoration: const InputDecoration(
                  labelText: 'RAM (GB)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator:
                    (value) => value!.isEmpty ? 'RAM tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(
                  labelText: 'Harga (Rp)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value!.isEmpty ? 'Harga tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _deskripsiController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: _selectedImage,
                decoration: const InputDecoration(
                  labelText: 'Pilih Gambar (Assets)',
                  border: OutlineInputBorder(),
                ),
                items:
                    imageOptions.map((filename) {
                      return DropdownMenuItem(
                        value: filename,
                        child: Text(filename),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedImage = value;
                  });
                },
                validator: (value) => value == null ? 'Pilih gambar' : null,
              ),
              const SizedBox(height: 20),

              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/$_selectedImage',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      cacheWidth: 200,
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _saveHp,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
