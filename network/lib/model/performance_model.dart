class PerformanceModel {
  PerformanceModel({
    this.ot,
    this.percentace,
  });

  factory PerformanceModel.fromJson(Map<String, dynamic> json) => PerformanceModel(
        ot: json['ot'],
        percentace: json['percentace'].toDouble(),
      );

  int ot;
  double percentace;

  Map<String, dynamic> toJson() => {
        'ot': ot,
        'percentace': percentace,
      };
}
