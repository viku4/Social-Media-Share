# social_media_share

A Flutter example demonstrating how to share text or images directly to social media platforms like WhatsApp, Facebook, and Instagram using the `social_media_share` plugin.

---

## ✨ Features
- Pick an image from the **gallery**
- Share **local images** or **image links**
- Share **custom text**
- Supports:
  - WhatsApp
  - Facebook
  - Instagram
  - Share via (system share)
  - Copy link
- Supports **horizontal** and **vertical** layouts

---

## ⚙️ Android Setup

### 1️⃣ Add provider configuration inside `<application>` in `AndroidManifest.xml`
```xml
<provider
    android:name="androidx.core.content.FileProvider"
    android:authorities="{your_package_name}.fileprovider"
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
                    defaultIconSizes: 25,
                    shareText: "Check this amazing app!",

                    // When share local image or image link
                    shareImage: (localImage != null)
                        ? localImage?.path ?? ""
                        : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9Ps5DnOMUWgera8mCAckZxJprf-ckcKgjmme1dsoezFVHUfmRyS5Le68&s",
                    direction: Axis.vertical,
                    // When share image link true or share image path false
                    isImageLink: (localImage != null) ? false : true,
                    spacing: 12,
                    defaultLabelStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    ),
                ),
        