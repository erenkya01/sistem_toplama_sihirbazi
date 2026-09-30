import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  // Tıklanan kategorinin adını (CPU, GPU vb.) diğer sayfaya gönderen fonksiyon
  final Function(String) onNavigateToSearch;

  const HomeScreen({super.key, required this.onNavigateToSearch});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'title': 'İşlemci (CPU)', 'icon': Icons.memory, 'color': Colors.blue, 'type': 'CPU'},
      {'title': 'Ekran Kartı', 'icon': Icons.aod, 'color': Colors.green, 'type': 'GPU'},
      {'title': 'Anakart', 'icon': Icons.developer_board, 'color': Colors.teal, 'type': 'ANAKART'},
      {'title': 'Bellek (RAM)', 'icon': Icons.data_array, 'color': Colors.purple, 'type': 'RAM'},
      {'title': 'Depolama', 'icon': Icons.save, 'color': Colors.orange, 'type': 'SSD'},
      {'title': 'Güç Kaynağı', 'icon': Icons.power, 'color': Colors.redAccent, 'type': 'PSU'},
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text("Sistem Sihirbazı", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            const Text("Kategorini seç ve parçaları keşfet", style: TextStyle(color: Colors.white54, fontSize: 16)),
            const SizedBox(height: 30),
            
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 1.1,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      // Hangi karta tıklandıysa onun 'type' bilgisini gönderir (Örn: "GPU")
                      onNavigateToSearch(cat['type']); 
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(cat['icon'], size: 48, color: cat['color']),
                          const SizedBox(height: 12),
                          Text(cat['title'], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}