import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:postsapp/post_class.dart';

Future<List<Comment>> fetchPhotos(http.Client client, var url) async {
  final response =
  await client.get(url);

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Comment> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Comment>((json) => Comment.fromJson(json)).toList();
}

class Comment {
  int postId;
  int id;
  String name;
  String email;
  String body;

  Comment({this.postId, this.id, this.name, this.email, this.body});

  Comment.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    id = json['id'];
    name = json['name'];
    email = json['email'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postId'] = this.postId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['body'] = this.body;
    return data;
  }
}

class PostsDetail extends StatefulWidget {
  final Post post;
  PostsDetail({this.post});

  @override
  _PostsDetailState createState() => _PostsDetailState();
}

class _PostsDetailState extends State<PostsDetail>{
  var url = "https://jsonplaceholder.typicode.com/comments?postId=";
  @override
  Widget build(BuildContext context) {
    url += widget.post.id.toString();

    return Scaffold(
        backgroundColor: Color(0xff000000),
      appBar: AppBar(
        backgroundColor: Color(0xff1e2d3b),
        title: Text("Comments"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(18.0),
              child: Column(
                children: <Widget>[
                  Text(widget.post.title, style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Garlic Sans',fontSize: 28),),
                  SizedBox(height: 15),
                  Text(widget.post.body, style: TextStyle(
                      color: Colors.white, fontFamily: 'Garlic Sans',fontSize: 24),),
                ],
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.orange,
                  width: 2.0,
                ),
                color: Color(0xff101823),
                borderRadius: BorderRadius.circular(10),
                  )
              ),
            SizedBox(height: 20),
            Text("Comments",style: TextStyle(
                color: Colors.white, fontFamily: 'Garlic Sans',fontSize: 20),),
            Expanded(
                child: FutureBuilder<List<Comment>>(future:fetchPhotos(http.Client(),url), builder:(context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);
                        return snapshot.hasData ? CommentsList(comments: snapshot.data) : Center(child: CircularProgressIndicator());
                      },
                ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentsList extends StatelessWidget {
  final List<Comment> comments;
  CommentsList({Key key, this.comments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: ListTile(
              title: Text("From: " + comments[index].email, style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Philosopher',fontSize: 16),),
              subtitle: Text(comments[index].body, style: TextStyle(
                  color: Colors.white, fontFamily: 'Philosopher',fontSize: 12),),
            ),
            decoration: BoxDecoration(
                color: Color(0xff101823),
                border: Border(left: BorderSide(color: Colors.grey, width: 4.0),
                )
            ),
          ),
        );
          //Text(comments[index].email);
      },
    );
  }
}