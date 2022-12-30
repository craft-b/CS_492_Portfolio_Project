import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../screens/detail_screen.dart';

class PostsList extends StatefulWidget {
  const PostsList({Key? key}) : super(key: key);

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                // .orderBy('date', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData ||
                  snapshot.data!.docs.isEmpty ||
                  // ignore: unnecessary_null_comparison
                  snapshot.data!.docs == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var post = snapshot.data!.docs[index];
                            DateTime postTime = post['date'].toDate();
                            return Semantics(
                              button: true,
                              onTapHint:
                                  'Food waste post. Click for post details',
                              label: 'Food waste post. Click for post details',
                              child: ListTile(
                                trailing: Text(post['quantity'].toString(),
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                title: Text(
                                    DateFormat.yMMMMEEEEd().format(postTime),
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PostDetail(post: post)));
                                },
                              ),
                            );
                          }),
                    ),
                  ],
                );
              }
            }));
  }
}
