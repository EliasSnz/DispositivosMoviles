import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      backgroundColor: Color(0xff000000),
      appBar: AppBar(
        title: Center(child: Text("POSTS")),
        backgroundColor: Color(0xff1e2d3b),
      ),
      body: postClass == null ? Center(child: CircularProgressIndicator(),): ListView(
        children: postClass.post.map((e) => InkWell(
          onTap: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => PostsDetail(post: e)));
          },
          child:  Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              child: ListTile(
                title: Text(e.title, style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Philosopher',fontSize: 20),),
                trailing: Icon(Icons.keyboard_arrow_right, color: Color(0xffbbbbbb),),
                ),
              decoration: BoxDecoration(
                  color: Color(0xff101823),
                  border: Border(left: BorderSide(color: Colors.orange, width: 4.0),
                )
              ),
              ),
          ),
        )).toList(),
      )
    );
  }
}
