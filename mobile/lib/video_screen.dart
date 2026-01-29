import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  File? image;
  String ratio = "9:16";
  String status = "";
  final prompt = TextEditingController();

  pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => image = File(picked.path));
  }

  generateVideo() async {
    if (image == null || prompt.text.isEmpty) return;

    setState(() => status = "Generating 30s video...");

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("http://YOUR_IP:5000/api/image-prompt-to-video"),
    );

    request.fields["prompt"] = prompt.text;
    request.fields["ratio"] = ratio;
    request.files.add(
      await http.MultipartFile.fromPath("image", image!.path),
    );

    final response = await request.send();
    final body = await response.stream.bytesToString();
    final data = jsonDecode(body);

    final videoUrl = data["video_url"];

    final dir = await getExternalStorageDirectory();
    final file = File("${dir!.path}/vidiofy_30s.mp4");

    final videoRes = await http.get(Uri.parse(videoUrl));
    await file.writeAsBytes(videoRes.bodyBytes);

    setState(() => status = "✅ Video saved to gallery");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vidiofy")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Upload Image"),
            ),
            TextField(
              controller: prompt,
              decoration: const InputDecoration(
                hintText: "Enter video prompt",
              ),
            ),
            DropdownButton(
              value: ratio,
              items: ["9:16", "16:9"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => ratio = v!),
            ),
            ElevatedButton(
              onPressed: generateVideo,
              child: const Text("Generate 30s Video"),
            ),
            const SizedBox(height: 10),
            Text(status),
          ],
        ),
      ),
    );
  }
}
