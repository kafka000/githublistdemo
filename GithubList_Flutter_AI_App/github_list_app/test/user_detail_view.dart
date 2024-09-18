import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDetailView extends StatefulWidget {
  final String login;

  UserDetailView({required this.login});

  @override
  _UserDetailViewState createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView> {
  Map<String, dynamic>? userDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    final response = await http.get(Uri.parse('https://api.github.com/users/${widget.login}'));

    if (response.statusCode == 200) {
      setState(() {
        userDetails = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('加载用户详情失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.login),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userDetails == null
              ? Center(child: Text('加载失败'))
              : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(userDetails!['avatar_url']),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text('名称: ${userDetails!['name'] ?? '未知'}'),
                      Text('公开仓库数: ${userDetails!['public_repos']}'),
                      Text('关注者: ${userDetails!['followers']}'),
                      Text('关注中: ${userDetails!['following']}'),
                    ],
                  ),
                ),
    );
  }
}