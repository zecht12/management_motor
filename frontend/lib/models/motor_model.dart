class Motor {
  final String idmotor;
  final String nama;
  final int stok;
  final double harga;

  Motor({
    required this.idmotor,
    required this.nama,
    required this.stok,
    required this.harga,
  });

  factory Motor.fromJson(Map<String, dynamic> json) {
    return Motor(
      idmotor: json['idmotor'].toString(),
      nama: json['nama'],
      stok: int.parse(json['stok'].toString()),
      harga: double.parse(json['harga'].toString()),
    );
  }
}