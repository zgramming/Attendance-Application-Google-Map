class DestinasiModel {
  String idDestinasi;
  String idUser;
  String namaDestinasi;
  double latitude;
  double longitude;
  String keterangan;
  String image;
  String status;

  DestinasiModel({
    this.idDestinasi,
    this.idUser,
    this.namaDestinasi,
    this.latitude,
    this.longitude,
    this.keterangan,
    this.image,
    this.status,
  });

  factory DestinasiModel.fromJson(Map<String, dynamic> json) => DestinasiModel(
        idDestinasi: json["id_destinasi"],
        idUser: json["id_user"],
        namaDestinasi: json["nama_destinasi"],
        latitude: double.parse(json["latitude"]),
        longitude: double.parse(json["longitude"]),
        keterangan: json["keterangan"],
        image: json["image"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id_destinasi": idDestinasi,
        "id_user": idUser,
        "nama_destinasi": namaDestinasi,
        "latitude": latitude,
        "longitude": longitude,
        "keterangan": keterangan,
        "image": image,
        "status": status,
      };
}
