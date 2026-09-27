import 'package:flutter/material.dart';
// Kendi mevcut liste sayfanı buraya import et (örneğin:)
// import 'gpu_list_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _selectedIndex = 0;

  // Alt menüdeki butonlara basıldığında açılacak sayfalar
  final List<Widget> _pages = [
    // 1. Sekme: Mevcut ekran kartı listen (Buraya kendi sınıfının adını yaz)
    const Center(
      child: Text(
        "GPU Listesi Buraya Gelecek",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ),

    // 2. Sekme: Arama Ekranı
    const Center(
      child: Text(
        "Arama Sayfası",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ),

    // 3. Sekme: Yeni özellik önerisi
    const Center(
      child: Text(
        "GPU Karşılaştırma & Fiyat",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ),

    // 4. Sekme: Profil veya Ayarlar
    const Center(
      child: Text(
        "Profil",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Koyu tema arkaplanı
      body: _pages[_selectedIndex],

      // Instagram tarzı alt menü
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF000000), // Tam siyah arka plan
          selectedItemColor: Colors.white, // Seçili ikon rengi
          unselectedItemColor:
              Colors.grey.shade600, // Seçili olmayan ikon rengi
          showSelectedLabels: true, // Yazıları göstermek istemezsen false yap
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              activeIcon: Icon(Icons.home),
              label: 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              activeIcon: Icon(
                Icons.search,
                size: 28,
              ), // Seçilince biraz büyüsün
              label: 'Ara',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.compare_arrows_outlined),
              activeIcon: Icon(Icons.compare_arrows),
              label: 'Karşılaştır',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
