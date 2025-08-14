import 'package:flutter/material.dart';
import '../model/hp_local.dart';
import '../database/db_helper.dart';

class EditHpPage extends StatefulWidget {
  final HpLocal hp;

  const EditHpPage({super.key, required this.hp});

  @override
  State<EditHpPage> createState() => _EditHpPageState();
}

class _EditHpPageState extends State<EditHpPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _merkController;
  late TextEditingController _batteryController;
  late TextEditingController _ramController;
  late TextEditingController _hargaController;
  late TextEditingController _deskripsiController;

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

    _merkController = TextEditingController(text: widget.hp.merk);
    _batteryController = TextEditingController(text: widget.hp.battery);
    _ramController = TextEditingController(text: widget.hp.ram.toString());
    _hargaController = TextEditingController(text: widget.hp.harga.toString());
    _deskripsiController = TextEditingController(text: widget.hp.deskripsi);
    _selectedImage = widget.hp.gambar.replaceFirst('assets/', '');
  }

  Future<void> _updateHp() async {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      final updatedHp = HpLocal(
        id: widget.hp.id,
        merk: _merkController.text,
        battery: _batteryController.text,
        ram: int.tryParse(_ramController.text) ?? 0,
        harga: int.tryParse(_hargaController.text) ?? 0,
        deskripsi: _deskripsiController.text,
        gambar: 'assets/$_selectedImage',
      );

      await dbHelper.updateHp(updatedHp);
      if (context.mounted) Navigator.pop(context, true);
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
        title: const Text('Edit HP'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _merkController,
                decoration: const InputDecoration(labelText: 'Merk'),
                validator: (value) => value!.isEmpty ? 'Merk tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _batteryController,
                decoration: const InputDecoration(labelText: 'Battery (mAh)'),
                validator: (value) => value!.isEmpty ? 'Battery tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ramController,
                decoration: const InputDecoration(labelText: 'RAM (GB)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'RAM tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(labelText: 'Harga (Rp)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Harga tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              
              DropdownButtonFormField<String>(
                value: _selectedImage,
                decoration: const InputDecoration(labelText: 'Pilih Gambar'),
                items: imageOptions.map((filename) {
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
              ),
              const SizedBox(height: 20),
              if (_selectedImage != null)
                Image.asset(
                  'assets/$_selectedImage',
                  height: 150,
                  fit: BoxFit.cover,
                  cacheWidth: 200,
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateHp,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
