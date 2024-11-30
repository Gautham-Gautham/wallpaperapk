import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wallpaperk/photo_provider.dart';

class DownloadService {
  Future<bool> _checkAndRequestPermissions() async {
    if (Platform.isAndroid) {
      // Check for Android 13+ (SDK 33+) permissions
      // if (Platform.isAndroid) {
      if (await Permission.photos.status.isDenied) {
        await Permission.photos.request();
      }
      if (await Permission.storage.status.isDenied) {
        await Permission.storage.request();
      }
      if (await Permission.manageExternalStorage.status.isDenied) {
        await Permission.manageExternalStorage.request();
      }
      // }

      return await Permission.storage.isGranted &&
          await Permission.photos.isGranted;
    }
    return true;
  }

  Future<String?> downloadImage(BuildContext context, String imageUrl,
      {String? fileName}) async {
    try {
      Provider.of<PhotoProvider>(context, listen: false).toggleBool();
      // Check and request permissions
      final hasPermission = await _checkAndRequestPermissions();
      // if (!hasPermission) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Storage permissions are required')),
      //   );
      //   return null;
      // }

      // Determine download directory
      Directory? downloadsDir;
      if (Platform.isAndroid) {
        // Try multiple paths
        final possiblePaths = [
          '/storage/emulated/0/Download',
          '/storage/emulated/0/Downloads',
          '/sdcard/Download',
          '/sdcard/Downloads',
        ];

        for (var path in possiblePaths) {
          final dir = Directory(path);
          if (await dir.exists()) {
            downloadsDir = dir;
            break;
          }
        }
        downloadsDir ??= await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      if (downloadsDir == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not find download directory')),
        );
        return null;
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final defaultFileName = 'unsplash_wallpaper_$timestamp.jpg';
      final filename = fileName ?? defaultFileName;
      final filePath = '/storage/emulated/0/Download/$filename';
      final dio = Dio();
      await dio.download(
        imageUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = received / total;
            print('Download progress: ${(progress * 100).toStringAsFixed(1)}%');
          }
        },
      );
      Provider.of<PhotoProvider>(context, listen: false).toggleBool();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image downloaded to $filePath'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () {
              OpenFile.open(filePath);
            },
          ),
        ),
      );

      return filePath;
    } catch (e) {
      print('Download error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
      return null;
    }
  }
}
