class AbsensiModel {
  AbsensiModel({
    this.tanggalAbsen,
    this.jamAbsenMasuk,
    this.jamAbsenPulang,
    this.durasiAbsen,
    this.status,
    this.durasiLembur,
  });

  factory AbsensiModel.fromJson(Map<String, dynamic> json) => AbsensiModel(
        tanggalAbsen: DateTime.parse(json['tanggal_absen']),
        jamAbsenMasuk: json['jam_absen_masuk'],
        jamAbsenPulang: json['jam_absen_pulang'],
        durasiAbsen: json['durasi_absen'],
        status: json['status'],
        durasiLembur: json['durasi_lembur'],
      );

  DateTime tanggalAbsen;
  String jamAbsenMasuk;
  String jamAbsenPulang;
  String durasiAbsen;
  String status;
  String durasiLembur;

  Map<String, dynamic> toJson() => {
        'tanggal_absen':
            '${tanggalAbsen.year.toString().padLeft(4, '0')}-${tanggalAbsen.month.toString().padLeft(2, '0')}-${tanggalAbsen.day.toString().padLeft(2, '0')}',
        'jam_absen_masuk': jamAbsenMasuk,
        'jam_absen_pulang': jamAbsenPulang,
        'durasi_absen': durasiAbsen,
        'status': status,
        'durasi_lembur': durasiLembur,
      };
}
