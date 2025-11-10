import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:barber_time/app/data/local/shared_prefs.dart';
import 'package:barber_time/app/services/api_client.dart';
import 'package:barber_time/app/services/api_url.dart';
import 'package:barber_time/app/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class QrCodeController extends GetxController {
  // Observable for QR code data
  final Rx<String> qrData = ''.obs;

  // Loading state
  final RxBool isGenerating = false.obs;
  final RxBool isPrinting = false.obs;
  final RxBool isDownloading = false.obs;
  final RxBool isSendingToServer = false.obs;
  final RxBool dataSentSuccessfully = false.obs;
  final RxBool isRegenerating = false.obs;

  // GlobalKey for capturing QR code widget
  final GlobalKey qrKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    initializeQrCode();
  }

  /// Initialize QR code and send to server
  Future<void> initializeQrCode() async {
    final bool qrCode =
        await SharePrefsHelper.getBool(AppConstants.qrCode.toString()) ?? false;
    debugPrint('QR Code initialized: $qrCode');
    if (qrCode) {
      await getQrInfo();
      await generateQrCode();
      return;
    } else {
      await generateQrCode();
      await Future.delayed(
          const Duration(milliseconds: 500)); // Small delay for animation
      await qrCodeinfoSentToServer();
    }
  }

  //get qr info
  Future<void> getQrInfo() async {
    isSendingToServer.value = true;
    dataSentSuccessfully.value = false;
    try {
      final respinse = await ApiClient.getData(ApiUrl.getQrCodeInfo);
      if (respinse.statusCode == 200 || respinse.statusCode == 201) {
        final body =
            respinse.body is String ? jsonDecode(respinse.body) : respinse.body;
        // Fix: data is a List, not a Map
        if (body['data'] is List && body['data'].isNotEmpty) {
          qrData.value = body['data'][0]['code'];
          dataSentSuccessfully.value = true;
          print('✅ QR Code info fetched successfully: ${qrData.value}');
        } else {
          dataSentSuccessfully.value = false;
          print('❌ QR code info: data list is empty');
        }
      } else {
        dataSentSuccessfully.value = false;
        print(
            '❌ Failed to load QR code info: ${respinse.statusCode} - ${respinse.body}');
      }
    } catch (e) {
      dataSentSuccessfully.value = false;
      print('Error getting QR code info: $e');
    } finally {
      isSendingToServer.value = false;
      debugPrint('Get QR code info completed.${dataSentSuccessfully.value}');
    }
  }

  /// Generate QR code data based on owner information
  Future<void> generateQrCode() async {
    try {
      isGenerating.value = true;

      if (qrData.value.isEmpty) {
        final token =
            await SharePrefsHelper.getString(AppConstants.bearerToken);

        print(
            '🔍 QR Code Debug - Token: ${token.isNotEmpty ? "Token exists" : "No token"}');

        String userId = '';
        String userEmail = '';

        // Decode JWT token to get both userId and email
        if (token.isNotEmpty) {
          try {
            Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
            userId = decodedToken['_id'] ??
                decodedToken['id'] ??
                decodedToken['userId'] ??
                '';
            userEmail = decodedToken['email'] ?? '';
            print('🔍 QR Code Debug - UserId from token: $userId');
            print('🔍 QR Code Debug - Email from token: $userEmail');
            print('🔍 QR Code Debug - Full token data: $decodedToken');
          } catch (e) {
            print('❌ Error decoding token: $e');
          }
        }

        if (userId.isNotEmpty && userId != '') {
          // Create QR code data with shop/owner information

          final Map<String, dynamic> qrInfo = {
            'userId': userId,
            'email': userEmail,
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          };
          qrData.value = '$userId-$userEmail-${qrInfo['timestamp']}';

          print('✅ QR Code generated with userId and email');
        } else {
          print('⚠️ UserId is empty, using fallback');
        }
      }
    } catch (e) {
      print('Error generating QR code: $e');
    } finally {
      isGenerating.value = false;
    }
  }

  /// Regenerate QR code
  Future<void> regenerateQrCode() async {
    isRegenerating.value = true;
    await Future.delayed(
        const Duration(milliseconds: 300)); // Wait for animation
    await generateQrCode();
    await Future.delayed(const Duration(milliseconds: 500));
    await qrCodeinfoSentToServer();
    isRegenerating.value = false;
  }

  /// Get QR code data as string
  String getQrData() {
    return qrData.value;
  }

  /// Capture QR code widget as image
  Future<Uint8List?> _captureQrCodeImage() async {
    try {
      RenderRepaintBoundary boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('❌ Error capturing QR code image: $e');
      return null;
    }
  }

  /// Print QR code as PDF
  Future<void> printQrCode() async {
    try {
      isPrinting.value = true;

      // Capture QR code as image
      final imageBytes = await _captureQrCodeImage();
      if (imageBytes == null) {
        Get.snackbar(
          'Error',
          'Failed to capture QR code',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Create PDF document
      final pdf = pw.Document();
      final image = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Barber Shop QR Code',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Container(
                    width: 300,
                    height: 300,
                    child: pw.Image(image),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Scan this code to access the barber shop',
                    style: const pw.TextStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Print the PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );

      Get.snackbar(
        'Success',
        'QR Code sent to printer',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('❌ Error printing QR code: $e');
      Get.snackbar(
        'Error',
        'Failed to print QR code: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isPrinting.value = false;
    }
  }

  /// Download QR code as PNG
  Future<void> downloadQrCode(BuildContext context) async {
    try {
      isDownloading.value = true;

      // Request storage permission for Android 12 and below
      if (Platform.isAndroid) {
        var status = await Permission.photos.status;
        if (!status.isGranted) {
          status = await Permission.photos.request();
          if (!status.isGranted) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.white),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Photos permission is required to save images',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 3),
                ),
              );
            }
            return;
          }
        }
      }

      // Capture QR code as image
      final imageBytes = await _captureQrCodeImage();
      if (imageBytes == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    'Failed to capture QR code',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      // Save image to temporary file
      final tempDir = await getTemporaryDirectory();
      final fileName =
          'barber_shop_qr_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);

      // Save to gallery using gal
      await Gal.putImage(file.path, album: 'Barber Time');

      // Delete temporary file
      await file.delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline,
                    color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'QR Code saved successfully!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Saved to gallery in "Barber Time" album',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: .9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        );
      }
    } catch (e) {
      print('❌ Error downloading QR code: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Failed to download QR code: $e',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      isDownloading.value = false;
    }
  }

  Future<bool> qrCodeinfoSentToServer() async {
    try {
      isSendingToServer.value = true;
      dataSentSuccessfully.value = false;

      // // Parse the QR data JSON
      // final qrDataList= qrData.value.split('-');
      // final qrDataMap = {
      //   'userId': qrDataList[0],
      //   'email': qrDataList[1],
      //   'timestamp': qrDataList[2],
      // };

      final data = {
        'code': qrData.value.toString(),
      };

      final response = await ApiClient.postData(
        ApiUrl.sendQrCodeInfo,
        jsonEncode(data),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        dataSentSuccessfully.value = false;

        Get.snackbar(
          'Info',
          'QR Code generated but not synced to server',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.withValues(alpha: .8),
          colorText: Colors.white,
          icon: const Icon(Icons.info_outline, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
        return false;
      }

      print('✅ QR Code info sent to server successfully');
      dataSentSuccessfully.value = true;

      Get.snackbar(
        'Success',
        'QR Code synced to server successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withValues(alpha: .8),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
      return true;
    } catch (e) {
      print('❌ Error sending QR code info to server: $e');
      dataSentSuccessfully.value = false;

      Get.snackbar(
        'Info',
        'QR Code generated locally',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.withValues(alpha: .8),
        colorText: Colors.white,
        icon: const Icon(Icons.cloud_off, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
      return false;
    } finally {
      isSendingToServer.value = false;
    }
  }
}
