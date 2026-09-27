class GpuModel {
  final String name;
  final String manufacturer;
  final String memorySize;
  final String memoryType;
  final String releaseDate;
  final String tdp;
  final String architecture;

  GpuModel({
    required this.name,
    required this.manufacturer,
    required this.memorySize,
    required this.memoryType,
    required this.releaseDate,
    required this.tdp,
    required this.architecture,
  });

  factory GpuModel.fromJson(Map<String, dynamic> json) {
    // İsim kontrolü
    String gpuName = (json['Model name'] != null && json['Model name'] != 'nan')
        ? json['Model name'].toString()
        : (json['Model'] != null && json['Model'] != 'nan'
              ? json['Model'].toString()
              : 'Bilinmiyor');

    // Bellek kapasitesi kontrolü
    String memory = (json['Memory Size (GiB)'] != null)
        ? "${json['Memory Size (GiB)']} GB"
        : (json['Memory Size (MiB)'] != null
              ? "${json['Memory Size (MiB)']} MB"
              : 'N/A');

    // TDP (Güç Tüketimi) kontrolü
    String tdpVal = json['TDP (Watts)']?.toString() ?? 'N/A';
    if (tdpVal != 'N/A' && tdpVal != 'Unknown' && tdpVal != '?') {
      tdpVal = "$tdpVal W";
    }

    return GpuModel(
      name: gpuName,
      manufacturer: json['Vendor']?.toString() ?? 'N/A',
      memorySize: memory,
      memoryType: json['Memory Bus type']?.toString() ?? 'N/A',
      releaseDate: (json['Launch'] != null && json['Launch'] != 'nan')
          ? json['Launch'].toString().split(' ')[0]
          : 'N/A',
      tdp: tdpVal,
      // Yeni JSON'da direkt 'architecture' yerine 'Code name' geçiyor, onu alıyoruz.
      architecture: json['Code name']?.toString() ?? 'N/A',
    );
  }
}
