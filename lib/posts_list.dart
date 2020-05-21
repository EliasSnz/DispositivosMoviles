import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postsapp/post_class.dart';

class PostsList extends StatefulWidget {
  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  String url = "https://jsonplaceholder.typicode.com/posts";
  PostClass postClass;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await http.get(url);
    var decodedJson = jsonDecode(response.body);
    postClass = PostClass.fromJson(decodedJson);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        backgroundColor: Colors.cyan,
      ),
      drawer: Drawer(),
      body: postClass == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              crossAxisCount: 2,
              children: postClass.post
                  .map((p) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () {

                            //Navigator.push(context,MaterialPageRoute(
                                   // builder: (context) =>Comments(pokemon: p,)));
                          },child: Hero(tag: p.id,child: Card(
                              elevation: 3.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    p.title,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    p.body,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
    );
  }
}
