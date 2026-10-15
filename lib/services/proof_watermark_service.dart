import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

/// Service handling live camera proof capture, GPS tagging, watermark drawing, and Cloudinary upload.
class ProofWatermarkService {
  final ImagePicker _picker = ImagePicker();

  /// Captures photo strictly via live camera (no gallery allowed)
  Future<File?> captureLiveCameraPhoto() async {
    final XFile? captured = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 85,
    );
    if (captured == null) return null;
    return File(captured.path);
  }

  /// Retrieves live GPS coordinates with precision
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('GPS Location service is disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Draws tamper-proof timestamp and GPS coordinates watermark on the image
  Future<File> applyWatermark({
    required File originalFile,
    required Position position,
    required String batchOrOrderId,
  }) async {
    final Uint8List imageBytes = await originalFile.readAsBytes();
    final img.Image? decodedImage = img.decodeImage(imageBytes);

    if (decodedImage == null) {
      throw Exception('Failed to decode captured image.');
    }

    final timestampStr = DateFormat('yyyy-MM-dd HH:mm:ss \'IST\'').format(DateTime.now());
    final gpsStr = 'LAT: ${position.latitude.toStringAsFixed(4)} | LON: ${position.longitude.toStringAsFixed(4)}';
    final watermarkText = 'AndaExpress • $batchOrOrderId • $timestampStr • $gpsStr';

    // Draw string watermark in the bottom area of the image
    img.drawString(
      decodedImage,
      watermarkText,
      font: img.arial24,
      x: 20,
      y: decodedImage.height - 40,
      color: img.ColorRgb8(255, 255, 255),
    );

    final watermarkedBytes = img.encodeJpg(decodedImage, quality: 85);
    final watermarkedFile = File('${originalFile.path}_watermarked.jpg');
    await watermarkedFile.writeAsBytes(watermarkedBytes);
    return watermarkedFile;
  }

  /// Uploads photo directly to Cloudinary unsigned upload preset via HTTP
  Future<String> uploadToCloudinary({
    required File imageFile,
    required String cloudName,
    required String uploadPreset,
  }) async {
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = uploadPreset;
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Cloudinary direct upload failed with status: ${response.statusCode}');
    }

    final respStr = await response.stream.bytesToString();
    final jsonMap = jsonDecode(respStr) as Map<String, dynamic>;
    return jsonMap['secure_url'] as String;
  }
}
