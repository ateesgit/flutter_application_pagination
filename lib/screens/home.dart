import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scrollController =ScrollController();
  List posts = [];
  @override
  void initState() {
    // TODO: implement initState
    // super.initState();
    scrollController.addListener(_scrollListner);
    fetchPosts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12.0),
        controller: scrollController,
        itemCount: posts.length,
        itemBuilder: (context,index){
          final post = posts[index];
          final title = post['title']['rendered'];
          final discription = post['title']['rendered'];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                '${index + 1}'
              )),
             title: Text(
              title,
              maxLines: 1,
            ),
             subtitle: Text(
              discription,
              maxLines: 2,
            ),
          ),
        );
      }),
    );
  }

  Future<void> fetchPosts() async{
   const url = 'https://techcrunch.com/wp-json/wp/v2/posts?context=embed&per_page=10&page=3';
   final uri = Uri.parse(url);
   final response =await http.get(uri);
   if(response.statusCode == 200){
      //Expected Response
      final json = jsonDecode(response.body) as List;
      setState(() {
        posts = json; 
      });
   }else{
    //UnExpected response
    print("UnExpected response");
   }
  }
  void _scrollListner(){
    if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
      
    }
    print("Scrolllistner called");
    // fetchPosts();
  }
}