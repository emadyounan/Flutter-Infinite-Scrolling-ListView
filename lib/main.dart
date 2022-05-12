import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = ScrollController();
  int page =1;
  List<String> items =[];
  bool hasmore = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();
    
    controller.addListener(() {
      if(controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future fetch() async {
    const limited = 25;
    
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=$limited&_page=$page');
    final response = await http.get(url);

    if(response.statusCode == 200) {
      final List newlist = json.decode(response.body);

      setState(() {
        page++;

        if(newlist.length < limited) {
          hasmore = false;
        }
        items.addAll(newlist.map<String> ((items) {
          final number = items['id'];
          return 'item $number';
        }).toList());
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(5),
        controller: controller,
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if(index < items.length) {
            final item = items[index];
            return ListTile(title: Text(item),);
          }
          else
            {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: hasmore
                  ? const CircularProgressIndicator()
                  : const Text('No More Data To Load'),
                ),
              );
            }
        }
      ),
    );
  }
}
