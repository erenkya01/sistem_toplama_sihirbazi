import 'dart:ui';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/cpu_model.dart'; // Senin mevcut ana ekranın

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Sayfa listesi artık build içinde, böylece setState ile sekme değiştirebilir
    final List<Widget> pages = [
      HomeScreen(
        onNavigateToSearch: () {
          setState(() {
            _selectedIndex = 1; // Ara sekmesine atla
          });
        },
      ),
      const SearchScreen(),
      const Center(
        child: Text(
          "GPU Karşılaştırma Ekranı Çok Yakında",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: pages[_selectedIndex],

      // TEK KATMANLI ŞEFFAF BALON MENÜ
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
              child: Container(
                // Yükseklik kısıtlaması kaldırıldı (Taşma hatasını önler)
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(canvasColor: Colors.transparent),
                  child: BottomNavigationBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: Colors.blueAccent,
                    unselectedItemColor: Colors.white54,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    currentIndex: _selectedIndex,
                    onTap: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined, size: 26),
                        activeIcon: Icon(Icons.home, size: 28),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.search_outlined, size: 26),
                        activeIcon: Icon(Icons.search, size: 28),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.compare_arrows_outlined, size: 26),
                        activeIcon: Icon(Icons.compare_arrows, size: 28),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person_outline, size: 26),
                        activeIcon: Icon(Icons.person, size: 28),
                        label: '',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// ARAMA SAYFASI WIDGET'I (Enter Algılayan Yapı)
// ==========================================
// ==========================================
// ARAMA SAYFASI WIDGET'I (Enter Algılayan Yapı)
// ==========================================
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<CpuModel> _allCpus = [];
  List<CpuModel> _filteredResults = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllDatabases(); // Ekran açıldığında "Sözde API" isteğini başlat
  }

  // Her iki dosyayı da okuyup verileri standartlaştırarak birleştirir
  Future<void> _loadAllDatabases() async {
    List<CpuModel> temporaryList = [];

    try {
      // 1. TechPowerUp CPU Verisi
      final String tpuResponse = await rootBundle.loadString('assets/cpu.txt');
      final tpuData = json.decode(tpuResponse);
      if (tpuData['status'] == 'success') {
        for (var item in tpuData['results']) {
          if (item['_type'] == 'withheld') continue;
          temporaryList.add(CpuModel.fromTpu(item));
        }
      }

      // 2. Intel CPU Verisi
      final String intelResponse = await rootBundle.loadString(
        'assets/intel_cpu_database.json',
      );
      final Map<String, dynamic> intelData = json.decode(intelResponse);
      intelData.forEach((key, value) {
        temporaryList.add(CpuModel.fromIntel(value));
      });

      // 3. GPU (Ekran Kartı) Verisini Ekliyoruz
      try {
        final String gpuResponse = await rootBundle.loadString(
          'assets/gpu.json',
        );
        final List<dynamic> gpuData = json.decode(gpuResponse);
        for (var item in gpuData) {
          // gpu.json formatını CpuModel içine esneterek sığdırıyoruz
          temporaryList.add(
            CpuModel(
              name:
                  item['name']?.toString() ??
                  item['model']?.toString() ??
                  'Bilinmiyor GPU',
              brand:
                  item['brand']?.toString() ??
                  item['manufacturer']?.toString() ??
                  'NVIDIA/AMD',
              cores: item['memory'] != null
                  ? "${item['memory']} Bellek"
                  : 'Ekran Kartı',
              clock: item['clock']?.toString() ?? '',
              socket: item['interface']?.toString() ?? '',
              tdp: item['tdp'] != null ? "${item['tdp']}W" : '',
            ),
          );
        }
      } catch (e) {
        print("GPU verisi çekilemedi (Dosya yok veya formati farkli): $e");
      }

      setState(() {
        _allCpus = temporaryList;
        _isLoading = false;
      });
    } catch (e) {
      print("Veri çekme hatası: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Arama çubuğu filtreleme fonksiyonu
  void _runFilter(String enteredKeyword) {
    List<CpuModel> results = [];
    if (enteredKeyword.isNotEmpty) {
      results = _allCpus.where((cpu) {
        final searchWord = enteredKeyword.toLowerCase();
        return cpu.name.toLowerCase().contains(searchWord) ||
            cpu.brand.toLowerCase().contains(searchWord);
      }).toList();
    }

    setState(() {
      _filteredResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Detaylı Arama",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                hintText: _isLoading
                    ? "Veritabanına bağlanılıyor..."
                    : "Örn: Ryzen 5, Pentium 4...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: () {
                          _searchController.clear();
                          _runFilter('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    )
                  : _searchController.text.isEmpty
                  ? Center(
                      child: Text(
                        "Donanım aramak için model veya marka girin.\nToplam ${_allCpus.length} işlemci veritabanında hazır.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white38),
                      ),
                    )
                  : _filteredResults.isEmpty
                  ? const Center(
                      child: Text(
                        "Sonuç bulunamadı.",
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _filteredResults.length,
                      itemBuilder: (context, index) {
                        final cpu = _filteredResults[index];
                        return Card(
                          color: Colors.white.withOpacity(0.05),
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: cpu.brand == 'AMD'
                                    ? Colors.red.withOpacity(0.2)
                                    : Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                cpu.cores.contains('Bellek') ||
                                        cpu.cores.contains('Ekran Kartı')
                                    ? Icons
                                          .aod // Ekran kartı ise ekran ikonu
                                    : Icons.memory, // İşlemci ise çip ikonu
                                color: cpu.brand == 'AMD'
                                    ? Colors.redAccent
                                    : Colors.blueAccent,
                              ),
                            ),
                            title: Text(
                              cpu.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "${cpu.cores} • ${cpu.clock}\nSoket: ${cpu.socket} • TDP: ${cpu.tdp}",
                              style: const TextStyle(color: Colors.white54),
                            ),
                            isThreeLine: true,
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

// ==========================================
// PROFİL VE AYARLAR SAYFASI (Gerçekçi Modüller)
// ==========================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Profil ve Ayarlar",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),

          const Text(
            "KİŞİSEL",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildSettingCard(
            Icons.bookmark,
            "Kaydedilen Sistemler",
            "Favoriye aldığınız donanımlar",
          ),
          _buildSettingCard(
            Icons.history,
            "Arama Geçmişi",
            "Son incelediğiniz parçalar",
          ),

          const SizedBox(height: 30),
          const Text(
            "UYGULAMA AYARLARI",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          Card(
            color: Colors.white.withOpacity(0.05),
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: const Icon(Icons.dark_mode, color: Colors.white),
              title: const Text(
                "Karanlık Tema",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Switch(
                value: true,
                onChanged: (val) {},
                activeColor: Colors.blueAccent,
              ),
            ),
          ),
          _buildSettingCard(
            Icons.cloud_download,
            "Veritabanını Güncelle",
            "En yeni ekran kartı verilerini çek",
          ),
          _buildSettingCard(Icons.language, "Dil Seçenekleri", "Türkçe"),

          const SizedBox(height: 30),
          const Text(
            "HAKKINDA",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildSettingCard(
            Icons.info_outline,
            "Uygulama Sürümü",
            "v1.0.0 (Beta)",
          ),
        ],
      ),
    );
  }

  // Ayar kartlarını daha temiz oluşturmak için yardımcı fonksiyon
  Widget _buildSettingCard(IconData icon, String title, String subtitle) {
    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white54),
        onTap: () {},
      ),
    );
  }
}
