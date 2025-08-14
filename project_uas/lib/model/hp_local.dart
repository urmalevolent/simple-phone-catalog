class HpLocal {
  int? id;
  String merk;
  String battery; 
  int ram;
  int harga;
  String deskripsi;
  String gambar;

  HpLocal({
    this.id,
    required this.merk,
    required this.battery, 
    required this.ram,
    required this.harga,
    required this.deskripsi,
    required this.gambar,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'merk': merk,
      'battery': battery, 
      'ram': ram,
      'harga': harga,
      'deskripsi': deskripsi,
      'gambar': gambar,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory HpLocal.fromMap(Map<String, dynamic> map) {
    return HpLocal(
      id: map['id'],
      merk: map['merk'],
      battery: map['battery'],
      ram: map['ram'],
      harga: map['harga'],
      deskripsi: map['deskripsi'],
      gambar: map['gambar'],
    );
  }
}
