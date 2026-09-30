class CpuModel {
  final String name;
  final String brand;
  final String cores;
  final String clock;
  final String socket;
  final String tdp;
  final String type; // KRİTİK EKLENTİ: Donanımın türünü (CPU, GPU vb.) belirler

  CpuModel({
    required this.name,
    required this.brand,
    required this.cores,
    required this.clock,
    required this.socket,
    required this.tdp,
    required this.type,
  });

  factory CpuModel.fromTpu(Map<String, dynamic> json) {
    return CpuModel(
      name: json['name']?.toString() ?? 'Bilinmiyor',
      brand: json['manufacturer']?.toString() ?? 'Bilinmiyor',
      cores: json['cores'] != null ? "${json['cores']} Çekirdek" : 'Bilinmiyor',
      clock: json['baseClockMhz'] != null
          ? "${json['baseClockMhz']} MHz"
          : 'Bilinmiyor',
      socket: json['socket']?.toString() ?? 'Bilinmiyor',
      tdp: json['tdpW'] != null ? "${json['tdpW']}W" : 'Bilinmiyor',
      type: "CPU", // Gelen veri CPU olarak etiketlenir
    );
  }

  factory CpuModel.fromIntel(Map<String, dynamic> json) {
    final performance = json['Performance'] ?? {};
    final package = json['Package Specifications'] ?? {};
    return CpuModel(
      name: json['name']?.toString() ?? 'Bilinmiyor',
      brand: 'Intel',
      cores: performance['# of Cores'] != null
          ? "${performance['# of Cores']} Çekirdek"
          : 'Bilinmiyor',
      clock:
          performance['Processor Base Frequency']?.toString() ?? 'Bilinmiyor',
      socket: package['Sockets Supported']?.toString() ?? 'Bilinmiyor',
      tdp: performance['TDP']?.toString() ?? 'Bilinmiyor',
      type: "CPU", // Gelen veri CPU olarak etiketlenir
    );
  }
}
