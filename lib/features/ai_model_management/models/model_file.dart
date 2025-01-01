class HFModelFile {
  final String? rfilename;
  final String? url;
  final int? size;
  final String? oid;
  final bool? canFitInStorage;

  HFModelFile({
    this.rfilename,
    this.url,
    this.size,
    this.oid,
    this.canFitInStorage,
  });

  Map<String, dynamic> toJson() => {
    'rfilename': rfilename,
    'url': url,
    'size': size,
    'oid': oid,
    'canFitInStorage': canFitInStorage,
  }..removeWhere((key, value) => value == null);  // Remove null values

  factory HFModelFile.fromJson(Map<String, dynamic> json) => HFModelFile(
    rfilename: json['rfilename'],
    url: json['url'],
    size: json['size'],
    oid: json['oid'],
    canFitInStorage: json['canFitInStorage'],
  );
}