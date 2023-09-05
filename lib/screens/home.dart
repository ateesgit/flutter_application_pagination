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
  bool isLoadingMore = false;
  int page = 1;
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
        itemCount:isLoadingMore? posts.length+1 : posts.length,
        itemBuilder: (context,index){
        if(index < posts.length){
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
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      }),
    );
  }

  Future<void> fetchPosts() async{
   final url = 'https://techcrunch.com/wp-json/wp/v2/posts?context=embed&per_page=10&page=$page';
   print('is===${url}');
   final uri = Uri.parse(url);
   final response =await http.get(uri);
   if(response.statusCode == 200){
      //Expected Response
      final json = jsonDecode(response.body) as List;
      setState(() {
        posts = posts+ json; 
      });
   }else{
    //UnExpected response
    print("UnExpected response");
   }
  }
  Future<void> _scrollListner() async {
    if(isLoadingMore) return;
    if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
      setState(() {
        isLoadingMore = true;
      });
      page = page + 1;
     await fetchPosts();
     setState(() {
       isLoadingMore = false;
     });
      log("call");
    }
    // print("Scrolllistner called");
    // fetchPosts();
  }
}