import 'package:supabase_flutter/supabase_flutter.dart';

class QrCodeRepository {
  QrCodeRepository();

  SupabaseClient get supabase => Supabase.instance.client;

  Future<bool> validateQrCode(String code) async {
    try {
      final data = await supabase
          .from('tickets')
          .select('qr_code')
          .neq('status', 'used')
          .eq('qr_code', code)
          .maybeSingle();

      if (data == null) throw Exception('QR code not found or already used.');

      await markQrCodeAsUsed(code);

      return true;
    } catch (e) {
      throw Exception('Failed to validate QR code: $e');
    }
  }

  Future<void> markQrCodeAsUsed(String code) async {
    try {
      final response = await supabase
          .from('tickets')
          .update({'status': 'used'})
          .eq('qr_code', code);

      if (response == null) {
        throw Exception('Failed to mark QR code as used');
      }
    } catch (e) {
      throw Exception('Failed to mark QR code as used: $e');
    }
  }
}
