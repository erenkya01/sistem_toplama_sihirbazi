import 'dart:ui';
import 'package:flutter/material.dart';
// import 'home_screen.dart'; // Kendi ana ekranını buraya dahil etmeyi unutma

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _selectedIndex = 0;

  // Sayfalarımızı burada tanımlıyoruz
  final List<Widget> _pages = [
    // 1. ANA SAYFA: (Buraya kendi HomeScreen'ini koymalısın)
    const Center(
      child: Text(
        "Sistem Toplama Kartları Burada",
        style: TextStyle(color: Colors.white),
      ),
    ),

    // 2. ARAMA SAYFASI
    const SearchScreen(),

    // 3. KARŞILAŞTIRMA
    const Center(
      child: Text(
        "GPU Karşılaştırma Ekranı",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ),

    // 4. PROFİL SAYFASI
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),

      // KRİTİK: extendBody true olmalı ki sayfalar cam menünün altına doğru aksın
      extendBody: true,

      body: _pages[_selectedIndex],

      // LIQUID GLASS (BUZLU CAM) ALT MENÜ TASARIMI
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 15.0,
            sigmaY: 15.0,
          ), // Cam bulanıklık ayarı
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05), // Şeffaf beyaz katman
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
              ),
            ),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor:
                  Colors.transparent, // Arka planı tamamen şeffaf yapıyoruz
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blueAccent,
              unselectedItemColor: Colors.white54,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Ana Sayfa',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search_outlined),
                  activeIcon: Icon(Icons.search, size: 28),
                  label: 'Ara',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.compare_arrows_outlined),
                  activeIcon: Icon(Icons.compare_arrows),
                  label: 'Kıyasla',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// ARAMA SAYFASI WIDGET'I
// ==========================================
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Donanım Ara",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // ARAMA ÇUBUĞU
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Örn: RTX 4070, i5-12400F...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Son Aramalar",
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
            const SizedBox(height: 10),
            // Örnek Arama Geçmişi
            ListTile(
              leading: const Icon(Icons.history, color: Colors.white54),
              title: const Text(
                "Gigabyte H610M H V2",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// PROFİL SAYFASI WIDGET'I (Dolu Tasarım)
// ==========================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // PROFIL KART ALANI
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blueAccent.withOpacity(0.2),
                child: const Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(width: 20),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Eren",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Bilgisayar Mühendisliği",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),

          const Text(
            "SİSTEMLERİM",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // MEVCUT SİSTEM KARTI
          Card(
            color: Colors.white.withOpacity(0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: const Icon(Icons.desktop_windows, color: Colors.white),
              title: const Text(
                "Masaüstü Sistem",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                "i5-12400F • H610M",
                style: TextStyle(color: Colors.white54),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.white54),
              onTap: () {},
            ),
          ),

          // MOBİL CİHAZ KARTI
          Card(
            color: Colors.white.withOpacity(0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: const Icon(Icons.laptop_mac, color: Colors.white),
              title: const Text(
                "Taşınabilir Cihazlar",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                "HP Victus 16 • iPhone 16 Pro",
                style: TextStyle(color: Colors.white54),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.white54),
              onTap: () {},
            ),
          ),

          const SizedBox(height: 30),
          const Text(
            "AYARLAR",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          ListTile(
            leading: const Icon(Icons.dark_mode, color: Colors.white),
            title: const Text(
              "Tema Görünümü",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Switch(
              value: true,
              onChanged: (val) {},
              activeColor: Colors.blueAccent,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.bookmark, color: Colors.white),
            title: const Text(
              "Favori Parçalarım",
              style: TextStyle(color: Colors.white),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
