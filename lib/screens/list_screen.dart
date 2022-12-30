import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'new_post.dart';
import '../widgets/posts_list.dart';
import '../widgets/update_title.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  File? image;
  final ImagePicker _picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {});
    }

    var currentTime = '${DateTime.now()}.jpg';
    Reference storageReference =
        FirebaseStorage.instance.ref().child(currentTime);
    UploadTask uploadTask = storageReference.putFile(image!);
    await uploadTask;
    final url = await storageReference.getDownloadURL();
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewEntry(url: url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const UpdateTitle(),
      ),
      body: const PostsList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Semantics(
        button: true,
        onTapHint: 'Select a photo',
        label: 'Select a photo',
        child: FloatingActionButton(
          child: const Icon(Icons.camera_alt_rounded),
          onPressed: () {
            getImage();
          },
        ),
      ),
    );
  }
}
