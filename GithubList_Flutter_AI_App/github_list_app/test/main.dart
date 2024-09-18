import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_detail_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub用户列表',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GitHubUserList(),
    );
  }
}

class GitHubUser {
  final String login;
  final String avatarUrl;

  GitHubUser({required this.login, required this.avatarUrl});

  factory GitHubUser.fromJson(Map<String, dynamic> json) {
    return GitHubUser(
      login: json['login'],
      avatarUrl: json['avatar_url'],
    );
  }
}

class GitHubUserList extends StatefulWidget {
  @override
  _GitHubUserListState createState() => _GitHubUserListState();
}

class _GitHubUserListState extends State<GitHubUserList> {
  List<GitHubUser> users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse('https://api.github.com/users'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        users = jsonData.map((user) => GitHubUser.fromJson(user)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('加载用户失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub用户'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                  title: Text(user.login),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailView(login: user.login),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}