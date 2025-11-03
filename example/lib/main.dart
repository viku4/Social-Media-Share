import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_share/social_media_share.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _pickedFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Column(
                  spacing: 15,
                  children: [
                    if (_pickedFile != null) Image.file(_pickedFile!),

                    ElevatedButton(
                      onPressed: () async {
                        final XFile? photo = await _picker.pickImage(
                          source: ImageSource.gallery,
                        );

                        if (photo != null) {
                          _pickedFile = File(photo.path);
                        } else {
                          _pickedFile = null;
                        }
                        setState(() {});
                      },
                      child: Text(
                        "Choose Image Gallery",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(10),
                ),
                color: Colors.transparent,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              alignment: Alignment.center,
              child: SocialMediaShare(
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
                shareImage: (_pickedFile != null)
                    ? _pickedFile?.path ?? ""
                    : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9Ps5DnOMUWgera8mCAckZxJprf-ckcKgjmme1dsoezFVHUfmRyS5Le68&s",
                direction: Axis.vertical,
                isImageLink: (_pickedFile != null) ? false : true,
                spacing: 12,
                defaultLabelStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
