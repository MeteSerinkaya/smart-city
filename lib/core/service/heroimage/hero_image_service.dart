import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:smart_city/core/init/network/network_manager.dart';
import 'package:smart_city/view/authentication/test/model/heroimagemodel/hero_image_model.dart';

abstract class IHeroImageService {
  Future<List<HeroImageModel>?> fetchHeroImages();
  Future<HeroImageModel?> addHeroImage(HeroImageModel model);
  Future<HeroImageModel?> updateHeroImage(HeroImageModel model);
  Future<bool> deleteHeroImage(int id);
  Future<HeroImageModel?> getLatestHeroImage();
  Future<HeroImageModel?> getHeroImageById(int id);
  Future<HeroImageModel?> uploadImage(dynamic imageFile, String title, String description);
}

class HeroImageService extends IHeroImageService {
  final NetworkManager _networkManager = NetworkManager.instance;
  final String _baseUrl = 'https://localhost:7276/api/HeroImage';

  @override
  Future<List<HeroImageModel>?> fetchHeroImages() async {
    try {
      final response = await _networkManager.dioGet('HeroImage', HeroImageModel());
      if (response != null && response is List) {
        return response.cast<HeroImageModel>();
      }
      return null;
    } catch (e) {
      print("HeroImageService fetchHeroImages error: $e");
      return null;
    }
  }

  @override
  Future<HeroImageModel?> addHeroImage(HeroImageModel model) async {
    try {
      final data = model.toJson();
      data.remove('id');
      final response = await _networkManager.dio.post('HeroImage', data: data);

      if (response.statusCode == 201) {
        return HeroImageModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("HeroImageService addHeroImage error: $e");
      return null;
    }
  }

  @override
  Future<HeroImageModel?> updateHeroImage(HeroImageModel model) async {
    try {
      final response = await _networkManager.dio.put('HeroImage/${model.id}', data: model.toJson());

      if (response.statusCode == 204) {
        return model; // PUT returns 204 No Content, so return the updated model
      }
      return null;
    } catch (e) {
      print("HeroImageService updateHeroImage error: $e");
      return null;
    }
  }

  @override
  Future<bool> deleteHeroImage(int id) async {
    try {
      final response = await _networkManager.dio.delete('HeroImage/$id');
      return response.statusCode == 204;
    } catch (e) {
      print("HeroImageService deleteHeroImage error: $e");
      return false;
    }
  }

  @override
  Future<HeroImageModel?> getLatestHeroImage() async {
    try {
      final response = await _networkManager.dio.get('HeroImage/latest');

      if (response.statusCode == 200) {
        return HeroImageModel.fromJson(response.data);
      } else if (response.statusCode == 404) {
        return null;
      }
      return null;
    } catch (e) {
      print("HeroImageService getLatestHeroImage error: $e");
      return null;
    }
  }

  @override
  Future<HeroImageModel?> getHeroImageById(int id) async {
    try {
      final response = await _networkManager.dio.get('HeroImage/$id');

      if (response.statusCode == 200) {
        return HeroImageModel.fromJson(response.data);
      } else if (response.statusCode == 404) {
        return null;
      }
      return null;
    } catch (e) {
      print("HeroImageService getHeroImageById error: $e");
      return null;
    }
  }

  @override
  Future<HeroImageModel?> uploadImage(dynamic imageFile, String title, String description) async {
    try {
      print('uploadImage() başladı');

      if (kIsWeb && imageFile is Uint8List) {
        return await _uploadImageWeb(imageFile, title, description);
      } else if (!kIsWeb && imageFile is File) {
        return await _uploadImageMobile(imageFile, title, description);
      } else {
        throw Exception('Desteklenmeyen dosya formatı');
      }
    } catch (e) {
      print('Upload error: $e');
      throw Exception('Error uploading image: $e');
    }
  }

  Future<HeroImageModel?> _uploadImageWeb(Uint8List imageBytes, String title, String description) async {
    print('Web upload başladı');
    print('Dosya boyutu: ${imageBytes.length} bytes');

    try {
      // Create multipart request for web
      final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/upload'));

      // Add file to request using bytes
      final multipartFile = http.MultipartFile.fromBytes(
        'Image', // This should match the backend parameter name
        imageBytes,
        filename: 'web_upload_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      request.files.add(multipartFile);

      // Add title and description fields
      request.fields['Title'] = title;
      request.fields['Description'] = description;

      print('Web request gönderiliyor...');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Web upload response status: ${response.statusCode}');
      print('Web upload response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        // The backend returns {fileName, url} but we need to create a HeroImageModel
        // We'll need to fetch the latest image to get the full model
        return await getLatestHeroImage();
      } else {
        print('Web upload failed: ${response.statusCode}');
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      print('Web upload error: $e');
      throw Exception('Error uploading image on web: $e');
    }
  }

  Future<HeroImageModel?> _uploadImageMobile(File imageFile, String title, String description) async {
    print('Mobile upload başladı');
    print('Dosya yolu: ${imageFile.path}');
    print('Dosya boyutu: ${await imageFile.length()} bytes');

    try {
      // Create multipart request for mobile
      final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/upload'));

      // Add file to request
      final fileStream = http.ByteStream(imageFile.openRead());
      final fileLength = await imageFile.length();

      final multipartFile = http.MultipartFile(
        'Image', // This should match the backend parameter name
        fileStream,
        fileLength,
        filename: imageFile.path.split('/').last,
      );

      request.files.add(multipartFile);

      // Add title and description fields
      request.fields['Title'] = title;
      request.fields['Description'] = description;

      print('Mobile request gönderiliyor...');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Mobile upload response status: ${response.statusCode}');
      print('Mobile upload response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        // The backend returns {fileName, url} but we need to create a HeroImageModel
        // We'll need to fetch the latest image to get the full model
        return await getLatestHeroImage();
      } else {
        print('Mobile upload failed: ${response.statusCode}');
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      print('Mobile upload error: $e');
      throw Exception('Error uploading image on mobile: $e');
    }
  }
}
