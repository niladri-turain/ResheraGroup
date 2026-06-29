import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import '../../../core/constants/api_end_points.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/service/shared_pref_service.dart';
import '../model/invoice_response_model.dart';

class DownloadInvoiceProvider with ChangeNotifier {
  final SharedPrefService _prefService = GetIt.I<SharedPrefService>();

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  double _downloadProgress = 0;
  double get downloadProgress => _downloadProgress;

  Future<void> downloadInvoice(BuildContext context, String orderId) async {
    final String url = "${ApiEndPoints.baseUrl}${ApiEndPoints.createOrder}/$orderId/${ApiEndPoints.invoice}";

    _isDownloading = true;
    _downloadProgress = 0;
    notifyListeners();

    try {
      Dio dio = Dio();
      final token = await _prefService.getToken();

      // 1. Get the Invoice URL (JSON response)
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'X-API-TOKEN': AppStrings.xApiTokenForAll,
           // if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final invoiceData = InvoiceResponseModel.fromJson(response.data);
        final String? invoiceUrl = invoiceData.invoiceUrl;

        if (invoiceUrl != null && invoiceUrl.isNotEmpty) {
          // 2. Download the actual PDF from the invoiceUrl
          final Directory directory = await getApplicationDocumentsDirectory();
          final String fileName = "Invoice_$orderId.pdf";
          final String filePath = "${directory.path}/$fileName";

          await dio.download(
            invoiceUrl,
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

          if (context.mounted) {
            _showSnackBar(context, "Invoice downloaded successfully");
          }

          // 3. Open File Automatically
          await OpenFilex.open(filePath);
        } else {
          throw Exception("Invoice URL not found in response");
        }
      } else {
        throw Exception("Failed to fetch invoice info: Status ${response.statusCode}");
      }

    } catch (e) {
      _isDownloading = false;
      notifyListeners();
      if (context.mounted) {
        _showSnackBar(context, "Download failed: $e");
      }
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
