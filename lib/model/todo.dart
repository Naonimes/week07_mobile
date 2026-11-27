import 'dart:convert';

class Todo {
  final String judul;
  final String deskripsi;
  final DateTime tanggal;
  final bool selesai;
  final DateTime tanggalDibuat;

  Todo({
    required this.judul,
    required this.deskripsi,
    required this.tanggal,
    this.selesai = false,
    required this.tanggalDibuat,
  });

  Todo copyWith({
    String? judul,
    String? deskripsi,
    DateTime? tanggal,
    bool? selesai,
    DateTime? tanggalDibuat,
  }) {
    return Todo(
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      tanggal: tanggal ?? this.tanggal,
      selesai: selesai ?? this.selesai,
      tanggalDibuat: tanggalDibuat ?? this.tanggalDibuat,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'judul': judul,
      'deskripsi': deskripsi,
      'tanggal': tanggal.millisecondsSinceEpoch,
      'selesai': selesai,
      'tanggalDibuat': tanggalDibuat.millisecondsSinceEpoch,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      judul: map['judul'] as String,
      deskripsi: map['deskripsi'] as String,
      tanggal: DateTime.fromMillisecondsSinceEpoch(map['tanggal'] as int),
      selesai: map['selesai'] as bool,
      tanggalDibuat: DateTime.fromMillisecondsSinceEpoch(
        map['tanggalDibuat'] as int,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) =>
      Todo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Todo(judul: $judul, deskripsi: $deskripsi, tanggal: $tanggal, selesai: $selesai, tanggalDibuat: $tanggalDibuat)';
  }

  @override
  bool operator ==(covariant Todo other) {
    if (identical(this, other)) return true;

    return other.judul == judul &&
        other.deskripsi == deskripsi &&
        other.tanggal == tanggal &&
        other.selesai == selesai &&
        other.tanggalDibuat == tanggalDibuat;
  }

  @override
  int get hashCode {
    return judul.hashCode ^
        deskripsi.hashCode ^
        tanggal.hashCode ^
        selesai.hashCode ^
        tanggalDibuat.hashCode;
  }
}