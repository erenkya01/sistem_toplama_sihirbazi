import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/gpu_model.dart';

class LocalDataService {
  static List<GpuModel> _allGpus = [];

  // Veritabanını uygulama açıldığında bir kez belleğe yükler (Mükemmel performans için)
  static Future<void> loadDatabase() async {
    if (_allGpus.isNotEmpty) return; // Zaten yüklüyse tekrar yükleme

    try {
      final String response = await rootBundle.loadString('assets/gpu.json');
      final Map<String, dynamic> data = json.decode(response);

      // JSON'daki her bir cihaz bloğunu (NVIDIA_..., AMD_... vb.) gezip listeye ekliyoruz
      data.forEach((key, value) {
        // "nan" isimli boş şablonları filtrele
        if (value['Model name'] != 'nan' ||
            (value['Model'] != null && value['Model'] != 'nan')) {
          _allGpus.add(GpuModel.fromJson(value));
        }
      });
      print(
        "Lokal veritabanı başarıyla yüklendi. Toplam Kart: ${_allGpus.length}",
      );
    } catch (e) {
      print("Veritabanı yüklenirken hata oluştu: $e");
    }
  }

  // Kullanıcının yazdığı kelimeyi tüm veritabanında milisaniyeler içinde arar
  static Future<List<GpuModel>> searchGpu(String query) async {
    if (query.trim().isEmpty) return [];

    // Eğer veritabanı henüz belleğe yüklenmediyse yükle
    if (_allGpus.isEmpty) {
      await loadDatabase();
    }

    final lowerQuery = query.toLowerCase();

    // Girilen kelime, kartın içinde geçiyorsa (örn: '3050' yazıldığında RTX 3050'yi bulur) listele
    return _allGpus.where((gpu) {
      return gpu.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
