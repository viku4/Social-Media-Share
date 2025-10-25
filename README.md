# social_media_share

A Flutter plugin for sharing text and images to social media platforms.

## Features
- Share text and images
- Supports WhatsApp (and extendable to others)

## Usage
```dart

///  Add Line AndroidManifest.xml Application 
        <provider
            android:name="androidx.core.content.FileProvider"
            android:authorities="{Add Package Name}.fileprovider"
            android:exported="false"
            android:grantUriPermissions="true"
            tools:replace="android:authorities">

            <meta-data
                android:name="android.support.FILE_PROVIDER_PATHS"
                android:resource="@xml/file_paths"
                tools:replace="android:resource"/>
        </provider>


/// Add android\app\src\main\res\xml\file_paths.xml
<?xml version="1.0" encoding="utf-8"?>
<paths xmlns:android="http://schemas.android.com/apk/res/android">
    <external-path name="external_files" path="." />
    <cache-path name="shared_images" path="." />

</paths>


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
