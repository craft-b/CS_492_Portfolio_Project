import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'list_screen.dart';
import '../models/post.dart';

// ignore: must_be_immutable
class NewEntry extends StatefulWidget {
  String url;

  NewEntry({Key? key, required this.url}) : super(key: key);

  @override
  State<NewEntry> createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {
  final formKey = GlobalKey<FormState>();
  var now = DateTime.now();

  late Post newPost = Post(
    date: now,
    imageURL: '',
    longitude: 30,
    latitude: 29,
    quantity: 30,
  );

  Location location = Location();
  LocationData? locationData;

  @override
  void initState() {
    super.initState();
    getLocation();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Post')),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.height * 0.4,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Image.network(widget.url, fit: BoxFit.contain),
              ),
              const SizedBox(height: 10),
              Semantics(
                textField: true,
                label:
                    'Field for entering number of items wasted, cannot be empty',
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: 'Number of wasted items',
                    border: UnderlineInputBorder(),
                  ),
                  // ignore: missing_return
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter items wasted';
                    }
                    setState(() {
                      newPost.quantity = int.tryParse(value)!;
                    });
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Semantics(
            button: true,
            onTapHint: 'Save to new post',
            label: 'Save to new post',
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.deepPurple),
              ),
              child: const Icon(Icons.cloud_upload, size: 40),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  newPost.imageURL = widget.url;
                  newPost.date = DateTime.now();
                  newPost.latitude = locationData?.latitude ?? 0;
                  newPost.longitude = locationData?.longitude ?? 0;

                  FirebaseFirestore.instance.collection('posts').add({
                    'date': newPost.date,
                    'quantity': newPost.quantity,
                    'imageURL': newPost.imageURL,
                    'latitude': newPost.latitude,
                    'longitude': newPost.longitude,
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // var location = Location();

    try {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                      'Location Services must be enabled to continue.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ListScreen()));
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                );
              });
          return;
        }
      }

      locationData = await location.getLocation();
    } on PlatformException catch (err) {
      print('Error ${err.toString()}');
    }
  }
}
