import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageService {
  // KRİTİK: SerpApi'den aldığın şifreyi buraya yapıştır
  static const String _apiKey =
      '32d7a9a6be88a6bfdf14c35febb6bd3a2f5fe4584523af35d45a15bdd0299f7d';

  // Aynı resmi defalarca indirmemek için önbellek
  static final Map<String, String> _imageCache = {};

  static Future<String?> fetchGpuImage(String query) async {
    if (_imageCache.containsKey(query)) {
      return _imageCache[query];
    }

    final String encodedQuery = Uri.encodeQueryComponent(query);

    // SerpApi Google Images altyapısına istek atıyoruz
    final url = Uri.parse(
      'https://serpapi.com/search.json?engine=google_images&q=$encodedQuery&api_key=$_apiKey',
    );

    try {
      final response = await http.get(url);

      print("--- SERPAPI YANITI ---");
      print("Aranan: $query");
      print("Status Code: ${response.statusCode}");
      print("-------------------------");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // SerpApi resimleri 'images_results' listesinde döndürür
        if (data['images_results'] != null &&
            data['images_results'].isNotEmpty) {
          // İlk sıradaki resmin yüksek kaliteli (original) linkini al
          String imageUrl = data['images_results'][0]['original'];
          _imageCache[query] = imageUrl;
          return imageUrl;
        } else {
          print("HATA: Görsel bulunamadı.");
        }
      } else {
        print(
          "HATA: SerpApi bağlantısı başarısız. Kodu: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("Resim çekme hatası: $e");
    }
    return null;
  }
}
