import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:social_media_share/social_media_share.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String path = "";
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      path = await data();
      setState(() {});
    });
  }

  Future<String> data() async {
    final tempDir = await getTemporaryDirectory();
    final path = "${tempDir.path}/shared_images.jpg";

    final res = await http.get(
      Uri.parse(
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9Ps5DnOMUWgera8mCAckZxJprf-ckcKgjmme1dsoezFVHUfmRyS5Le68&s",
      ),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to download image");
    }

    final file = File(path);
    await file.writeAsBytes(res.bodyBytes);
    log("File :- ${File(path).existsSync()} $path");
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          child: Column(
            children: [
              if (path != "") Image.file(File(path)),
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
                shareImage: path,
                direction: Axis.horizontal,
                spacing: 12,
                defaultLabelStyle: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
