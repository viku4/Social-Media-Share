# social_media_share

A Flutter plugin for sharing text and images to social media platforms.

## Features
- Share text and images
- Supports WhatsApp (and extendable to others)

## Usage
```dart
import 'package:social_media_share/social_media_share.dart';

SocialMediaShare(
    platforms: [
        SocialPlatform.whatsapp,
        SocialPlatform.facebook,
        SocialPlatform.instagram,
        SocialPlatform.share_via,
        SocialPlatform.copy_link,
        ],
        iconPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        shareText: "Check this amazing app!",
        shareImage: path, /// local system  image path
        direction: Axis.horizontal,
        spacing: 12,
        defaultLabelStyle: TextStyle(fontSize: 12, color: Colors.black),
),               
