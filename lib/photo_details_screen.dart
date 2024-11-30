import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wallpaperk/photo_provider.dart';
import 'download_services.dart';
import 'photo_model.dart';

class FavoriteProvider with ChangeNotifier {
  bool _isFavorite = false;

  bool get isFavorite => _isFavorite;

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }
}

class PhotoDetailsScreen extends StatelessWidget {
  final Photo photo;
  final DownloadService downloadService;

  const PhotoDetailsScreen({
    super.key,
    required this.photo,
    required this.downloadService,
  });
  void showToast(BuildContext context, String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavoriteProvider(),
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Hero(
                tag: 'photo_${photo.id}',
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.transparent,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: CachedNetworkImage(
                            imageUrl: photo.urls.full,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CupertinoActivityIndicator(
                                color: Colors.white,
                                radius: 15.0,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Center(child: Icon(Icons.error)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 17,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 16,
                                  foregroundImage: NetworkImage(
                                      photo.user.profileImage.large),
                                ),
                              ),
                              Text(
                                "   ${photo.userName}",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  letterSpacing: 0.01,
                                ),
                              ),
                              const Spacer(),
                              Consumer<FavoriteProvider>(
                                builder: (context, favoriteProvider, child) {
                                  return GestureDetector(
                                    onTap: () {
                                      favoriteProvider.toggleFavorite();
                                      showToast(
                                          context,
                                          favoriteProvider._isFavorite
                                              ? "Added To Favorite"
                                              : "Removed from Favorite");
                                    },
                                    child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      transitionBuilder: (Widget child,
                                          Animation<double> animation) {
                                        return ScaleTransition(
                                            scale: animation, child: child);
                                      },
                                      child: Icon(
                                        favoriteProvider.isFavorite
                                            ? FluentIcons.heart_48_filled
                                            : FluentIcons.heart_48_regular,
                                        key: ValueKey<bool>(
                                            favoriteProvider.isFavorite),
                                        color: favoriteProvider.isFavorite
                                            ? Colors.red
                                            : Colors.grey,
                                        size: 25,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Consumer<PhotoProvider>(
                        builder: (context, download, child) {
                          return Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
                                final fileName =
                                    'unsplash_${photo.user.username}_${photo.id}.jpg';
                                downloadService.downloadImage(
                                    context, photo.urls.full,
                                    fileName: fileName);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.withOpacity(0.8),
                                foregroundColor: Colors.black,
                              ),
                              child: download.myGlobalBool
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Downloading.. ',
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 15,
                                              letterSpacing: 0.0000005),
                                        ),
                                        const CupertinoActivityIndicator(
                                          color: Colors.white,
                                          radius: 10.0,
                                        ),
                                      ],
                                    )
                                  : Text(
                                      'Download Wallpaper',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 15,
                                          letterSpacing: 0.0000005),
                                    ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 15,
              left: 15,
              child: CircleAvatar(
                backgroundColor: Colors.black38,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
