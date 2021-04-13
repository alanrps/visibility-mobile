const GOOGLE_API_KEY = 'AIzaSyBUA-Zn5vgtuYNlWMuv55HYkrmqyRKyGMM';

class LocationUtil {
  static String generateLocacationPreviewImage({
    double latitude,
    double longitude,
  }) {
    return "https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=11&size=300x300&key=$GOOGLE_API_KEY";
  }
}
