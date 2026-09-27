import 'package:flutter/material.dart';
import '../models/gpu_model.dart';
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
        // API'yi bağlayana kadar geçici çip ikonu duracak
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.memory, color: Colors.blueAccent),
          ),
        ),
        title: Text(gpu.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(
          "${gpu.manufacturer} • ${gpu.memorySize} • ${gpu.releaseDate}", 
          style: TextStyle(color: Colors.white.withOpacity(0.5)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent, size: 16),
        onTap: () => GpuDetailSheet.show(context, gpu),
      ),
    );
  }
}