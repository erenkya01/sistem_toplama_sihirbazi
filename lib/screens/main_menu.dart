import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/cpu_model.dart';
import 'home_screen.dart';

// ==========================================
// ANA MENÜ VE ALT NAVİGASYON
// ==========================================
class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int _selectedIndex = 0;
  String _activeCategory = "Tümü";

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        onNavigateToSearch: (categoryType) {
          setState(() {
            _activeCategory = categoryType;
            _selectedIndex = 1;
          });
        },
      ),
      SearchScreen(categoryFilter: _activeCategory),
      const Center(
        child: Text(
          "Karşılaştırma Çok Yakında",
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

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
              child: Container(
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
                        if (index == 1) _activeCategory = "Tümü";
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
// ARAMA SAYFASI WIDGET'I
// ==========================================
class SearchScreen extends StatefulWidget {
  final String categoryFilter;

  const SearchScreen({super.key, required this.categoryFilter});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<CpuModel> _allDatabases = [];
  List<CpuModel> _filteredResults = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllDatabases();
  }

  @override
  void didUpdateWidget(SearchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryFilter != widget.categoryFilter) {
      _runFilter(_searchController.text);
    }
  }

  // TÜM VERİTABANLARINI YÜKLEYEN FONKSİYON
  Future<void> _loadAllDatabases() async {
    List<CpuModel> temporaryList = [];

    try {
      // 1. TPU CPU Veritabanı
      final String tpuResponse = await rootBundle.loadString('assets/cpu.txt');
      final tpuData = json.decode(tpuResponse);
      if (tpuData['status'] == 'success') {
        for (var item in tpuData['results']) {
          if (item['_type'] == 'withheld') continue;
          temporaryList.add(CpuModel.fromTpu(item));
        }
      }

      // 2. INTEL CPU Veritabanı
      final String intelResponse = await rootBundle.loadString(
        'assets/intel_cpu_database.json',
      );
      final Map<String, dynamic> intelData = json.decode(intelResponse);
      intelData.forEach((key, value) {
        temporaryList.add(CpuModel.fromIntel(value));
      });

      // 3. GPU Ekran Kartı Veritabanı
      try {
        final String gpuResponse = await rootBundle.loadString(
          'assets/gpu.json',
        );
        final Map<String, dynamic> gpuData = json.decode(gpuResponse);

        gpuData.forEach((key, item) {
          String gpuName = item['Model name']?.toString() ?? 'nan';
          if (gpuName == 'nan') gpuName = item['Model']?.toString() ?? 'nan';
          if (gpuName == 'nan')
            gpuName = item['Code name']?.toString() ?? 'Bilinmeyen Seri';

          temporaryList.add(
            CpuModel(
              name: gpuName,
              brand: item['Vendor']?.toString() ?? 'GPU',
              cores: item['Memory Size (MiB)'] != null
                  ? "${item['Memory Size (MiB)']} MB VRAM"
                  : 'VRAM Bilinmiyor',
              clock: item['Core clock (MHz)'] != null
                  ? "${item['Core clock (MHz)']} MHz"
                  : '',
              socket: item['Bus interface']?.toString() ?? 'PCIe',
              tdp: item['TDP (Watts)']?.toString() != '?'
                  ? "${item['TDP (Watts)']}W"
                  : 'TDP Bilinmiyor',
              type: "GPU",
            ),
          );
        });
      } catch (e) {
        print("GPU Okuma Hatası: $e");
      }

      setState(() {
        _allDatabases = temporaryList;
        _isLoading = false;
      });

      _runFilter('');
    } catch (e) {
      print("Genel Veri Çekme Hatası: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // FİLTRELEME FONKSİYONU
  void _runFilter(String enteredKeyword) {
    List<CpuModel> results = _allDatabases;

    if (widget.categoryFilter != "Tümü") {
      results = results
          .where((item) => item.type == widget.categoryFilter)
          .toList();
    }

    if (enteredKeyword.isNotEmpty) {
      final searchWord = enteredKeyword.toLowerCase();
      results = results.where((item) {
        return item.name.toLowerCase().contains(searchWord) ||
            item.brand.toLowerCase().contains(searchWord);
      }).toList();
    }

    setState(() {
      _filteredResults = results;
    });
  }

  // ALTTAN AÇILAN DETAY PENCERESİ FONKSİYONU
  void _showDetails(CpuModel item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),

              // İKON VEYA RESİM ALANI
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blueAccent.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Icon(
                  item.type == "GPU" ? Icons.aod : Icons.memory,
                  size: 60,
                  color: item.brand.contains('AMD')
                      ? Colors.redAccent
                      : Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  item.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                item.brand,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 16,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 30),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildDetailRow(Icons.category, "Kategori", item.type),
                      _buildDetailRow(
                        Icons.layers,
                        item.type == "GPU" ? "VRAM Bellek" : "Çekirdekler",
                        item.cores,
                      ),
                      _buildDetailRow(Icons.speed, "Saat Hızı", item.clock),
                      _buildDetailRow(
                        Icons.electrical_services,
                        "Bağlantı / Soket",
                        item.socket,
                      ),
                      _buildDetailRow(
                        Icons.power,
                        "Güç Tüketimi (TDP)",
                        item.tdp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white54, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String pageTitle = widget.categoryFilter == "Tümü"
        ? "Tüm Donanımlar"
        : "${widget.categoryFilter} Arama";

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pageTitle,
              style: const TextStyle(
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
                    ? "Veriler Çekiliyor..."
                    : "Model veya marka arayın...",
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
                  : _filteredResults.isEmpty
                  ? const Center(
                      child: Text(
                        "Bu kategoride sonuç bulunamadı.",
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _filteredResults.length,
                      itemBuilder: (context, index) {
                        final item = _filteredResults[index];
                        final isGpu = item.type == "GPU";

                        return Card(
                          color: Colors.white.withOpacity(0.05),
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            onTap: () =>
                                _showDetails(item), // Detay sayfasını açar
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: item.brand.contains('AMD')
                                    ? Colors.red.withOpacity(0.2)
                                    : Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                isGpu ? Icons.aod : Icons.memory,
                                color: item.brand.contains('AMD')
                                    ? Colors.redAccent
                                    : Colors.blueAccent,
                              ),
                            ),
                            title: Text(
                              item.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "${item.cores} • ${item.clock}\nBağlantı: ${item.socket}",
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
// PROFİL SAYFASI
// ==========================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Profil",
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}
