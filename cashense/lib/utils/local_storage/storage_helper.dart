import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

/// Helper class for local storage operations using SharedPreferences and FlutterSecureStorage
class StorageHelper {
  StorageHelper._();

  // SharedPreferences instance
  static SharedPreferences? _prefs;
  
  // FlutterSecureStorage instance
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Ensure SharedPreferences is initialized
  static Future<SharedPreferences> get _preferences async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  // ==================== SharedPreferences Methods ====================

  /// Save string to SharedPreferences
  static Future<bool> setString(String key, String value) async {
    final prefs = await _preferences;
    return await prefs.setString(key, value);
  }

  /// Get string from SharedPreferences
  static Future<String?> getString(String key) async {
    final prefs = await _preferences;
    return prefs.getString(key);
  }

  /// Save int to SharedPreferences
  static Future<bool> setInt(String key, int value) async {
    final prefs = await _preferences;
    return await prefs.setInt(key, value);
  }

  /// Get int from SharedPreferences
  static Future<int?> getInt(String key) async {
    final prefs = await _preferences;
    return prefs.getInt(key);
  }

  /// Save double to SharedPreferences
  static Future<bool> setDouble(String key, double value) async {
    final prefs = await _preferences;
    return await prefs.setDouble(key, value);
  }

  /// Get double from SharedPreferences
  static Future<double?> getDouble(String key) async {
    final prefs = await _preferences;
    return prefs.getDouble(key);
  }

  /// Save bool to SharedPreferences
  static Future<bool> setBool(String key, bool value) async {
    final prefs = await _preferences;
    return await prefs.setBool(key, value);
  }

  /// Get bool from SharedPreferences
  static Future<bool?> getBool(String key) async {
    final prefs = await _preferences;
    return prefs.getBool(key);
  }

  /// Save list of strings to SharedPreferences
  static Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await _preferences;
    return await prefs.setStringList(key, value);
  }

  /// Get list of strings from SharedPreferences
  static Future<List<String>?> getStringList(String key) async {
    final prefs = await _preferences;
    return prefs.getStringList(key);
  }

  /// Save object as JSON to SharedPreferences
  static Future<bool> setObject(String key, Map<String, dynamic> value) async {
    final jsonString = jsonEncode(value);
    return await setString(key, jsonString);
  }

  /// Get object from JSON in SharedPreferences
  static Future<Map<String, dynamic>?> getObject(String key) async {
    final jsonString = await getString(key);
    if (jsonString != null) {
      try {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        Get.printError(info: 'Error decoding JSON for key $key: $e');
        return null;
      }
    }
    return null;
  }

  /// Remove key from SharedPreferences
  static Future<bool> remove(String key) async {
    final prefs = await _preferences;
    return await prefs.remove(key);
  }

  /// Clear all SharedPreferences
  static Future<bool> clear() async {
    final prefs = await _preferences;
    return await prefs.clear();
  }

  /// Check if key exists in SharedPreferences
  static Future<bool> containsKey(String key) async {
    final prefs = await _preferences;
    return prefs.containsKey(key);
  }

  /// Get all keys from SharedPreferences
  static Future<Set<String>> getAllKeys() async {
    final prefs = await _preferences;
    return prefs.getKeys();
  }

  // ==================== FlutterSecureStorage Methods ====================

  /// Save secure string
  static Future<void> setSecureString(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (e) {
      Get.printError(info: 'Error saving secure string for key $key: $e');
      rethrow;
    }
  }

  /// Get secure string
  static Future<String?> getSecureString(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      Get.printError(info: 'Error reading secure string for key $key: $e');
      return null;
    }
  }

  /// Save secure object as JSON
  static Future<void> setSecureObject(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      await _secureStorage.write(key: key, value: jsonString);
    } catch (e) {
      Get.printError(info: 'Error saving secure object for key $key: $e');
      rethrow;
    }
  }

  /// Get secure object from JSON
  static Future<Map<String, dynamic>?> getSecureObject(String key) async {
    try {
      final jsonString = await _secureStorage.read(key: key);
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      Get.printError(info: 'Error reading secure object for key $key: $e');
      return null;
    }
  }

  /// Remove secure key
  static Future<void> removeSecure(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      Get.printError(info: 'Error removing secure key $key: $e');
      rethrow;
    }
  }

  /// Clear all secure storage
  static Future<void> clearSecure() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      Get.printError(info: 'Error clearing secure storage: $e');
      rethrow;
    }
  }

  /// Check if secure key exists
  static Future<bool> containsSecureKey(String key) async {
    try {
      final value = await _secureStorage.read(key: key);
      return value != null;
    } catch (e) {
      Get.printError(info: 'Error checking secure key $key: $e');
      return false;
    }
  }

  /// Get all secure keys
  static Future<Map<String, String>> getAllSecureKeys() async {
    try {
      return await _secureStorage.readAll();
    } catch (e) {
      Get.printError(info: 'Error getting all secure keys: $e');
      return {};
    }
  }

  // ==================== Utility Methods ====================

  /// Get storage size (approximate)
  static Future<int> getStorageSize() async {
    try {
      final prefs = await _preferences;
      final keys = prefs.getKeys();
      int totalSize = 0;
      
      for (final key in keys) {
        final value = prefs.get(key);
        if (value != null) {
          totalSize += key.length + value.toString().length;
        }
      }
      
      return totalSize;
    } catch (e) {
      Get.printError(info: 'Error calculating storage size: $e');
      return 0;
    }
  }

  /// Export all data (non-secure only)
  static Future<Map<String, dynamic>> exportData() async {
    try {
      final prefs = await _preferences;
      final keys = prefs.getKeys();
      final Map<String, dynamic> data = {};
      
      for (final key in keys) {
        data[key] = prefs.get(key);
      }
      
      return data;
    } catch (e) {
      Get.printError(info: 'Error exporting data: $e');
      return {};
    }
  }

  /// Import data (non-secure only)
  static Future<bool> importData(Map<String, dynamic> data) async {
    try {
      final prefs = await _preferences;
      
      for (final entry in data.entries) {
        final key = entry.key;
        final value = entry.value;
        
        if (value is String) {
          await prefs.setString(key, value);
        } else if (value is int) {
          await prefs.setInt(key, value);
        } else if (value is double) {
          await prefs.setDouble(key, value);
        } else if (value is bool) {
          await prefs.setBool(key, value);
        } else if (value is List<String>) {
          await prefs.setStringList(key, value);
        }
      }
      
      return true;
    } catch (e) {
      Get.printError(info: 'Error importing data: $e');
      return false;
    }
  }
}