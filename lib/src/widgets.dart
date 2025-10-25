import 'package:flutter/material.dart';
import 'social_media_share_method_channel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Supported social media platforms
enum SocialPlatform { whatsapp, facebook, instagram, share_via, copy_link }

/// Fully customizable social media share buttons
class SocialMediaShare extends StatelessWidget {
  final List<SocialPlatform> platforms;
  final String shareText;
  final String shareImage;
  final EdgeInsetsGeometry? iconPadding;
  final EdgeInsetsGeometry? iconMargin;
  final Axis direction;
  final double spacing;
  final TextStyle defaultLabelStyle;
  final Color? defaultLabelColors;
  final double? defaultLabelSizes;

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
    this.defaultLabelSizes = 20,
    this.iconPadding,
    this.iconMargin,
  });

  @override
  Widget build(BuildContext context) {
    final Map<SocialPlatform, Widget> defaultIcons = {
      SocialPlatform.whatsapp: FaIcon(
        FontAwesomeIcons.whatsapp,
        color: Colors.green,
        size: direction == Axis.horizontal ? 30 : 50,
      ),
      SocialPlatform.facebook: FaIcon(
        FontAwesomeIcons.facebook,
        color: Colors.blue,
        size: direction == Axis.horizontal ? 30 : 50,
      ),
      SocialPlatform.instagram: FaIcon(
        FontAwesomeIcons.instagram,
        color: Colors.purple,
        size: direction == Axis.horizontal ? 30 : 50,
      ),
      SocialPlatform.share_via: FaIcon(
        FontAwesomeIcons.share,
        color: Colors.black,
        size: direction == Axis.horizontal ? 30 : 50,
      ),
      SocialPlatform.copy_link: FaIcon(
        FontAwesomeIcons.link,
        color: Colors.grey,
        size: direction == Axis.horizontal ? 30 : 50,
      ),
    };
    return Flex(
      direction: direction,
      spacing: spacing,
      mainAxisAlignment: MainAxisAlignment.center,
      children: platforms.map((platform) {
        final String label = _capitalize(platform.toString().split('.').last);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => onClick(platform, shareText, shareImage, context),
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
    );
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}

Future onClick(
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
