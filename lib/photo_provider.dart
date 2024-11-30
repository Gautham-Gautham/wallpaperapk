import 'package:flutter/foundation.dart';
import 'package:wallpaperk/photo_api_services/services.dart';
import 'photo_model.dart';

class PhotoProvider with ChangeNotifier {
  final PhotoService _photoService = PhotoService();

  List<Photo> _photos = [];
  bool _isLoading = false;
  int _currentPage = 1;

  List<Photo> get photos => _photos;
  bool get isLoading => _isLoading;
  bool _myGlobalBool = false;

  bool get myGlobalBool => _myGlobalBool;

  void toggleBool() {
    _myGlobalBool = !_myGlobalBool;
    notifyListeners();
  }

  void setBool(bool value) {
    _myGlobalBool = value;
    notifyListeners();
  }

  Future<void> fetchPhotos({bool resetPage = false}) async {
    if (_isLoading) return;

    if (resetPage) {
      _currentPage = 1;
      _photos.clear();
    }

    _isLoading = true;
    notifyListeners();

    try {
      final newPhotos = await _photoService.fetchPhotos(page: _currentPage);

      final uniqueNewPhotos = newPhotos
          .where((newPhoto) =>
              !_photos.any((existingPhoto) => existingPhoto.id == newPhoto.id))
          .toList();

      _photos.addAll(uniqueNewPhotos);
      _currentPage++;
    } catch (e) {
      print('Error fetching photos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
