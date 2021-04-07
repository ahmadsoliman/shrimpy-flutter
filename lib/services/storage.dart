import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Create storage
  final storage = new FlutterSecureStorage();

  Future<String> readValue(String key) async {
    // Read value
    return await storage.read(key: key);
  }

  Future<Map<String, String>> readAll() async {
    // Read All
    return await storage.readAll();
  }

  Future<void> deleteValue(String key) async {
    // Delete value
    return await storage.delete(key: key);
  }

  Future<void> deleteAll(String key) async {
    // Delete all
    return await storage.deleteAll();
  }

  Future<void> writeValue(String key, String value) async {
    // Write value
    return await storage.write(key: key, value: value);
  }
}
