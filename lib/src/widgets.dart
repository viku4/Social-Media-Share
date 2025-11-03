import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'social_media_share_method_channel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Supported social media platforms
enum SocialPlatform { whatsapp, facebook, instagram, share_via, copy_link }

/// Fully customizable social media share buttons
class SocialMediaShare extends StatelessWidget {
  final List<SocialPlatform> platforms;
  final String shareText;
  final bool isImageLink;
  final String shareImage;
  final EdgeInsetsGeometry? iconPadding;
  final EdgeInsetsGeometry? iconMargin;
  final Axis direction;
  final double spacing;
  final TextStyle defaultLabelStyle;
  final Color? defaultLabelColors;
  final double? defaultIconSizes;

  final Map<SocialPlatform, Widget>? customIcons;
  final Map<SocialPlatform, Widget>? customLabels;

  const SocialMediaShare({
    super.key,
    required this.platforms,
    required this.shareText,
    required this.shareImage,
    this.direction = Axis.horizontal,
    this.spacing = 16,
    this.defaultLabelStyle = const TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
    this.customIcons,
    this.customLabels,
    this.defaultLabelColors = Colors.black,
    this.iconPadding,
    this.iconMargin,
    this.isImageLink = true,
    this.defaultIconSizes,
  });

  @override
  Widget build(BuildContext context) {
    final Map<SocialPlatform, Widget> defaultIcons = {
      SocialPlatform.whatsapp: FaIcon(
        FontAwesomeIcons.whatsapp,
        color: Colors.green,
        size: defaultIconSizes != null
            ? defaultIconSizes
            : direction == Axis.horizontal
            ? 30
            : 50,
      ),
      SocialPlatform.facebook: FaIcon(
        FontAwesomeIcons.facebook,
        color: Colors.blue,
        size: defaultIconSizes != null
            ? defaultIconSizes
            : direction == Axis.horizontal
            ? 30
            : 50,
      ),
      SocialPlatform.instagram: FaIcon(
        FontAwesomeIcons.instagram,
        color: Colors.purple,
        size: defaultIconSizes != null
            ? defaultIconSizes
            : direction == Axis.horizontal
            ? 30
            : 50,
      ),
      SocialPlatform.share_via: FaIcon(
        FontAwesomeIcons.share,
        color: Colors.black,
        size: defaultIconSizes != null
            ? defaultIconSizes
            : direction == Axis.horizontal
            ? 30
            : 50,
      ),
      SocialPlatform.copy_link: FaIcon(
        FontAwesomeIcons.link,
        color: Colors.grey,
        size: defaultIconSizes != null
            ? defaultIconSizes
            : direction == Axis.horizontal
            ? 30
            : 50,
      ),
    };
    return SingleChildScrollView(
      scrollDirection: direction,
      child: Flex(
        direction: direction,
        spacing: spacing,
        mainAxisAlignment: MainAxisAlignment.center,
        children: platforms.map((platform) {
          final String label = _capitalize(platform.toString().split('.').last);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => onClick(
                  platform,
                  shareText,
                  shareImage,
                  isImageLink,
                  context,
                ),
                child: Container(
                  padding: iconPadding ?? EdgeInsets.all(10),
                  margin: iconMargin ?? EdgeInsets.all(5),
                  child: customIcons?[platform] ?? defaultIcons[platform],
                ),
              ),

              customLabels?[platform] ?? Text(label, style: defaultLabelStyle),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}

Future onClick(
  SocialPlatform platform,
  String shareText,
  String shareImagePath,
  bool isImageLink,
  BuildContext context,
) async {
  try {
    String? localImagePath = shareImagePath;
    // If image is a link, download it and convert to file
    if (isImageLink) {
      final tempDir = await getTemporaryDirectory();
      final fileName =
          "shared_image_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final filePath = "${tempDir.path}/$fileName";
      final response = await http.get(Uri.parse(shareImagePath));

      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        localImagePath = file.path;
        debugPrint("Image downloaded to: $localImagePath");
      } else {
        debugPrint("Failed to download image from URL.");
      }
    }

    // Call native sharing logic with local file path
    await _shareToPlatform(platform, shareText, localImagePath, context);
  } catch (e) {
    debugPrint("Error sharing: $e");
  }
}

Future _shareToPlatform(
  SocialPlatform platform,
  String shareText,
  String shareImagePath,
  BuildContext context,
) async {
  switch (platform) {
    case SocialPlatform.whatsapp:
      await SocialMedia.shareWhatsApp(
        text: shareText,
        filePath: shareImagePath,
      );
      break;

    case SocialPlatform.facebook:
      await SocialMedia.shareFacebook(
        text: shareText,
        filePath: shareImagePath,
      );
      break;

    case SocialPlatform.instagram:
      await SocialMedia.shareInstagram(
        text: shareText,
        filePath: shareImagePath,
      );
      break;

    case SocialPlatform.copy_link:
      await SocialMedia.copyLink(text: shareText);
      break;
    case SocialPlatform.share_via:
      await SocialMedia.shareAll(text: shareText, filePath: shareImagePath);
      break;
  }
}
