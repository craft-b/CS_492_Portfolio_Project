import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class PostDetail extends StatelessWidget {
  DocumentSnapshot post;

  PostDetail({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime postTime = post['date'].toDate();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Wasteagram'),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                // .orderBy('date', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
              // ignore: unnecessary_null_comparison
              // snapshot.data!.docs == null
              {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(DateFormat.yMMMMEEEEd().format(postTime),
                            style: const TextStyle(fontSize: 20)),
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.height * 0.4,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Image.network(post['imageURL'],
                              fit: BoxFit.contain),
                        ),
                        Text("${post['quantity']} items",
                            style: const TextStyle(fontSize: 18)),
                        Text('Location: (${post['latitude'].toString()}, '
                            '${post['longitude'].toString()})')
                      ],
                    ),
                  ),
                );
              }
            }));
  }
}
