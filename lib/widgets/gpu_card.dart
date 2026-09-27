import 'package:flutter/material.dart';
import '../models/gpu_model.dart';
import '../services/image_service.dart'; // Servisi buraya dahil ediyoruz
import 'gpu_detail_sheet.dart';

class GpuCard extends StatelessWidget {
  final GpuModel gpu;

  const GpuCard({super.key, required this.gpu});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.03),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        // Resim alanı
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            // İŞTE KRİTİK KISIM: Resmi çeken servis burada tetikleniyor
            child: FutureBuilder<String?>(
              future: ImageService.fetchGpuImage(
                "${gpu.manufacturer} ${gpu.name} graphics card",
              ),
              builder: (context, snapshot) {
                // Veri beklenirken dönecek animasyon
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.blueAccent,
                    ),
                  );
                }
                // Resim başarıyla gelirse göster
                if (snapshot.hasData && snapshot.data != null) {
                  return Image.network(snapshot.data!, fit: BoxFit.cover);
                }
                // Hata olursa veya resim bulunamazsa varsayılan ikon
                return const Icon(Icons.memory, color: Colors.blueAccent);
              },
            ),
          ),
        ),
        title: Text(
          gpu.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "${gpu.manufacturer} • ${gpu.memorySize} • ${gpu.releaseDate}",
          style: TextStyle(color: Colors.white.withOpacity(0.5)),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.blueAccent,
          size: 16,
        ),
        onTap: () => GpuDetailSheet.show(context, gpu),
      ),
    );
  }
}
