import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/service/shared_pref_service.dart';

class DownloadInvoiceProvider with ChangeNotifier {
  final SharedPrefService _prefService = GetIt.I<SharedPrefService>();

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  double _downloadProgress = 0;
  double get downloadProgress => _downloadProgress;

  Future<void> downloadInvoice(BuildContext context, String orderId) async {
    final String url = "${ApiEndPoints.baseUrl}${ApiEndPoints.createOrder}/$orderId/${ApiEndPoints.invoice}";
    final String fileName = "Invoice_$orderId.pdf";

    _isDownloading = true;
    _downloadProgress = 0;
    notifyListeners();

    try {
      // 1. Get Directory - Use app-specific directory to avoid permission issues
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = "${directory.path}/$fileName";

      // 2. Download File
      Dio dio = Dio();
      final token = await _prefService.getToken();
      
      final response = await dio.download(
        url,
        filePath,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'X-API-TOKEN': AppStrings.xApiTokenForAll,
         //   if (token != null) 'Authorization': 'Bearer $token',
          },
          // Ensure we only download if the status is 200
          validateStatus: (status) => status == 200,
        ),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            _downloadProgress = received / total;
            notifyListeners();
          }
        },
      );

      if (response.statusCode == 200) {
        _isDownloading = false;
        _downloadProgress = 1.0;
        notifyListeners();

        _showSnackBar(context, "Invoice downloaded successfully");

        // 3. Open File Automatically
        await OpenFilex.open(filePath);
      } else {
        throw Exception("Failed to download: Status ${response.statusCode}");
      }

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
