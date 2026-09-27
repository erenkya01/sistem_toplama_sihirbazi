import 'package:flutter/material.dart';
import '../models/gpu_model.dart';
import '../services/image_service.dart';

class GpuDetailSheet {
  static void show(BuildContext context, GpuModel gpu) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSheet(context, gpu),
    );
  }

  static Widget _buildSheet(BuildContext context, GpuModel gpu) {
    // Karttaki arama metninin birebir aynısı (Önbellekten çekmesi için önemli)
    final String searchQuery = "${gpu.manufacturer} ${gpu.name} graphics card";

    return Container(
      height:
          MediaQuery.of(context).size.height * 0.75, // Ekranın %75'ini kaplar
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Koyu tema arka planı
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kapatma çubuğu (küçük gri çizgi)
          Center(
            child: Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // BÜYÜK RESİM ALANI
          Center(
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FutureBuilder<String?>(
                  future: ImageService.fetchGpuImage(searchQuery),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blueAccent,
                        ),
                      );
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      return Image.network(
                        snapshot.data!,
                        fit: BoxFit.contain, // Resmi kırpmadan büyük gösterir
                      );
                    }
                    return const Icon(
                      Icons.memory,
                      size: 80,
                      color: Colors.blueAccent,
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // KART DETAYLARI
          Text(
            gpu.name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Özellikler Listesi
          _buildDetailRow(Icons.business, "Üretici", gpu.manufacturer),
          _buildDetailRow(Icons.memory, "Bellek", gpu.memorySize),
          _buildDetailRow(
            Icons.calendar_month,
            "Çıkış Tarihi",
            gpu.releaseDate,
          ),
        ],
      ),
    );
  }

  // Özellikleri alt alta şık bir şekilde dizmek için yardımcı widget
  static Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 24),
          const SizedBox(width: 12),
          Text(
            "$title: ",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
