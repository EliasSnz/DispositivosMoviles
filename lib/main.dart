import 'package:flutter/material.dart';
import 'package:postsapp/posts_list.dart';

void main (){
  runApp(MaterialApp(
    title: "Posts App",
    home: PostsList(),
    debugShowCheckedModeBanner: false,
  ));
}