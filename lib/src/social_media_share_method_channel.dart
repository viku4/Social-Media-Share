import 'package:flutter/services.dart';

class SocialMedia {
  static const MethodChannel _channel = MethodChannel(
    'social_media_share/channel',
  );

  static Future<void> shareWhatsApp({
    required String text,
    required String filePath,
  }) async {
    await _channel.invokeMethod('share_whatsapp', {
      'text': text,
      'filePath': filePath,
    });
  }

  static Future<void> shareFacebook({
    required String text,
    required String filePath,
  }) async {
    await _channel.invokeMethod('share_facebook', {
      'text': text,
      'filePath': filePath,
    });
  }

  static Future<void> shareInstagram({
    required String text,
    required String filePath,
  }) async {
    await _channel.invokeMethod('share_instagram', {
      'text': text,
      'filePath': filePath,
    });
  }

  static Future<void> shareAll({
    required String text,
    required String filePath,
  }) async {
    await _channel.invokeMethod('share_all', {
      'text': text,
      'filePath': filePath,
    });
  }

  static Future<void> copyLink({
    required String text,
  }) async {
    await _channel.invokeMethod('copy_link', {
      'text': text,
    });
  }
}
