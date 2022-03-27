import 'package:app_visibility/shared/config.dart';

class LocationUtil {
  static String generateLocacationPreviewImage({
    double? latitude,
    double? longitude,
  }) {
    return "https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=11&size=300x300&key=${Config.googleApiKey}";
  }
}
