class PerformanceModel {
  int ot;
  double percentace;

  PerformanceModel({
    this.ot,
    this.percentace,
  });

  factory PerformanceModel.fromJson(Map<String, dynamic> json) => PerformanceModel(
        ot: json["ot"],
        percentace: json["percentace"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "ot": ot,
        "percentace": percentace,
      };
}
