import 'dart:async';
import 'dart:convert';

import 'package:flutter_web/material.dart';
import 'package:http/http.dart' as http;

import 'Chart5.dart';
import 'Post.dart';

List<Post> mapJobsfromJson(Map<String, dynamic> json) {
  var list = json['data'] as List;
  List<Post> jobs =
      list.map((jsonObject) => Post.fromJson(jsonObject)).toList();

  return jobs;
}

class BuildTimeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  static const app_android_main = "<Replace>";
  static const app_ios_main = "<Replace>";


  static const workflow_primary_local = "<Replace>";

  static const branch_develop = "develop";
  static const after_july = "1559347200";
  String title, app, workflow, branch, after;

  Future<List<Post>> posts;

  Future<List<Post>> fetchPost() async {
    var url =
        'https://api.bitrise.io/v0.1/apps/$app/builds?status=1&workflow=$workflow&branch=$branch&after=$after';
    final response = await http.get(url,
        headers: {
          "Authorization":
              "<Replace>"
        });

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      // Post post = Post.fromJson(json.decode(response.body));

      return mapJobsfromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  void initState() {
    super.initState();
    title = "Main App Primary";
    workflow = workflow_primary_local;
    app = app_android_main;
    branch = branch_develop;
    after = after_july;
    posts = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            SideMenuItem(
              'Android Main App Primary',
              () {
                // Update the state of the app.
                // ...
                setState(() {
                  app = app_android_main;
                  workflow = workflow_primary_local;
                  title = 'Main App Primary';
                  branch = branch_develop;
                  // after = "";
                  posts = fetchPost();
                });
              },
            ),
           
            SideMenuItem(
              'IOS Main App Primary',
              () {
                // Update the state of the app.
                // ...
                setState(() {
                  app = app_ios_main;
                  workflow = workflow_primary;
                  title = 'Main App Primary';
                  branch = branch_develop;
                  // after = "";
                  posts = fetchPost();
                });
              },
            ),
           
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('$title'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: new ContentArea(posts: posts),
        ),
      ),
    );
  }
}

class ContentArea extends StatelessWidget {
  final Future<List<Post>> posts;

  const ContentArea({
    Key key,
    @required this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: posts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return SimpleTimeSeriesChart.withRealData(snapshot
              .data); //sample1(context); //PostsListView(snapshot.data);
        } else if (snapshot.hasData) {
          return Stack(children: <Widget>[
            SimpleTimeSeriesChart.withRealData(snapshot.data),
            Center(child: CircularProgressIndicator())
          ]); //sample1(context); //PostsListView(snapshot.data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }
}

class SideMenuItem extends StatelessWidget {
  final String title;
  final VoidCallback callback;

  const SideMenuItem(this.title, this.callback);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        callback();
        // Update the state of the app.
        // ...
        Navigator.pop(context);
      },
    );
  }
}
