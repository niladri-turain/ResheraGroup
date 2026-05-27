import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DownloadInvoiceProvider with ChangeNotifier {
  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  double _downloadProgress = 0;
  double get downloadProgress => _downloadProgress;

  Future<void> downloadInvoice(BuildContext context, String url, String fileName) async {
    _isDownloading = true;
    _downloadProgress = 0;
    notifyListeners();

    try {
      // 1. Request Permission
      bool hasPermission = false;
      if (Platform.isAndroid) {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;

        if (androidInfo.version.sdkInt >= 33) {
          // Android 13+ doesn't use generic storage permission for PDFs.
          // Writing to getExternalStorageDirectory() is always allowed.
          // Writing to public Downloads might be restricted without Scoped Storage API,
          // but we'll attempt a safe approach.
          hasPermission = true; 
        } else {
          var status = await Permission.storage.status;
          if (!status.isGranted) {
            status = await Permission.storage.request();
          }
          hasPermission = status.isGranted;
        }
      } else {
        hasPermission = true; 
      }

      if (!hasPermission) {
        _isDownloading = false;
        notifyListeners();
        _showSnackBar(context, "Storage permission denied");
        return;
      }

      // 2. Get Directory
      Directory? directory;
      if (Platform.isAndroid) {
        // Attempt to save to public Downloads folder
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        throw Exception("Could not determine download directory");
      }

      final String filePath = "${directory.path}/$fileName";

      // 3. Download File
      Dio dio = Dio();
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            _downloadProgress = received / total;
            notifyListeners();
          }
        },
      );

      _isDownloading = false;
      _downloadProgress = 1.0;
      notifyListeners();

      _showSnackBar(context, "Invoice downloaded: $fileName");

      // 4. Open File
      await OpenFilex.open(filePath);

    } catch (e) {
      _isDownloading = false;
      notifyListeners();
      _showSnackBar(context, "Download failed: $e");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}
