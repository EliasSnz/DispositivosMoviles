import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postsapp/post_class.dart';
import 'package:postsapp/posts_detail.dart';

class PostsList extends StatefulWidget {
  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  String url = "https://raw.githubusercontent.com/EliasSnz/DispositivosMoviles/master/Source/posts";
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
        backgroundColor: Colors.grey,
      ),
      drawer: Drawer(),
      body: postClass == null ? Center(child: CircularProgressIndicator(),): ListView(
        children: postClass.post.map((e) => InkWell(
          onTap: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => PostsDetail(post: e)));
          },
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              elevation: 3.0,
              child: ListTile(
                leading: Icon(Icons.account_circle,size: 40,),
                title: Text(e.title, style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text(e.body.substring(0,30) + "..."),
              ),
            ),
          ),
        )).toList(),
      )
    );
  }
}
