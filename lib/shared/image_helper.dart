import 'package:visits/shared/network/local/cache_helper.dart';

class ImageHelper {
  static bool get useStaticImages {
    return CacheHelper.getBoolean(key: 'use_static_images') ?? false;
  }

  static String getImagePath(String gifPath) {
    if (useStaticImages) {
      // Map GIF files to their static image alternatives
      final Map<String, String> gifToImageMap = {
        'assets/images/add.gif': 'assets/images/add.jpg',
        'assets/images/archive.gif': 'assets/images/archive.jpg',
        'assets/images/bar.gif': 'assets/images/bar.jpg',
        'assets/images/comlpaining.gif': 'assets/images/comlpaining.jpg',
        'assets/images/history.gif': 'assets/images/logo1.png',
        'assets/images/load.gif': 'assets/images/logo1.png',
        'assets/images/loading.gif': 'assets/images/logo1.png',
        'assets/images/loading1.gif': 'assets/images/logo1.png',
        'assets/images/plus.gif': 'assets/images/logo1.png',
        'assets/images/visits.gif': 'assets/images/visits.jpg',
        'assets/images/app_bar.gif': 'assets/images/bar.jpg',
      };

      return gifToImageMap[gifPath] ?? gifPath;
    }
    return gifPath;
  }

  static Future<void> toggleStaticImages(bool value) async {
    await CacheHelper.putBoolean(key: 'use_static_images', value: value);
  }
}
