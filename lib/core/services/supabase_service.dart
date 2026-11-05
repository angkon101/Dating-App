import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static bool _isInitialized = false;
  static bool get isConfigured => _isInitialized;

  /// Call this with your project credentials from https://supabase.com
  static Future<void> initialize({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) async {
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      debugPrint('[SupabaseService] No credentials provided, running in offline demo mode.');
      _isInitialized = false;
      return;
    }

    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey, // ignore: deprecated_member_use
      );
      _isInitialized = true;
      debugPrint('[SupabaseService] Successfully connected to live Supabase backend.');
    } catch (e) {
      debugPrint('[SupabaseService] Initialization failed ($e), falling back to demo mode.');
      _isInitialized = false;
    }
  }

  static SupabaseClient? get client {
    if (!_isInitialized) return null;
    return Supabase.instance.client;
  }
}

