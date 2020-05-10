class AbsensiModel {
  String idAbsen;
  String idUser;
  DateTime tanggalAbsen;
  DateTime tanggalAbsenMasuk;
  DateTime tanggalAbsenPulang;
  String jamAbsenMasuk;
  String jamAbsenPulang;
  String durasiAbsen;
  String status;
  String durasiLembur;
  DateTime createdDate;
  DateTime updateDate;

  AbsensiModel({
    this.idAbsen,
    this.idUser,
    this.tanggalAbsen,
    this.tanggalAbsenMasuk,
    this.tanggalAbsenPulang,
    this.jamAbsenMasuk,
    this.jamAbsenPulang,
    this.durasiAbsen,
    this.status,
    this.durasiLembur,
    this.createdDate,
    this.updateDate,
  });

  factory AbsensiModel.fromJson(Map<String, dynamic> json) => AbsensiModel(
        idAbsen: json["id_absen"],
        idUser: json["id_user"],
        tanggalAbsen: DateTime.parse(json["tanggal_absen"]),
        tanggalAbsenMasuk: DateTime.parse(json["tanggal_absen_masuk"]),
        tanggalAbsenPulang: DateTime.parse(json["tanggal_absen_pulang"]),
        jamAbsenMasuk: json["jam_absen_masuk"],
        jamAbsenPulang: json["jam_absen_pulang"],
        durasiAbsen: json["durasi_absen"],
        status: json["status"],
        durasiLembur: json["durasi_lembur"],
        createdDate: DateTime.parse(json["created_date"]),
        updateDate: DateTime.parse(json["update_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id_absen": idAbsen,
        "id_user": idUser,
        "tanggal_absen":
            "${tanggalAbsen.year.toString().padLeft(4, '0')}-${tanggalAbsen.month.toString().padLeft(2, '0')}-${tanggalAbsen.day.toString().padLeft(2, '0')}",
        "tanggal_absen_masuk":
            "${tanggalAbsenMasuk.year.toString().padLeft(4, '0')}-${tanggalAbsenMasuk.month.toString().padLeft(2, '0')}-${tanggalAbsenMasuk.day.toString().padLeft(2, '0')}",
        "tanggal_absen_pulang":
            "${tanggalAbsenPulang.year.toString().padLeft(4, '0')}-${tanggalAbsenPulang.month.toString().padLeft(2, '0')}-${tanggalAbsenPulang.day.toString().padLeft(2, '0')}",
        "jam_absen_masuk": jamAbsenMasuk,
        "jam_absen_pulang": jamAbsenPulang,
        "durasi_absen": durasiAbsen,
        "status": status,
        "durasi_lembur": durasiLembur,
        "created_date":
            "${createdDate.year.toString().padLeft(4, '0')}-${createdDate.month.toString().padLeft(2, '0')}-${createdDate.day.toString().padLeft(2, '0')}",
        "update_date":
            "${updateDate.year.toString().padLeft(4, '0')}-${updateDate.month.toString().padLeft(2, '0')}-${updateDate.day.toString().padLeft(2, '0')}",
      };
}
