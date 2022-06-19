
import 'dart:convert';
import 'package:datacall/next_page.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String url = 'https://jsonplaceholder.typicode.com/photos';
  // ignore: prefer_typing_uninitialized_variables
  var data;

  Future<void> getPhotos() async {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      data = jsonDecode(res.body.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Api Data Call'),
        backgroundColor: Colors.red,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const NextPage()));
          },
          icon: const Icon(Icons.arrow_forward, 
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: getPhotos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Text(
                        'Loading.....',
                        style: TextStyle(color: Colors.red, fontSize: 30),
                      ),
                    );
                  }
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                        data[index]['url'].toString())),
                                title: Center(
                                    child: Text(data[index]['id'].toString())),
                                subtitle: Text(data[index]['title'].toString()),
                              ),
                            ],
                          ),
                        );
                      });
                }),
          )
        ],
      ),
    );
  }
}
