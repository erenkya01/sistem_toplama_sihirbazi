import 'package:flutter/material.dart';
class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToSearch; // Yönlendirme fonksiyonu eklendi

  const HomeScreen({super.key, required this.onNavigateToSearch});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'title': 'İşlemci (CPU)', 'icon': Icons.memory, 'color': Colors.blue},
      {'title': 'Anakart', 'icon': Icons.developer_board, 'color': Colors.teal},
      {'title': 'Ekran Kartı', 'icon': Icons.aod, 'color': Colors.green},
      {
        'title': 'Bellek (RAM)',
        'icon': Icons.data_array,
        'color': Colors.purple,
      },
      {'title': 'Depolama', 'icon': Icons.save, 'color': Colors.orange},
      {'title': 'Güç Kaynağı', 'icon': Icons.power, 'color': Colors.redAccent},
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Sistem Sihirbazı",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Kategorini seç ve parçaları keşfet",
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
            const SizedBox(height: 30),

            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.1,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      // Kategoriye tıklandığında arama sekmesine geçer
                      onNavigateToSearch();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(cat['icon'], size: 48, color: cat['color']),
                          const SizedBox(height: 12),
                          Text(
                            cat['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
