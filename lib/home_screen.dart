import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaperk/photo_details_screen.dart';
import 'package:wallpaperk/photo_provider.dart';

import 'download_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final DownloadService _downloadService = DownloadService();

  @override
  void initState() {
    super.initState();

    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PhotoProvider>(context, listen: false).fetchPhotos();
    });

    // Scroll listener for lazy loading
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        Provider.of<PhotoProvider>(context, listen: false).fetchPhotos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Unsplash Wallpapers',
          style: GoogleFonts.montserrat(),
        ),
        centerTitle: true,
      ),
      body: Consumer<PhotoProvider>(
        builder: (context, photoProvider, child) {
          if (photoProvider.photos.isEmpty) {
            return Center(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: CupertinoActivityIndicator(
                  color: Colors.red.withOpacity(0.8),
                  radius: 15.0, // Customizable size
                ),
              ),
            );
          }

          return MasonryGridView.count(
            controller: _scrollController,
            padding: const EdgeInsets.all(8),
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            itemCount:
                photoProvider.photos.length + (photoProvider.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == photoProvider.photos.length) {
                return const Center(
                  child: CupertinoActivityIndicator(
                    color: Colors.white,
                    radius: 15.0, // Customizable size
                  ),
                );
              }

              final photo = photoProvider.photos[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhotoDetailsScreen(
                        photo: photo,
                        downloadService: _downloadService,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'photo_${photo.id}',
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white30),
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.transparent,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: photo.urls.regular,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => const Center(
                              child: CupertinoActivityIndicator(
                                color: Colors.white,
                                radius: 15.0, // Customizable size
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 11,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 10,
                                foregroundImage:
                                    NetworkImage(photo.user.profileImage.large),
                              ),
                            ),
                            Text(
                              " " + photo.userName,
                              style: GoogleFonts.montserrat(
                                fontSize: 10,
                                letterSpacing: 0.01,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
